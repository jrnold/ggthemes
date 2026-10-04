# Economist color palette (discrete)

The classic *The Economist* chart palette: blues, grays, and greens,
chosen and ordered for the number of colors requested. Red is not
included in these palettes; *The Economist* reserves it to mark
important data.

## Usage

``` r
economist_pal(fill = TRUE)
```

## Arguments

- fill:

  Use the fill palette. The fill palette (the default) and the line
  palette choose and order the colors differently.

## Value

A palette function. It takes the number of colours `n` and returns a
character vector of `n` hex colours, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

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
