# Calc color palette (discrete)

Color palettes from LibreOffice Calc. This palette has 12 values.

## Usage

``` r
calc_pal()
```

## Value

A palette function. It takes the number of colours `n` and returns a
character vector of `n` hex colours, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## See also

Other colour calc:
[`scale_fill_calc()`](https://jrnold.github.io/ggthemes/reference/scale_calc.md)

## Examples

``` r
library("scales")

show_col(calc_pal()(12))
```
