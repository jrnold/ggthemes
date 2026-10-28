# Theme with Apple Numbers chart defaults

Theme similar to the default look of charts in Apple Numbers.

## Usage

``` r
theme_numbers(base_size = 12, base_family = "sans")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Value

A ggplot2 theme object (class `theme`).

## Details

The values used here are those in the `chart-style-default` style of the
theme stylesheet that ships inside Numbers: no chart background fill,
gridlines in the value direction only, a border along the bottom of the
chart but not the other three sides, and no tick marks.

## Palettes

The theme sets
[`numbers_pal()`](https://jrnold.github.io/ggthemes/reference/numbers_pal.md)
for discrete color and fill scales as the default palettes, so a plot
draws in the theme's colors without a matching scale. A `scale_*()`
added to the plot still takes precedence.

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_numbers() + scale_color_numbers()
```
