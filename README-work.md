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

### Summarize vectors

Here we generate a numerical vector, place some NaN's or Whatever's in it:

```perl6
my @vec = [^1001].roll(12);
@vec = @vec.append( [NaN, Whatever, Nil]);
@vec .= pick(@vec.elems);
@vec
```

Here we summarize the vector generated above:

```perl6
records-summary(@vec)
```

### Summarize tabular datasets

Here we generate a random tabular dataset with 16 rows and 3 columns and display it:

```perl6
srand(32);
my $tbl = random-tabular-dataset(16, <Pet Ref Code>, generators=>[random-pet-name(4), &random-word, random-string(6)]);
to-pretty-table($tbl)
```

**Remark:** The values of the column "Pet" is sampled from a set of four pet names, and the values of the column
and "Code" is sampled from a set of 6 strings.

Here we summarize the tabular dataset generated above:

```perl6
records-summary($tbl)
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
