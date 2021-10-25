=begin pod

=head1 Data::Summarizers::RecordsSummary

C<Data::Summarizers::RecordsSummary> package module has data record summary functions over
different data structures coercible to full-arrays.

=head1 Synopsis

    use Data::Reshapers;
    use Data::Summarizers::RecordSummary;

    @tbl = get-titanic-dataset();
    say to-pretty-table(RecordsSummary(@tbl));

=end pod

use Stats;
use Data::Summarizers::Predicates;
use Data::Reshapers::Predicates;
use Data::Reshapers;

unit module Data::Summarizers::RecordsSummary;

#===========================================================
our proto NumericVectorSummary(|) is export {*}

#-----------------------------------------------------------
multi NumericVectorSummary(@vec where is-numeric-vector($_) --> List) {
    my @nvec = @vec.grep({ $_ ~~ Numeric and !$_.isa(NaN) });

    if @nvec.elems == 0 {
        ()
    } else {
        my @qs = quartiles(@nvec);

        my @res =
                (
                'Min' => @nvec.min,
                '1st-Qu' => @qs[0],
                'Mean' => mean(@nvec),
                'Median' => @qs[1],
                '3rd-Qu' => @qs[2],
                'Max' => @nvec.max,
                );

        if @nvec.elems < @vec.elems {
            @res.append('(NaN-or-Whatever)' => (@vec.elems - @nvec.elems))
        }

        @res
    }
}

#===========================================================
our proto CategoricalVectorSummary(|) is export {*}

#-----------------------------------------------------------
multi CategoricalVectorSummary(@vec where is-categorical-vector($_), UInt :$max-tallies = 7 --> List) {

    my @r = @vec.grep({ $_ ~~ Str }).classify({ $_ }).map({ $_.key => $_.value.elems });

    @r = @r.sort({ - $_.value });

    my $whateverCounts = @vec.grep({ $_.isa(Whatever) }).elems;

    if @r.elems > $max-tallies {
        @r = @r[^$max-tallies].Array.append(('(Other)' => @r.[$max-tallies .. *- 1].map({ $_.value }).sum))
    }

    if $whateverCounts > 0 {
        @r = @r.append(('(Whatever)' => $whateverCounts))
    }

    @r
}

#===========================================================
our proto RecordsSummary(|) is export {*}

#-----------------------------------------------------------
multi RecordsSummary($dataRecords, UInt :$max-tallies = 7) {
    if is-numeric-vector($dataRecords) {
        NumericVectorSummary($dataRecords);
    } elsif is-categorical-vector($dataRecords) {
        CategoricalVectorSummary($dataRecords, :$max-tallies);
    } elsif has-homogeneous-hash-types($dataRecords) {
        transpose($dataRecords).map({ $_.key => RecordsSummary($_.value, :$max-tallies) })
    } elsif has-homogeneous-array-types($dataRecords) {
        my $k = 0;
        transpose($dataRecords).map({ ($k++).Str => RecordsSummary($_.value, :$max-tallies) })
    } else {
        note 'The first argument is expected to be an array that can be coerced into full two-dimensional array.'
    }
}