# LibreOffice Calc theme

Theme similar to the default settings of LibreOffice Calc charts.

## Usage

``` r
theme_calc(base_size = 10, base_family = "sans")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Value

A ggplot2 theme object (class `theme`).

## Palettes

The theme sets
[`calc_pal()`](https://jrnold.github.io/ggthemes/reference/calc_pal.md)
for discrete color and fill scales and
[`calc_shape_pal()`](https://jrnold.github.io/ggthemes/reference/calc_shape_pal.md)
for shape as the default palettes, so a plot draws in the theme's colors
without a matching scale. A `scale_*()` added to the plot still takes
precedence.

## Examples

``` r
library(ggplot2)

ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  theme_calc() +
  scale_color_calc()


ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
  facet_wrap(~am) +
  theme_calc() +
  scale_shape_calc()
```
