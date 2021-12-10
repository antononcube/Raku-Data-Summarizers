unit module Data::Summarizers::Predicates;

sub is-numeric-vector(@vec --> Bool) is export {
    [and] @vec.map({ $_ ~~ Numeric or $_ ~~ Num or ($_ eqv Any) or $_.isa(Nil) or $_.isa(Whatever) })
}

sub is-categorical-vector(@vec --> Bool) is export {
    [and] @vec.map({ $_ ~~ Str or $_.isa(Whatever) })
}
