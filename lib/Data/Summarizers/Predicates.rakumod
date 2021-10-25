unit module Data::Summarizers::Predicates;

sub is-numeric-vector(@vec --> Bool) is export {
    [and] @vec.map({ $_ ~~ Numeric or $_.isa(NaN) or $_.isa(Whatever) })
}

sub is-categorical-vector(@vec --> Bool) is export {
    [and] @vec.map({ $_ ~~ Str or $_.isa(Whatever) })
}
