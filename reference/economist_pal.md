# Economist color palette (discrete)

The hues in the palette are blues, grays, and greens. Red is not
included in these palettes and should be used to indicate important
data.

## Usage

``` r
economist_pal(fill = TRUE)
```

## Arguments

- fill:

  Use the fill palette.

## See also

Other colour economist:
[`scale_colour_economist()`](http://jrnold.github.io/ggthemes/reference/scale_economist.md)

## Examples

``` r
library("scales")

show_col(economist_pal()(6))

## fill palette
show_col(economist_pal(fill = TRUE)(6))
```
