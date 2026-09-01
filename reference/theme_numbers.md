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

## Details

The values used here are those in the `chart-style-default` style of the
theme stylesheet that ships inside Numbers: no chart background fill,
gridlines in the value direction only, a border along the bottom of the
chart but not the other three sides, and no tick marks.

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_numbers() + scale_color_numbers()
```
