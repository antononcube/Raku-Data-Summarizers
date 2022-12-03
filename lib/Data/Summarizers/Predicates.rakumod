
# Since this Raku module depends on "Data::Reshapers"
# these functions are "obsolete" -- the type system of "Data::Reshapers" can be used instead.

unit module Data::Summarizers::Predicates;

sub is-numeric-vector($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.map({ $_ ~~ Numeric or $_ ~~ Num or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-categorical-vector($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.map({ $_ ~~ Str or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-atomic-vector($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.map({ $_ ~~ Str or $_ ~~ Numeric or $_ ~~ Num or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-hash-of-seqs($vec --> Bool) is export {
    ($vec ~~ Map) and [and] $vec.values.map({ $_ ~~ Seq })
}

sub is-positional-of-poisitionals($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.values.map({ $_ ~~ Positional })
}

sub is-iterable-of-iterable($vec --> Bool) is export {
    ($vec ~~ Iterable) and [and] $vec.values.map({ $_ ~~ Iterable })
}
