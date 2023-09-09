#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use Data::Summarizers;
use Data::Reshapers;
use Data::Generators;

##===========================================================
my @rvec = random-variate(NormalDistribution.new, 12).Array.append([Nil, Nil]).pick(*);
say @rvec.raku;
# records-summary(@rvec);
say "HERE:\n", records-summary(@rvec):!say;

##===========================================================
say "=" x 60;
my @vec = [^1001].roll(12);
@vec = @vec.append([NaN, Whatever, Nil]);
@vec .= pick(@vec.elems);

say @vec;
say "Hash : ", records-summary(@vec):hash;

records-summary(@vec);

say records-summary(@vec, :hash)<numerical>:exists;
say records-summary(@vec, :hash)<numerical>;
say records-summary(@vec, :hash)<numerical><(Any-Nan-Nil-or-Whatever)>;

##===========================================================
say "=" x 60;
my @svec = <bar car mask element charisma smack churn>.roll(15);
@svec = @svec.append([Whatever, Nil].roll(3));
@svec .= pick(@svec.elems);

say @svec.raku;
say records-summary(@svec, max-tallies => 12);
say records-summary(@svec, max-tallies => 2);

say records-summary(@svec, :hash)<categorical>:exists;
say records-summary(@svec, :hash)<categorical>;
say records-summary(@svec, :hash)<categorical><(Any-Nan-Nil-or-Whatever)>;

##===========================================================
say "=" x 60;
my @tbl0 = get-titanic-dataset(headers => 'auto');
@tbl0 = @tbl0.map({
    $_<passengerAge> = $_<passengerAge>.Numeric;
    $_
});
@tbl0 = @tbl0.map({
    $_<id> = $_<id>.Numeric;
    $_
});

records-summary(@tbl0);

my @tbl1 = get-titanic-dataset(headers => 'none');

##===========================================================
say "=" x 60;
my $tbl2 = random-tabular-dataset(30, 5);

say to-pretty-table($tbl2);

records-summary($tbl2);

##===========================================================
say "=" x 60;
say " Summary of group-by result";
say "=" x 60;
my $tbl4 = random-tabular-dataset(6, <Pet Data>, generators => [random-pet-name(2), -> $n { ((^20).rand xx $n).List }]);

say to-pretty-table($tbl4);

say records-summary(group-by($tbl4, 'Pet'), :!say, :hash);

#my $tbl5 = get-titanic-dataset();
# say records-summary(group-by($tbl5, 'passengerClass'), :!say, :hash);

#say records-summary(group-by($tbl5, 'passengerClass').values, :!say, :hash);

##===========================================================
say "=" x 60;
say " Tally";
say "=" x 60;
say (^11).roll(200);
say tally((^11).roll(200));

my @dsRand = random-tabular-dataset(120, <A B C>, generators => { A => <A1 A1>, B => [1, 2], C => <m b r> });

records-summary(@dsRand, field-names => <A B C>);

say tally(@dsRand);

say tally(@dsRand, as => &gist);

##===========================================================
my @dts0 = [DateTime.new(2022,1,1,2,9,0), DateTime.new(2022,1,1,11,35,0),
 DateTime.new(2022,1,1,11,36,0), DateTime.new(2022,1,1,12,2,0),
 DateTime.new(2022,1,1,12,2,0), DateTime.new(2022,1,1,12,2,0),
 DateTime.new(2022,1,1,12,3,0), DateTime.new(2022,1,1,13,34,0),
 DateTime.new(2022,1,1,13,35,0), DateTime.new(2022,1,1,19,30,0),
 DateTime.new(2022,1,1,19,32,0), DateTime.new(2022,1,1,19,36,0),
 DateTime.new(2022,1,1,19,38,0)];

my @dts = [DateTime.new(2022,1,1,2,9,0), DateTime.new(2022,1,1,11,35,0),
             DateTime.new(2022,1,1,11,36,0), DateTime.new(2022,1,1,12,2,0),
             DateTime.new(2022,1,1,12,2,0), DateTime.new(2022,1,1,12,2,0),
             DateTime.new(2022,1,1,12,3,0), DateTime.new(2022,1,1,13,34,0),
             Date.new(2022,1,1), Date.new(2022,1,3),
             Date.new(2022,1,23), DateTime.new(2022,1,1,19,36,0),
             DateTime.new(2022,1,1,19,38,0)];

say @dts.raku;

records-summary(@dts);

