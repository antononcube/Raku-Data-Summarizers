use Test;

use lib './lib';
use lib '.';

use Data::Summarizers;
use Data::Reshapers;

my %starWarsHomeworldGroups =
        "Bestine IV" => $[{:birth_year(0), :eye_color("blue"), :gender("masculine"), :hair_color("brown"), :height(180), :homeworld("Bestine IV"), :mass(110), :name("Jek Tono Porkins"), :sex("male"), :skin_color("fair"), :species("Human")},],
        :Corellia($[{:birth_year(29), :eye_color("brown"), :gender("masculine"), :hair_color("brown"), :height(180), :homeworld("Corellia"), :mass(80), :name("Han Solo"), :sex("male"), :skin_color("fair"), :species("Human")}, {:birth_year(21), :eye_color("hazel"), :gender("masculine"), :hair_color("brown"), :height(170), :homeworld("Corellia"), :mass(77), :name("Wedge Antilles"), :sex("male"), :skin_color("fair"), :species("Human")}]),
        :Kalee($[{:birth_year(0), :eye_color("green, yellow"), :gender("masculine"), :hair_color("none"), :height(216), :homeworld("Kalee"), :mass(159), :name("Grievous"), :sex("male"), :skin_color("brown, white"), :species("Kaleesh")},]),
        :Rodia($[{:birth_year(44), :eye_color("black"), :gender("masculine"), :hair_color(0), :height(173), :homeworld("Rodia"), :mass(74), :name("Greedo"), :sex("male"), :skin_color("green"), :species("Rodian")},]),
        :Sullust($[{:birth_year(0), :eye_color("black"), :gender("masculine"), :hair_color("none"), :height(160), :homeworld("Sullust"), :mass(68), :name("Nien Nunb"), :sex("male"), :skin_color("grey"), :species("Sullustan")},]);

plan 5;

## 1
ok records-summary(group-by(get-titanic-dataset(), 'passengerClass')):!say;

## 2
ok records-summary(group-by(get-titanic-dataset(), 'passengerClass')):!say;

## 3
my $res3 = records-summary(group-by(get-titanic-dataset(), 'passengerSex')):!say:hash;
isa-ok $res3, Hash;

## 4
is-deeply $res3.keys.sort, <female male>;

## 5
ok records-summary(%starWarsHomeworldGroups), "starwars groups summary";

done-testing;
