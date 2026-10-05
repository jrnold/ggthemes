# FiveThirtyEight color palette

The standard three-color FiveThirtyEight palette for line plots
comprises blue, red, and green.

## Usage

``` r
fivethirtyeight_pal()
```

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## See also

Other color fivethirtyeight:
[`scale_colour_fivethirtyeight()`](https://jrnold.github.io/ggthemes/reference/scale_fivethirtyeight.md)

## Examples

``` r
library("scales")

show_col(fivethirtyeight_pal()(3))
```
