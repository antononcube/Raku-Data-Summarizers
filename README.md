# Raku Data::Summarizers

[![SparkyCI](http://sparrowhub.io:2222/project/gh-antononcube-Raku-Data-Summarizers/badge)](http://sparrowhub.io:2222)
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
# [740 311 434 300 (Whatever) 192 705 202 576 561 544 NaN (Any) 744 133]
```

Here we summarize the vector generated above:

```perl6
records-summary(@vec)
```
```
# O────────────────────────────────────O
# │ numerical                          │
# O────────────────────────────────────O
# │ 1st-Qu                    => 251   │
# │ Max                       => 744   │
# │ Median                    => 489   │
# │ (Any-Nan-Nil-or-Whatever) => 3     │
# │ Mean                      => 453.5 │
# │ Min                       => 133   │
# │ 3rd-Qu                    => 640.5 │
# O────────────────────────────────────O
```

### Summarize tabular datasets

Here we generate a random tabular dataset with 16 rows and 3 columns and display it:

```perl6
srand(32);
my $tbl = random-tabular-dataset(16, 
                                 <Pet Ref Code>,
                                 generators=>[random-pet-name(4), -> $n { ((^20).rand xx $n).List }, random-string(6)]);
to-pretty-table($tbl)
```
```
# O────────────────O───────────O──────────O
# │      Code      │    Ref    │   Pet    │
# O────────────────O───────────O──────────O
# │ A2Ue69EWAMtJCi │  0.050176 │ Guinness │
# │ KNwmt0QmoqABwR │  0.731900 │ Truffle  │
# │ A2Ue69EWAMtJCi │  0.739763 │  Jumba   │
# │       aY       │  7.342107 │ Guinness │
# │ xgZjtSP6VrKbH  │ 19.868591 │  Jumba   │
# │    20CO9FGD    │ 12.956172 │  Jumba   │
# │    20CO9FGD    │ 15.854088 │ Guinness │
# │ A2Ue69EWAMtJCi │  4.774780 │ Guinness │
# │ A2Ue69EWAMtJCi │ 18.729798 │ Guinness │
# │ xgZjtSP6VrKbH  │ 13.383997 │ Guinness │
# │       aY       │  9.837488 │  Jumba   │
# │    20CO9FGD    │  2.912506 │ Truffle  │
# │ xgZjtSP6VrKbH  │ 11.782221 │ Truffle  │
# │ KNwmt0QmoqABwR │  9.825102 │ Truffle  │
# │ xgZjtSP6VrKbH  │ 16.277717 │  Jumba   │
# │ CQmrQcQ4YkXvaD │  1.740695 │ Guinness │
# O────────────────O───────────O──────────O
```

**Remark:** The values of the column "Pet" is sampled from a set of four pet names, and the values of the column
and "Code" is sampled from a set of 6 strings.

Here we summarize the tabular dataset generated above:

```perl6
records-summary($tbl)
```
```
# O───────────────O──────────────────────────────O─────────────────────O
# │ Pet           │ Ref                          │ Code                │
# O───────────────O──────────────────────────────O─────────────────────O
# │ Guinness => 7 │ Min    => 0.0501758995572299 │ xgZjtSP6VrKbH  => 4 │
# │ Jumba    => 5 │ 1st-Qu => 2.3266005718178704 │ A2Ue69EWAMtJCi => 4 │
# │ Truffle  => 4 │ Mean   => 9.175443804770861  │ 20CO9FGD       => 3 │
# │               │ Median => 9.831294839627123  │ KNwmt0QmoqABwR => 2 │
# │               │ 3rd-Qu => 14.619042446877677 │ aY             => 2 │
# │               │ Max    => 19.868590809216744 │ CQmrQcQ4YkXvaD => 1 │
# O───────────────O──────────────────────────────O─────────────────────O
```

### Summarize collections of tabular datasets 

Here is a hash of tabular datasets:

```raku
my %group = group-by($tbl, 'Pet');

%group.pairs.map({ say("{$_.key} =>"); say to-pretty-table($_.value) });
```
```
# Guinness =>
# O────────────────O───────────O──────────O
# │      Code      │    Ref    │   Pet    │
# O────────────────O───────────O──────────O
# │ A2Ue69EWAMtJCi │  0.050176 │ Guinness │
# │       aY       │  7.342107 │ Guinness │
# │    20CO9FGD    │ 15.854088 │ Guinness │
# │ A2Ue69EWAMtJCi │  4.774780 │ Guinness │
# │ A2Ue69EWAMtJCi │ 18.729798 │ Guinness │
# │ xgZjtSP6VrKbH  │ 13.383997 │ Guinness │
# │ CQmrQcQ4YkXvaD │  1.740695 │ Guinness │
# O────────────────O───────────O──────────O
# Truffle =>
# O─────────O───────────O────────────────O
# │   Pet   │    Ref    │      Code      │
# O─────────O───────────O────────────────O
# │ Truffle │  0.731900 │ KNwmt0QmoqABwR │
# │ Truffle │  2.912506 │    20CO9FGD    │
# │ Truffle │ 11.782221 │ xgZjtSP6VrKbH  │
# │ Truffle │  9.825102 │ KNwmt0QmoqABwR │
# O─────────O───────────O────────────────O
# Jumba =>
# O───────────O────────────────O───────O
# │    Ref    │      Code      │  Pet  │
# O───────────O────────────────O───────O
# │  0.739763 │ A2Ue69EWAMtJCi │ Jumba │
# │ 19.868591 │ xgZjtSP6VrKbH  │ Jumba │
# │ 12.956172 │    20CO9FGD    │ Jumba │
# │  9.837488 │       aY       │ Jumba │
# │ 16.277717 │ xgZjtSP6VrKbH  │ Jumba │
# O───────────O────────────────O───────O
```

Here is the summary of that collection of datasets:

```raku
records-summary(%group)
```
```
# summary of Guinness =>
# O──────────────────────────────O─────────────────────O───────────────O
# │ Ref                          │ Code                │ Pet           │
# O──────────────────────────────O─────────────────────O───────────────O
# │ Min    => 0.0501758995572299 │ A2Ue69EWAMtJCi => 3 │ Guinness => 7 │
# │ 1st-Qu => 1.7406953436440742 │ CQmrQcQ4YkXvaD => 1 │               │
# │ Mean   => 8.839377375678543  │ 20CO9FGD       => 1 │               │
# │ Median => 7.34210706081909   │ xgZjtSP6VrKbH  => 1 │               │
# │ 3rd-Qu => 15.854088005472917 │ aY             => 1 │               │
# │ Max    => 18.72979803423013  │                     │               │
# O──────────────────────────────O─────────────────────O───────────────O
# summary of Truffle =>
# O──────────────O──────────────────────────────O─────────────────────O
# │ Pet          │ Ref                          │ Code                │
# O──────────────O──────────────────────────────O─────────────────────O
# │ Truffle => 4 │ Min    => 0.7318998724597869 │ KNwmt0QmoqABwR => 2 │
# │              │ 1st-Qu => 1.822202836225727  │ 20CO9FGD       => 1 │
# │              │ Mean   => 6.312932174017679  │ xgZjtSP6VrKbH  => 1 │
# │              │ Median => 6.368803873269801  │                     │
# │              │ 3rd-Qu => 10.803661511809633 │                     │
# │              │ Max    => 11.782221077071329 │                     │
# O──────────────O──────────────────────────────O─────────────────────O
# summary of Jumba =>
# O──────────────────────────────O────────────O─────────────────────O
# │ Ref                          │ Pet        │ Code                │
# O──────────────────────────────O────────────O─────────────────────O
# │ Min    => 0.7397628145038704 │ Jumba => 5 │ xgZjtSP6VrKbH  => 2 │
# │ 1st-Qu => 5.28862527360509   │            │ 20CO9FGD       => 1 │
# │ Mean   => 11.935946110102654 │            │ A2Ue69EWAMtJCi => 1 │
# │ Median => 12.956171789492936 │            │ aY             => 1 │
# │ 3rd-Qu => 18.073154106905072 │            │                     │
# │ Max    => 19.868590809216744 │            │                     │
# O──────────────────────────────O────────────O─────────────────────O
```

### Skim

*TBD...*

------

## TODO

- [ ] User specified `NA` marker
  
- [ ] Tabular dataset summarization tests

- [ ] Skimmer

- [ ] Peek-er

------

## References

### Functions, repositories

[AAf1] Anton Antonov,
[RecordsSummary](https://resources.wolframcloud.com/FunctionRepository/resources/RecordsSummary),
(2019),
[Wolfram Function Repository](https://resources.wolframcloud.com/FunctionRepository).
