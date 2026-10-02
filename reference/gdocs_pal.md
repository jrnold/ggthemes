# Google Docs color palette (discrete)

Color palettes from Google Docs. This palette includes 20 colors.

## Usage

``` r
gdocs_pal()
```

## Value

A palette function. It takes the number of colours `n` and returns a
character vector of `n` hex colours, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## See also

Other colour gdocs:
[`scale_fill_gdocs()`](https://jrnold.github.io/ggthemes/reference/scale_gdocs.md)

## Examples

``` r
library("scales")

show_col(gdocs_pal()(24))
```
