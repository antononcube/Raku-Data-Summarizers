unit module Data::Summarizers::Predicates;

sub is-numeric-vector($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.map({ $_ ~~ Numeric or $_ ~~ Num or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-categorical-vector($vec --> Bool) is export {
    ($vec ~~ Positional) and [and] $vec.map({ $_ ~~ Str or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-atomic-vector($vec --> Bool) is export {
    is-numeric-vector($vec) || is-categorical-vector($vec)
}
