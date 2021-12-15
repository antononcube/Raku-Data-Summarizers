=begin pod

=head1 Data::Summarizers

C<Data::Summarizers> package has data reshaping functions for
different data structures (full arrays, Red tables, Text::CSV tables.)

=head1 Synopsis

    use Data::Reshapers;
    use Data::Summarizers;

    # Using a function from data::Reshapers
    my @tbl = get-titanic-dataset(headers => "auto");

    # Summarize the table
    records-summary(@tbl);

    # Group by passengerClass and summarize
    records-summary(group-by(@tbl, "passengerClass"));

=end pod

use Data::Summarizers::RecordsSummary;
use Data::Summarizers::Predicates;
use Data::Reshapers;
use Data::Reshapers::Predicates;

unit module Data::Summarizers;

#===========================================================
sub records-summary($data, UInt :$max-tallies = 7, Bool :$as-hash = False, Bool :$say = True) is export {


    if $data ~~ Map and ([&] $data.map({has-homogeneous-shape($_)})) {
        if $say {
            return $data.map({
                say("summary of { $_.key } =>"); records-summary($_.value, :$max-tallies, :$as-hash, :$say)
            })
        } else {
            return $data.map({
                $_.key => records-summary($_.value, :$max-tallies, :$as-hash, :$say)
            }).Hash
        }
    }

    my %summary = Data::Summarizers::RecordsSummary::RecordsSummary($data, :$max-tallies);

    if is-numeric-vector($data) {
        %summary = 'numerical' => %summary.pairs
    } elsif is-categorical-vector($data) {
        %summary = 'categorical' => %summary.pairs
    }

    if $as-hash {
        return %summary.map({ $_.key => $_.value.Hash }).Hash;
    }

    my $maxSize = %summary.map({ $_.value.elems }).max;

    my %summary2 =
            do for %summary.kv -> $k, $v {
                my $maxKeySize = max(0, $v.map({ $_.key.Str.chars }).max);
                my @res is Array = $v.map({ $_.key ~ (' ' x ($maxKeySize - $_.key.chars)) ~ ' => ' ~ $_.value });
                if $maxSize - $v.elems > 0 {
                    @res = @res.Array.append("".roll($maxSize - $v.elems).Array)
                }
                $k => @res.Array
            }

    my $res = to-pretty-table(transpose(%summary2).values, align => 'l');

    if $say {
        say $res;
    }
    return $res;
}