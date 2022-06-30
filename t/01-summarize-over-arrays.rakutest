use Test;

use lib './lib';
use lib '.';

use Data::Summarizers;


plan 12;

## 1
my @rvec0 = [1.1119354090487388e0, -0.5276029723160978e0, -1.4694090373267708e0, -0.02294240500796829e0, -0.46719311015864573e0, 0.657439943197275e0, 1.6965269617685679e0, 1.4615314707077254e0, 0.6278073353159589e0, -1.4339916571623756e0, 0.05621447590292126e0, 0.38869158674093235e0];
ok records-summary(@rvec0):!say;

## 2
my @rvec1 = [1.1119354090487388e0, -0.5276029723160978e0, -1.4694090373267708e0, -0.02294240500796829e0, -0.46719311015864573e0, 0.657439943197275e0, 1.6965269617685679e0, Any, 1.4615314707077254e0, 0.6278073353159589e0, -1.4339916571623756e0, Any, 0.05621447590292126e0, 0.38869158674093235e0];
ok records-summary(@rvec1):!say;

## 3
my @vec = [^1001].roll(12);
@vec = @vec.append([NaN, Whatever, Nil]);
@vec .= pick(@vec.elems);
ok records-summary(@vec):hash;

## 4
isa-ok records-summary(@vec, :hash), Hash;

## 5
is records-summary(@vec, :hash)<numerical>:exists, True;

## 6
is records-summary(@vec, :hash)<numerical><(Any-Nan-Nil-or-Whatever)>:exists, True;

## 7
is records-summary(@vec, :hash)<numerical><(Any-Nan-Nil-or-Whatever)> == 3, True;

## 8
my @svec = <bar car mask element charisma smack churn>.roll(15);
@svec = @svec.append( [Whatever, Nil].roll(3));
@svec .= pick(@svec.elems);
isa-ok records-summary(@svec, :hash), Hash;

## 9
is records-summary(@svec, :hash)<categorical>:exists, True;

## 10
is records-summary(@svec, :hash)<categorical><(Any-Nan-Nil-or-Whatever)>:exists, True;

## 11
is records-summary(@svec, :hash)<categorical><(Any-Nan-Nil-or-Whatever)> == 3, True;

## 12
my $vec12 = ['a', 'b', 3, 3, Nil, Whatever];
is records-summary($vec12, :hash)<(Any-Nan-Nil-or-Whatever)> == 2, True;

done-testing;
