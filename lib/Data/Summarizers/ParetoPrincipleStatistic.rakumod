use v6.d;

use Data::Reshapers;
use Data::Reshapers::TypeSystem;
use Data::Summarizers::Predicates;

unit module Data::Summarizers::ParetoPrincipleStatistic;

our proto ParetoPrincipleStatistic(|) {*};

multi ParetoPrincipleStatistic(@vec where is-numeric-vector(@vec),
                               Bool :$normalize = True,
                               Bool :$pairs = False) {
    if $pairs {
        return ParetoPrincipleStatistic( (^@vec.elems Z=> @vec).Hash, :$normalize);
    }

    # Pareto statistic computations
    my @tally = @vec.grep({ $_ ~~ Numeric }).sort.reverse;

    my @cumSum = produce(&[+], @tally);

    my $tsum = @tally.sum;
    if $normalize && $tsum != 0 {
        @cumSum = @cumSum X* 1 / $tsum;
    }

    return @cumSum;
}

multi ParetoPrincipleStatistic(@vec where is-categorical-vector(@vec),
                               Bool :$normalize = True,
                               Bool :$pairs = False) {
    if $pairs {
        my @catVals = @vec.grep({ $_ ~~ Str }).BagHash.pairs.List;
        say @catVals;
        say deduce-type(@catVals);
        return ParetoPrincipleStatistic(@catVals, :$normalize);
    } else {
        my @catVals = @vec.grep({ $_ ~~ Str }).BagHash.values;
        return ParetoPrincipleStatistic(@catVals, :$normalize, :!pairs);
    }
}

multi ParetoPrincipleStatistic(%hvec where is-numeric-vector(%hvec.values.List),
                               Bool :$normalize = True,
                               Bool :$pairs = True
        --> List) {
    # Pareto statistic computations
    my @tally = %hvec.grep({ $_.value ~~ Numeric }).sort({ -$_.value });

    my @cumSum = produce(&[+], @tally>>.value);

    my $tsum = @cumSum[*- 1];
    if $normalize && $tsum != 0 {
        @cumSum = @cumSum X* 1 / $tsum;
    }

    return $pairs ?? (@tally>>.key Z=> @cumSum).List !! @cumSum;
}

constant $strIntPairType = Data::Reshapers::TypeSystem::Pair.new(
        keyType => Data::Reshapers::TypeSystem::Atom.new(type => Str, count => 1),
        type => Data::Reshapers::TypeSystem::Atom.new(type => Int, count => 1),
        count => Any);

constant $strNumericPairType = Data::Reshapers::TypeSystem::Pair.new(
        keyType => Data::Reshapers::TypeSystem::Atom.new(type => Str, count => 1),
        type => Data::Reshapers::TypeSystem::Atom.new(type => Numeric, count => 1),
        count => Any);

multi ParetoPrincipleStatistic(@pvec where deduce-type(@pvec).type eq $strNumericPairType || deduce-type(@pvec).type eq $strIntPairType,
                               Bool :$normalize = True,
                               Bool :$pairs = True
        --> List) {
    my %hvec = @pvec.categorize({ $_.key }).deepmap({ $_.value })>>.sum;
    return ParetoPrincipleStatistic(%hvec, :$normalize, :$pairs);
}

multi ParetoPrincipleStatistic(@data where is-reshapable(Positional, Map, @data),
                               $column-names = Whatever,
                               Bool :$normalize = True,
                               Bool :$pairs = True
        --> Hash) {

    my @cdata = complete-column-names(@data);
    my @colNames;
    if $column-names.isa(Whatever) {
        @colNames = @cdata[0].keys;
    }

    my %tdata = transpose(@cdata);

    ## This is one of getting the Pareto principle statistic done.
    ## But it is better to produce a comprehensive data set instead.
    return %tdata.map({ $_.key => ParetoPrincipleStatistic($_.value, :$normalize, :$pairs) }).Hash;
}
