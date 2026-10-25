# Selenized color palette (discrete)

Qualitative color palette from the accent colors of Jan Warchoł's
Selenized color scheme, <https://github.com/jan-warchol/selenized>. Each
variant has its own eight accent colors, balanced in lightness against
that variant's background, so use the same `variant` here as in
[`theme_selenized()`](https://jrnold.github.io/ggthemes/reference/theme_selenized.md).
This palette supports up to eight values.

## Usage

``` r
selenized_pal(accent = "blue", variant = "light")
```

## Arguments

- accent:

  A string, the name of the starting color: one of `"red"`, `"green"`,
  `"yellow"`, `"blue"`, `"magenta"`, `"cyan"`, `"orange"` or `"violet"`.

- variant:

  A string, the Selenized variant: `"light"`, `"dark"`, `"black"` or
  `"white"`.

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Note

For a given starting color and number of colors in the palette, the
other colors are the combination of colors that maximizes the total
Euclidean distance between colors in L*a*b space, as in
[`solarized_pal()`](https://jrnold.github.io/ggthemes/reference/solarized_pal.md).

## See also

Other color selenized:
[`scale_colour_selenized()`](https://jrnold.github.io/ggthemes/reference/scale_selenized.md)

## Examples

``` r
library("scales")

show_col(selenized_pal()(3))

show_col(selenized_pal("red")(4))

show_col(selenized_pal(variant = "dark")(8))
```
