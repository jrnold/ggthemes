# Theme based on the Selenized color scheme

Theme using the colors of Jan Warchoł's Selenized color scheme,
<https://github.com/jan-warchol/selenized>. Selenized is a successor to
Solarized (see
[`theme_solarized()`](https://jrnold.github.io/ggthemes/reference/theme_solarized.md))
with higher contrast and accent colors of balanced lightness. It has
four variants: `"light"` and `"dark"`, on tinted backgrounds like
Solarized, and `"black"` and `"white"`, on neutral ones.

## Usage

``` r
theme_selenized(base_size = 12, base_family = "", variant = "light")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- variant:

  A string, the Selenized variant: `"light"`, `"dark"`, `"black"` or
  `"white"`.

## Value

A ggplot2 theme object (class `theme`).

## Details

Text uses the scheme's foreground, `fg_0`, and titles its bold
foreground, `fg_1`. Grid lines use `bg_1`, and axis lines and ticks the
dim foreground, `dim_0`. With ggplot2 4.0.0 or later, geoms default to
the foreground and background colors, so that they show on the dark
variants. Use
[`scale_colour_selenized()`](https://jrnold.github.io/ggthemes/reference/scale_selenized.md)
with the same `variant` for matching data colors.

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)

# Use the same variant for the theme and the scale
p + theme_selenized() + scale_colour_selenized()

p + theme_selenized(variant = "dark") + scale_colour_selenized(variant = "dark")

p + theme_selenized(variant = "black") + scale_colour_selenized(variant = "black")

p + theme_selenized(variant = "white") + scale_colour_selenized(variant = "white")
```
