# Economist color palette (discrete)

The nine colors *The Economist* uses for chart series: blue, cyan,
green, yellow, olive, purple, gold, gray, and red, in that order. Red
comes last because the house style reserves it for data the chart is
making a point about, rather than handing it out as an ordinary series
color.

## Usage

``` r
economist_pal(fill = deprecated())
```

## Arguments

- fill:

  \`r lifecycle::badge("deprecated")\` No longer has any effect.

## Details

A tenth color, "Econ red", is the brighter masthead red used for the tag
rectangle and for single-series highlights. It is excluded from this
palette; take it from `ggthemes_data$economist$main` when you need it.

## See also

Other colour economist:
[`economist_seq_pal()`](https://jrnold.github.io/ggthemes/reference/economist_seq_pal.md),
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md),
[`scale_colour_economist_c()`](https://jrnold.github.io/ggthemes/reference/scale_economist_seq.md)

## Examples

``` r
library("scales")

show_col(economist_pal()(6))


## the full set of nine series colours
show_col(economist_pal()(9))
```
