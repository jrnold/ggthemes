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

  The background color of plot. One of
  `'brown', 'gray', 'green', 'blue'`.

- base_family:

  base font family

- title_family:

  Plot title font family.

## Details

This theme should be used with
[`scale_color_wsj()`](http://jrnold.github.io/ggthemes/reference/scale_wsj.md).

## References

<https://twitter.com/WSJGraphics>

<https://pinterest.com/wsjgraphics/wsj-graphics/>

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  ggtitle("Diamond Prices")
p + scale_colour_wsj("colors6", "") + theme_wsj()

# Use a gray background instead
p + scale_colour_wsj("colors6", "") + theme_wsj(color = "gray")
```
