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
use Data::Reshapers::ToPrettyTable;

unit module Data::Summarizers;

#===========================================================
#| Tallies the elements in C<@data>, listing all distinct elements together with their multiplicities.
proto tally(@data, |) is export {*}

multi sub tally(@data) {
    my %counts;
    %counts{$_}++ for @data;
    return %counts;
}

#
# Use C<&test> to determine whether pairs of elements should be considered equivalent,
# and gives a list of the first representatives of each equivalence class, together with their multiplicities.
#multi sub tally(@data, &test) {
#    my %counts;
#    @data.categorize(&test, into=>%counts);
#    return %counts;
#}

#===========================================================
sub records-summary($data, UInt :$max-tallies = 7, :$missing-value is copy = Whatever, Bool :$hash = False, Bool :$say = True) is export {

    if $missing-value.isa(Whatever) {
        $missing-value = '(Any-Nan-Nil-or-Whatever)';
    }

    ## If a hash of datasets delegate appropriately.
    if ($data ~~ Map) and ([and] $data.map({ has-homogeneous-shape($_) })) {

        return $data.map({
                if $say { say("summary of { $_.key } =>") }
                $_.key => records-summary($_.value, :$max-tallies, :$missing-value, :$hash, :$say, :$missing-value)
            }).Hash;

    }

    if is-reshapable(Positional, Array, $data) &&
            has-homogeneous-shape($data) &&
            ([and] $data.map({ [and] $_.map({ $_ ~~ Pair }) })) {
        return records-summary(CompleteColumnNames($data>>.Hash), :$max-tallies, :$missing-value, :$hash, :$say);
    }


    my %summary = Data::Summarizers::RecordsSummary::RecordsSummary($data, :$max-tallies, :$missing-value);

    if is-numeric-vector($data) {
        %summary = 'numerical' => %summary.pairs
    } elsif is-categorical-vector($data) {
        %summary = 'categorical' => %summary.pairs
    }

    if $hash {
        if is-hash-of-seqs(%summary) {
            return %summary.map({ $_.key => $_.value.Hash }).Hash;
        } else {
            return %summary;
        }
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

    my $res = transpose(%summary2).values;

    if $say {
        say to-pretty-table($res, align => 'l');
    }
    return $res;
}