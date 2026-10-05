# Wall Street Journal color palette (discrete)

The Wall Street Journal uses many different color palettes in its plots.
This collects a few of them, but is by no means exhaustive. Collections
of these plots can be found on the WSJ Graphics [X (formerly
Twitter)](https://x.com/WSJGraphics) feed and
[Pinterest](https://pinterest.com/wsjgraphics/wsj-graphics/).

## Usage

``` r
wsj_pal(palette = "colors6")
```

## Arguments

- palette:

  `character` The color palette to use. One of `"rgby"`, `"red_green"`,
  `"black_green"`, `"dem_rep"`, `"colors6"`.

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Palettes

The following palettes are defined:

- `"rgby"`: red/green/blue/yellow theme.

- `"red_green"`: green/red two-color scale for good/bad.

- `"green_black"`: black-green 4-color scale for "very negative",
  "somewhat negative", "somewhat positive", "very positive".

- `"dem_rep"`: Democrat/Republican/Undecided blue/red/gray scale.

- `"colors6"`: red, blue, gold, green, orange, and black palette.

## See also

Other color wsj:
[`scale_colour_wsj()`](https://jrnold.github.io/ggthemes/reference/scale_wsj.md)

## Examples

``` r
wsj_pal()(6)
#> [1] "#c72e29" "#016392" "#be9c2e" "#098154" "#fb832d" "#000000"

scales::show_col(wsj_pal("rgby")(4))
```
