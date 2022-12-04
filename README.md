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
[`Data::Reshapers`](https://modules.raku.org/dist/Data::Reshapers:cpan:ANTONOV),
[`Text::Plot`](https://modules.raku.org/dist/Text::Plot:cpan:ANTONOV),
and this module,
[`Data::Summarizers`](https://github.com/antononcube/Raku-Data-Summarizers):

```perl6
use Data::Generators;
use Data::Reshapers;
use Text::Plot;
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
# [953 NaN 275 (Whatever) 182 174 774 314 312 229 215 699 621 68 (Any)]
```

Here we summarize the vector generated above:

```perl6
records-summary(@vec)
```
```
# +-----------------------------------------+
# | numerical                               |
# +-----------------------------------------+
# | 3rd-Qu                    => 660        |
# | Mean                      => 401.333333 |
# | Max                       => 953        |
# | Min                       => 68         |
# | (Any-Nan-Nil-or-Whatever) => 3          |
# | 1st-Qu                    => 198.5      |
# | Median                    => 293.5      |
# +-----------------------------------------+
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
# +---------+----------------------+-----------+
# |   Pet   |         Code         |    Ref    |
# +---------+----------------------+-----------+
# |  Maggie |  NKNwmt0QmoqABwRw2   | 16.277717 |
# |  Percy  |  NKNwmt0QmoqABwRw2   | 15.854088 |
# |  Nocona |       qpuwPHV        | 11.782221 |
# |  Nocona | MoxGOxgZjtSP6VrKbHda |  9.825102 |
# | Lagoona |       aDNA2Ue6       | 18.729798 |
# |  Nocona |  NKNwmt0QmoqABwRw2   |  0.731900 |
# |  Maggie |  CO9FGDOCQmrQcQ4YkX  |  0.739763 |
# |  Maggie |  CO9FGDOCQmrQcQ4YkX  | 12.956172 |
# |  Percy  |  CO9FGDOCQmrQcQ4YkX  |  0.050176 |
# |  Maggie | EWAMtJCiNcio2d8qOu7Z | 19.868591 |
# |  Percy  |       aDNA2Ue6       |  8.811677 |
# |  Percy  |  CO9FGDOCQmrQcQ4YkX  |  1.740695 |
# |  Percy  |       qpuwPHV        |  1.342386 |
# | Lagoona |  NKNwmt0QmoqABwRw2   |  4.774780 |
# |  Maggie | EWAMtJCiNcio2d8qOu7Z |  9.837488 |
# |  Percy  |       aDNA2Ue6       |  7.342107 |
# +---------+----------------------+-----------+
```

**Remark:** The values of the column "Pet" is sampled from a set of four pet names, and the values of the column
and "Code" is sampled from a set of 6 strings.

Here we summarize the tabular dataset generated above:

```perl6
records-summary($tbl)
```
```
# +------------------------------+--------------+---------------------------+
# | Ref                          | Pet          | Code                      |
# +------------------------------+--------------+---------------------------+
# | Min    => 0.0501758995572299 | Percy   => 6 | CO9FGDOCQmrQcQ4YkX   => 4 |
# | 1st-Qu => 1.5415405283062866 | Maggie  => 5 | NKNwmt0QmoqABwRw2    => 4 |
# | Mean   => 8.791541293209137  | Nocona  => 3 | aDNA2Ue6             => 3 |
# | Median => 9.318389368432966  | Lagoona => 2 | qpuwPHV              => 2 |
# | 3rd-Qu => 14.405129897482926 |              | EWAMtJCiNcio2d8qOu7Z => 2 |
# | Max    => 19.868590809216744 |              | MoxGOxgZjtSP6VrKbHda => 1 |
# +------------------------------+--------------+---------------------------+
```

### Summarize collections of tabular datasets 

Here is a hash of tabular datasets:

```perl6
my %group = group-by($tbl, 'Pet');

%group.pairs.map({ say("{$_.key} =>"); say to-pretty-table($_.value) });
```
```
# Nocona =>
# +--------+-----------+----------------------+
# |  Pet   |    Ref    |         Code         |
# +--------+-----------+----------------------+
# | Nocona | 11.782221 |       qpuwPHV        |
# | Nocona |  9.825102 | MoxGOxgZjtSP6VrKbHda |
# | Nocona |  0.731900 |  NKNwmt0QmoqABwRw2   |
# +--------+-----------+----------------------+
# Maggie =>
# +-----------+----------------------+--------+
# |    Ref    |         Code         |  Pet   |
# +-----------+----------------------+--------+
# | 16.277717 |  NKNwmt0QmoqABwRw2   | Maggie |
# |  0.739763 |  CO9FGDOCQmrQcQ4YkX  | Maggie |
# | 12.956172 |  CO9FGDOCQmrQcQ4YkX  | Maggie |
# | 19.868591 | EWAMtJCiNcio2d8qOu7Z | Maggie |
# |  9.837488 | EWAMtJCiNcio2d8qOu7Z | Maggie |
# +-----------+----------------------+--------+
# Percy =>
# +-----------+-------+--------------------+
# |    Ref    |  Pet  |        Code        |
# +-----------+-------+--------------------+
# | 15.854088 | Percy | NKNwmt0QmoqABwRw2  |
# |  0.050176 | Percy | CO9FGDOCQmrQcQ4YkX |
# |  8.811677 | Percy |      aDNA2Ue6      |
# |  1.740695 | Percy | CO9FGDOCQmrQcQ4YkX |
# |  1.342386 | Percy |      qpuwPHV       |
# |  7.342107 | Percy |      aDNA2Ue6      |
# +-----------+-------+--------------------+
# Lagoona =>
# +---------+-----------+-------------------+
# |   Pet   |    Ref    |        Code       |
# +---------+-----------+-------------------+
# | Lagoona | 18.729798 |      aDNA2Ue6     |
# | Lagoona |  4.774780 | NKNwmt0QmoqABwRw2 |
# +---------+-----------+-------------------+
```

Here is the summary of that collection of datasets:

```perl6
records-summary(%group)
```
```
# summary of Nocona =>
# +-------------+---------------------------+------------------------------+
# | Pet         | Code                      | Ref                          |
# +-------------+---------------------------+------------------------------+
# | Nocona => 3 | MoxGOxgZjtSP6VrKbHda => 1 | Min    => 0.7318998724597869 |
# |             | NKNwmt0QmoqABwRw2    => 1 | 1st-Qu => 0.7318998724597869 |
# |             | qpuwPHV              => 1 | Mean   => 7.446407632026351  |
# |             |                           | Median => 9.825101946547935  |
# |             |                           | 3rd-Qu => 11.782221077071329 |
# |             |                           | Max    => 11.782221077071329 |
# +-------------+---------------------------+------------------------------+
# summary of Maggie =>
# +---------------------------+------------------------------+-------------+
# | Code                      | Ref                          | Pet         |
# +---------------------------+------------------------------+-------------+
# | EWAMtJCiNcio2d8qOu7Z => 2 | Min    => 0.7397628145038704 | Maggie => 5 |
# | CO9FGDOCQmrQcQ4YkX   => 2 | 1st-Qu => 5.28862527360509   |             |
# | NKNwmt0QmoqABwRw2    => 1 | Mean   => 11.935946110102652 |             |
# |                           | Median => 12.956171789492936 |             |
# |                           | 3rd-Qu => 18.073154106905072 |             |
# |                           | Max    => 19.868590809216744 |             |
# +---------------------------+------------------------------+-------------+
# summary of Percy =>
# +------------------------------+-------------------------+------------+
# | Ref                          | Code                    | Pet        |
# +------------------------------+-------------------------+------------+
# | Min    => 0.0501758995572299 | aDNA2Ue6           => 2 | Percy => 6 |
# | 1st-Qu => 1.342385712968499  | CO9FGDOCQmrQcQ4YkX => 2 |            |
# | Mean   => 5.856854802129969  | qpuwPHV            => 1 |            |
# | Median => 4.541401202231582  | NKNwmt0QmoqABwRw2  => 1 |            |
# | 3rd-Qu => 8.811676790317996  |                         |            |
# | Max    => 15.854088005472917 |                         |            |
# +------------------------------+-------------------------+------------+
# summary of Lagoona =>
# +------------------------------+--------------+------------------------+
# | Ref                          | Pet          | Code                   |
# +------------------------------+--------------+------------------------+
# | Min    => 4.774780397743927  | Lagoona => 2 | NKNwmt0QmoqABwRw2 => 1 |
# | 1st-Qu => 4.774780397743927  |              | aDNA2Ue6          => 1 |
# | Mean   => 11.752289215987028 |              |                        |
# | Median => 11.752289215987028 |              |                        |
# | 3rd-Qu => 18.72979803423013  |              |                        |
# | Max    => 18.72979803423013  |              |                        |
# +------------------------------+--------------+------------------------+
```

### Pareto principle statistic

Here is vector of 200 random numbers:

```perl6
my @vec = random-variate(NormalDistribution.new(30, 20), 200);
```
```
# [59.212730704612696 34.134995920305656 25.88954812412628 12.377698483774676 25.625956801884726 40.41176361078956 20.187169210178823 28.122337054095997 42.2936024550972 76.43450377541626 20.125468173502327 40.1623738900808 48.90881794156412 -21.2255673851762 11.19064550346678 70.56295583528248 52.164498026264056 36.100792092158066 39.658405058071736 29.758418510980412 5.046257230002421 23.301587697342683 40.21520495302646 21.039364474053894 0.6054615069275755 10.843649913676906 8.651247344238612 29.188685050110013 46.17243204149679 29.12288260495595 42.39938671879868 25.30757656375898 13.718728094021614 -4.458258291639666 58.75186398292655 23.655022979115692 10.506541662625374 55.879957455984226 50.40469849314505 31.60889326645238 70.98462623780804 7.306055504030908 38.11275333232727 -5.092790555105829 61.618240547142044 55.66572165787737 48.64925391784162 31.11324623737988 34.31633930369186 37.24408336261464 46.64430107087093 22.921022177848336 15.504268643290944 57.015161517901376 50.972017228889044 16.070340949890294 15.533882392578862 45.99929510730753 30.828216356758002 32.79906934933759 3.2428087487831405 61.860285805211774 49.63278938040036 9.813613021607466 33.66217731065871 10.73096799601009 46.08183835744013 47.44932515715686 13.984925736574784 47.68150725211336 36.56051208050054 18.086608656083747 44.446917720818234 14.039615521979682 36.886717318617954 37.08039495443548 62.183136179228285 14.528820062804277 28.067948443342072 18.482330235911487 -0.864560890243613 10.460280533292668 16.152789757394892 58.32344266309477 -9.618652772016162 13.832203099808194 22.46661362575757 21.879415298047732 34.6296292696369 46.025383846266166 25.446323989312827 56.61883389400013 14.918293395974683 41.70979558984957 -18.84247659850992 22.078336914572596 31.624827245781344 22.995979240471065 26.788212675136965 -9.590770928114104 ...]
```

Here we compute the 
[Pareto principle statistic](https://en.wikipedia.org/wiki/Pareto_principle) 
and plot it:

```perl6
text-list-plot(pareto-principle-statistic(@vec))
```
```
# +---+------------+------------+------------+------------+--+      
# |                                                          |      
# +                                      *****************   +  1.00
# |                               *******                    |      
# +                           *****                          +  0.80
# |                       ****                               |      
# +                   ****                                   +  0.60
# |                ****                                      |      
# +            ****                                          +  0.40
# |          ***                                             |      
# +       ***                                                +  0.20
# |     ***                                                  |      
# |   **                                                     |      
# +                                                          +  0.00
# +---+------------+------------+------------+------------+--+      
#     0.00         50.00        100.00       150.00       200.00
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
