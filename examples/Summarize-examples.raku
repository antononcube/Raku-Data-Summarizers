#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use Data::Summarizers;
use Data::Reshapers;
use Pretty::Table;

##===========================================================
say "=" x 60;
my @vec = [^1001].roll(12);
@vec = @vec.append( [NaN, Whatever].roll(3));
@vec .= roll(@vec.elems);

say @vec;
say records-summary(@vec);

##===========================================================
say "=" x 60;
my @svec = <bar car mask element charisma smack churn>.roll(15);
@svec = @svec.append( [Whatever].roll(3));
@svec .= roll(@svec.elems);

say @svec;
say records-summary(@svec, max-tallies => 12);
say records-summary(@svec, max-tallies => 2);

##===========================================================
say "=" x 60;
my $tbl0 = get-titanic-dataset(headers => 'auto');
$tbl0 = $tbl0.map({ $_<passengerAge> = $_<passengerAge>.Numeric; $_ });
$tbl0 = $tbl0.map({ $_<id> = $_<id>.Numeric; $_ });

records-summary($tbl0);

my @tbl1 = get-titanic-dataset(headers => 'none');
