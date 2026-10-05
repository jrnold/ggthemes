# Economist sequential color scales

Color scales built from the equal-lightness color scales of *The
Economist visual styleguide* (v1.2, 4 May 2017); see
[`economist_seq_pal()`](https://jrnold.github.io/ggthemes/reference/economist_seq_pal.md).
The `_c` scales are continuous; the `_ordinal` scales are discrete, for
ordered factors. See
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)
for the unordered categorical scales.

## Usage

``` r
scale_colour_economist_c(hue = "blue", ..., guide = "colourbar")

scale_color_economist_c(hue = "blue", ..., guide = "colourbar")

scale_fill_economist_c(hue = "blue", ..., guide = "colourbar")

scale_colour_economist_ordinal(hue = "blue", ...)

scale_color_economist_ordinal(hue = "blue", ...)

scale_fill_economist_ordinal(hue = "blue", ...)
```

## Arguments

- hue:

  A string, the hue of the color scale. One of `"blue"` (the default),
  `"cyan"`, `"green"`, `"yellow"`, `"olive"`, `"purple"`, `"gold"`,
  `"gray"`, or `"red"`.

- ...:

  Other arguments passed on to the underlying scale.

- guide:

  A function used to create a guide or its name. See
  [`guides()`](https://ggplot2.tidyverse.org/reference/guides.html) for
  more information.

## Value

A ggplot2 scale object.

## See also

Other color economist:
[`economist_pal()`](https://jrnold.github.io/ggthemes/reference/economist_pal.md),
[`economist_seq_pal()`](https://jrnold.github.io/ggthemes/reference/economist_seq_pal.md),
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)

## Examples

``` r
library("ggplot2")

# Continuous scale
ggplot(mtcars, aes(x = wt, y = mpg, colour = disp)) +
  geom_point(size = 3) +
  scale_colour_economist_c(hue = "blue")


# Ordinal (discrete) scale for an ordered factor
ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(cyl, ordered = TRUE))) +
  geom_point(size = 3) +
  scale_colour_economist_ordinal(hue = "red")
```
