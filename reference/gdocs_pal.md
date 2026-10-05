# Google Docs color palette (discrete)

Color palettes from Google Docs. This palette includes 20 colors.

## Usage

``` r
gdocs_pal()
```

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## See also

Other color gdocs:
[`scale_fill_gdocs()`](https://jrnold.github.io/ggthemes/reference/scale_gdocs.md)

## Examples

``` r
library("scales")

show_col(gdocs_pal()(24))
```
