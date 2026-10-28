# Wall Street Journal theme

Theme based on the plots in *The Wall Street Journal*.

## Usage

``` r
theme_wsj(
  base_size = 12,
  color = "brown",
  base_family = "sans",
  title_family = "mono"
)
```

## Arguments

- base_size:

  base font size, given in pts.

- color:

  A string, the background color of the plot. One of `"gray"`,
  `"green"`, `"blue"`, `"brown"`.

- base_family:

  base font family

- title_family:

  A string, the font family of the plot title.

## Value

A ggplot2 theme object (class `theme`).

## Details

This theme should be used with
[`scale_color_wsj()`](https://jrnold.github.io/ggthemes/reference/scale_wsj.md).

## Palettes

The theme sets
[`wsj_pal()`](https://jrnold.github.io/ggthemes/reference/wsj_pal.md)
for discrete color and fill scales as the default palettes, so a plot
draws in the theme's colors without a matching scale. A `scale_*()`
added to the plot still takes precedence.

## References

<https://x.com/WSJGraphics>

<https://pinterest.com/wsjgraphics/wsj-graphics/>

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  ggtitle("Diamond Prices")
p + scale_colour_wsj("colors6", "") + theme_wsj()

# Use a gray background instead
p + scale_colour_wsj("colors6", "") + theme_wsj(color = "gray")
```
