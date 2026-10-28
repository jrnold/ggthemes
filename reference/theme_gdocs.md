# Theme with Google Docs chart defaults

Theme similar to the default look of charts in Google Docs.

## Usage

``` r
theme_gdocs(base_size = 12, base_family = "sans")
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
[`gdocs_pal()`](https://jrnold.github.io/ggthemes/reference/gdocs_pal.md)
for discrete color and fill scales as the default palettes, so a plot
draws in the theme's colors without a matching scale. A `scale_*()`
added to the plot still takes precedence.

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_gdocs() + scale_color_gdocs()
```
