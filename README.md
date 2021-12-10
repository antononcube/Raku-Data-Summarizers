# Raku Data::Summarizers

[![Build Status](https://app.travis-ci.com/antononcube/Raku-Data-Summarizers.svg?branch=main)](https://app.travis-ci.com/github/antononcube/Raku-Data-Summarizers)
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

This Raku package has data summarizing functions for different data structures that are 
coercible to full arrays.

The supported data structures (so far) are:
  - 1D Arrays
  - 1D Lists  
  - Positional-of-hashes
  - Positional-of-arrays

------

## Usage examples

### Setup

Here we load the Raku modules 
[`Data::Generators`](https://modules.raku.org/dist/Data::Generators:cpan:ANTONOV),
[`Data::Reshapers`](https://modules.raku.org/dist/Data::Reshapers:cpan:ANTONOV)
and this module,
[`Data::Summarizers`](https://github.com/antononcube/Raku-Data-Summarizers):

```perl6
use Data::Generators;
use Data::Reshapers;
use Data::Summarizers;
```
```
# (Any)
```

### Summarize vectors

Here we generate a numerical vector, place some NaN's or Whatever's in it:

```perl6
my @vec = [^1001].roll(12);
@vec = @vec.append( [NaN, Whatever, Nil]);
@vec .= pick(@vec.elems);
@vec
```
```
# [NaN (Any) 895 140 605 293 785 (Whatever) 8 82 274 211 578 746 621]
```

Here we summarize the vector generated above:

```perl6
records-summary(@vec)
```
```
# +------------------------------------+
# | numerical                          |
# +------------------------------------+
# | Median                    => 435.5 |
# | 1st-Qu                    => 175.5 |
# | Mean                      => 436.5 |
# | Max                       => 895   |
# | (Any-Nan-Nil-or-Whatever) => 3     |
# | Min                       => 8     |
# | 3rd-Qu                    => 683.5 |
# +------------------------------------+
```

### Summarize tabular datasets

Here we generate a random tabular dataset with 20 rows and 4 columns and display it:

```perl6
srand(32);
my $tbl = random-tabular-dataset(16, <Pet Ref Code>, generators=>[random-pet-name(4), &random-word, random-string(6)]);
to-pretty-table($tbl)
```
```
# +-----------------------+----------------+--------------+
# |          Pet          |      Code      |     Ref      |
# +-----------------------+----------------+--------------+
# |        Atticus        | CQmrQcQ4YkXvaD |   Western    |
# |       Ginny Lee       |       aY       |    frost     |
# | Durango Fucking Boots | xgZjtSP6VrKbH  |     drip     |
# | Durango Fucking Boots |       aY       |  binominal   |
# |         Gavin         | xgZjtSP6VrKbH  |   jangling   |
# | Durango Fucking Boots | A2Ue69EWAMtJCi |     fort     |
# |       Ginny Lee       |    20CO9FGD    |   Marquand   |
# |       Ginny Lee       | xgZjtSP6VrKbH  |     umbo     |
# |         Gavin         | A2Ue69EWAMtJCi |   Collins    |
# | Durango Fucking Boots | A2Ue69EWAMtJCi | shoot-'em-up |
# |         Gavin         | KNwmt0QmoqABwR |   epicarp    |
# |        Atticus        |       aY       |    Alsace    |
# |         Gavin         | xgZjtSP6VrKbH  |   invasive   |
# |         Gavin         | KNwmt0QmoqABwR |   exanthem   |
# |       Ginny Lee       | xgZjtSP6VrKbH  |   nighted    |
# |         Gavin         | xgZjtSP6VrKbH  |  procurable  |
# +-----------------------+----------------+--------------+
```

**Remark:** The values of the column "Pet" is sampled from a set of four pet names, and the values of the column
and "Code" is sampled from a set of 6 strings.

Here we summarize the tabular dataset generated above:

```perl6
records-summary($tbl)
```
```
# +----------------------------+-------------------+---------------------+
# | Pet                        | Ref               | Code                |
# +----------------------------+-------------------+---------------------+
# | Gavin                 => 6 | umbo         => 1 | xgZjtSP6VrKbH  => 6 |
# | Ginny Lee             => 4 | jangling     => 1 | A2Ue69EWAMtJCi => 3 |
# | Durango Fucking Boots => 4 | Western      => 1 | aY             => 3 |
# | Atticus               => 2 | nighted      => 1 | KNwmt0QmoqABwR => 2 |
# |                            | shoot-'em-up => 1 | CQmrQcQ4YkXvaD => 1 |
# |                            | drip         => 1 | 20CO9FGD       => 1 |
# |                            | Alsace       => 1 |                     |
# |                            | (Other)      => 9 |                     |
# +----------------------------+-------------------+---------------------+
```

### Skim

*TBD...*

------

## TODO

*TBD...*

------

## References

### Functions, repositories

[AAf1] Anton Antonov,
[RecordsSummary](https://resources.wolframcloud.com/FunctionRepository/resources/RecordsSummary),
(2019),
[Wolfram Function Repository](https://resources.wolframcloud.com/FunctionRepository).
