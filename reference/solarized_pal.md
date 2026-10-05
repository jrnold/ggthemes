# Solarized color palette (discrete)

Qualitative color palate based on the Ethan Schoonover's Solarized
palette, <https://ethanschoonover.com/solarized/>. This palette supports
up to seven values.

## Usage

``` r
solarized_pal(accent = "blue")
```

## Arguments

- accent:

  `character` Starting color.

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Note

For a given starting color and number of colors in the palette, the
other colors are the combination of colors that maximizes the total
Euclidean distance between colors in L*a*b space.

## See also

Other color solarized:
[`scale_fill_solarized()`](https://jrnold.github.io/ggthemes/reference/scale_solarized.md)

## Examples

``` r
library("scales")

show_col(solarized_pal()(2))

show_col(solarized_pal()(3))

show_col(solarized_pal("red")(4))
```
