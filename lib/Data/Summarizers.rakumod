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

use Data::Summarizers::ParetoPrincipleStatistic;
use Data::Summarizers::Predicates;
use Data::Summarizers::RecordsSummary;
use Data::Reshapers;
use Data::Reshapers::Predicates;
use Data::Reshapers::ToPrettyTable;

unit module Data::Summarizers;

#===========================================================
#| Tallies the elements in C<@data>, listing all distinct elements together with their multiplicities.
#| C<@data> -- data to find tally for.
#| C<:&as> -- function to be applied to the elements before comparing them.
proto tally($data, |) is export {*}

multi sub tally(@data, :&as = WhateverCode) {
    if &as.isa(WhateverCode) {
        return @data.BagHash.Hash
    } else {
        return @data.map({ &as($_) }).List.BagHash.Hash
    }
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
#| Summarize data.
#| C<$data> -- Data to be summarized.
#| C<:$max-tallies> -- Max number of unique non-numeric elements to show.
#| C<:$missing-value> -- How to mark missing values.
#| C<:$hash> -- Should a hash be returned or not?
#| C<:$say> -- Should the summary be printed out or not?
#| C<:$field-names> -- Column (field) names to show.
our sub records-summary($data,
                        UInt :$max-tallies = 7,
                        :$missing-value is copy = Whatever,
                        Bool :$hash = False,
                        Bool :$say = True,
                        :$field-names = Whatever) is export {

    if $missing-value.isa(Whatever) {
        $missing-value = '(Any-Nan-Nil-or-Whatever)';
    }

    ## If a hash of datasets delegate appropriately.
    if ($data ~~ Map) and ([and] $data.map({ has-homogeneous-shape($_) })) {

        return $data.map({
                if $say { say("summary of { $_.key } =>") }
                $_.key => records-summary($_.value, :$max-tallies, :$missing-value, :$hash, :$say, :$field-names)
            }).Hash;

    }

    if is-reshapable(Positional, Array, $data) &&
            has-homogeneous-shape($data) &&
            ([and] $data.map({ [and] $_.map({ $_ ~~ Pair }) })) {
        return records-summary(CompleteColumnNames($data>>.Hash), :$max-tallies, :$missing-value, :$hash, :$say, :$field-names);
    }


    my %summary = Data::Summarizers::RecordsSummary::RecordsSummary($data, :$max-tallies, :$missing-value);

    if is-numeric-vector($data) {
        %summary = 'numerical' => %summary.pairs
    } elsif is-categorical-vector($data) {
        %summary = 'categorical' => %summary.pairs
    } elsif is-date-time-vector($data) {
        %summary = 'date-time' => %summary.pairs
    } elsif is-datish-vector($data) {
        %summary = 'datish' => %summary.pairs
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
        say to-pretty-table($res, align => 'l', :$field-names);
    }
    return $res;
}

#===========================================================
#| Compute Pareto principle statistic.
#| C<$data> - Can be a vector of numbers, a vector of strings, a hash with numeric values, a vector of string-numeric pairs, or a dataset.
#| C<:$normalize> - Should the cumulative sums of the Pareto principle statistic be normalized or not?
#| C<:$hash> - Should the results e in hash or not? Does not
our proto pareto-principle-statistic($data, :$normalize, :$pairs) is export {*}

multi pareto-principle-statistic($data, Bool :$normalize = True, :$pairs is copy = Whatever) {

    if $pairs.isa(Whatever) {
        $pairs = do given $data {
            when $_ ~~ Positional && $_.all ~~ Pair { True }
            when $_ ~~ Map { True }
            default { False }
        }
    }

    die 'The argument pairs is expected to be Boolean or Whatever' unless $pairs ~~ Bool;

    return Data::Summarizers::ParetoPrincipleStatistic::ParetoPrincipleStatistic($data, :$normalize, :$pairs);
}