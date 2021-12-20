use Test;

use lib './lib';
use lib '.';

use Data::Summarizers;
use Data::Reshapers;


plan 4;

## 1
ok records-summary(group-by(get-titanic-dataset(), 'passengerClass')):!say;

## 2
ok records-summary(group-by(get-titanic-dataset(), 'passengerClass')):!say;

## 3
my $res3 = records-summary(group-by(get-titanic-dataset(), 'passengerSex')):!say:hash;
isa-ok $res3, Hash;

## 4
is-deeply $res3.keys.sort, <female male>;

done-testing;
