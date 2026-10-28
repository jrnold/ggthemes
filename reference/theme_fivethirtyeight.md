# Theme inspired by FiveThirtyEight plots

Theme inspired by the plots from FiveThirtyEight.com.

## Usage

``` r
theme_fivethirtyeight(base_size = 12, base_family = "sans")
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
[`fivethirtyeight_pal()`](https://jrnold.github.io/ggthemes/reference/fivethirtyeight_pal.md)
for discrete color and fill scales as the default palettes, so a plot
draws in the theme's colors without a matching scale. A `scale_*()`
added to the plot still takes precedence.

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  facet_wrap(~am) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_fivethirtyeight() +
  theme_fivethirtyeight()
p
#> `geom_smooth()` using formula = 'y ~ x'
```
