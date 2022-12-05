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
multi NumericVectorSummary(@vec where is-numeric-vector($_), Str :$missing-value = '(Any-Nan-Nil-or-Whatever)' --> List) {
    my @nvec = @vec.grep({ $_ ~~ Numeric and $_ ne NaN });

    if @nvec.elems == 0 {
        ()
    } else {
        my @qs = do if @nvec.elems == 1 {
            # This is a bug in Stats -- the function quartile should give this result.
            (@nvec[0] xx 3).Array
        } else {
            quartiles(@nvec);
        }

        my @res =
                (
                'Min' => @nvec.min,
                '1st-Qu' => @qs[0],
                'Mean' => mean(@nvec),
                'Median' => @qs[1],
                '3rd-Qu' => @qs[2],
                'Max' => @nvec.max);

        if @nvec.elems < @vec.elems {
            @res.append( $missing-value => (@vec.elems - @nvec.elems))
        }

        @res
    }
}

#-----------------------------------------------------------
multi NumericVectorSummary(@vec where is-date-time-vector(@vec), Str :$missing-value = '(Any-Nan-Nil-or-Whatever)' --> List) {
    my @nvec = @vec>>.Numeric>>.Int.List;
    @nvec = NumericVectorSummary(@nvec, :$missing-value);
    return @nvec.map({ $_.key => DateTime.new($_.value) }).List;
}

#-----------------------------------------------------------
multi NumericVectorSummary(@vec where is-dateish-vector(@vec), Str :$missing-value = '(Any-Nan-Nil-or-Whatever)' --> List) {
    return NumericVectorSummary(@vec>>.DateTime.List, :$missing-value);
}

#===========================================================
our proto CategoricalVectorSummary(|) is export {*}

#-----------------------------------------------------------
multi CategoricalVectorSummary(@vec where is-categorical-vector($_),
                               UInt :$max-tallies = 7,
                               Str :$missing-value = '(Any-Nan-Nil-or-Whatever)' --> List) {

    my @r = @vec.grep({ $_ ~~ Str }).classify({ $_ }).map({ $_.key => $_.value.elems }).Array;

    @r = @r.sort({ - $_.value });

    my $whateverCounts = @vec.grep({ ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) }).elems;

    if @r.elems > $max-tallies {
        @r = @r[^$max-tallies].Array.append(('(Other)' => @r.[$max-tallies .. *- 1].map({ $_.value }).sum));
    }

    if $whateverCounts > 0 {
        @r = @r.append($missing-value => $whateverCounts)
    }

    @r
}

#===========================================================
our proto AtomicVectorSummary(|) is export {*}

#-----------------------------------------------------------
multi AtomicVectorSummary(@vec where is-atomic-vector($_),
                          UInt :$max-tallies = 7,
                          :$missing-value = '(Any-Nan-Nil-or-Whatever)' --> List) {
    return CategoricalVectorSummary( @vec.map({ ($_ ~~ Numeric) ?? $_.Str !! $_ }).Array, :$max-tallies, :$missing-value)
}

#===========================================================
our proto RecordsSummary(|) is export {*}

#-----------------------------------------------------------
multi RecordsSummary($dataRecords, UInt :$max-tallies = 7, :$missing-value = '(Any-Nan-Nil-or-Whatever)') {
    if is-numeric-vector($dataRecords) || is-dateish-vector($dataRecords) {
        NumericVectorSummary($dataRecords, :$missing-value)
    } elsif is-categorical-vector($dataRecords) {
        CategoricalVectorSummary($dataRecords, :$max-tallies, :$missing-value)
    } elsif has-homogeneous-hash-types($dataRecords) {
        transpose($dataRecords).map({ $_.key => RecordsSummary($_.value, :$max-tallies, :$missing-value) })
    } elsif has-homogeneous-array-types($dataRecords) {
        my $k = 0;
        transpose($dataRecords).map({ ($k++).Str => RecordsSummary($_.value, :$max-tallies, :$missing-value) })
    } elsif is-atomic-vector($dataRecords) {
        AtomicVectorSummary($dataRecords, :$max-tallies, :$missing-value)
    } elsif is-iterable-of-iterable($dataRecords) {
        my $recs = $dataRecords>>.Array.map({ (0...^$_.elems) Z=> $_ })>>.Hash;
        RecordsSummary($recs, :$max-tallies, :$missing-value);
    } else {
        note 'Do not know how to summarize the argument.';
        ()
    }
}