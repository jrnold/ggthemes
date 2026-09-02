# ggplot color theme based on the Economist

A theme that approximates the style of charts in *The Economist*.

## Usage

``` r
theme_economist(
  base_size = 10,
  base_family = "sans",
  horizontal = TRUE,
  dkpanel = deprecated()
)

theme_economist_white(
  base_size = 10,
  base_family = "sans",
  gray_bg = deprecated(),
  horizontal = TRUE
)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- horizontal:

  `logical` Horizontal gridlines? If `FALSE`, vertical gridlines are
  drawn instead, for use with
  [`coord_flip()`](https://ggplot2.tidyverse.org/reference/coord_flip.html).

- dkpanel:

  \`r lifecycle::badge("deprecated")\` The darker panel was a feature of
  the pre-2017 design and no longer has any effect.

- gray_bg:

  \`r lifecycle::badge("deprecated")\` No longer has any effect.

## Value

An object of class
[`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## Details

This follows the chart design *The Economist* introduced in 2017 and
still publishes today: a white plot area on a pale ground, light
horizontal gridlines only, a black x-axis baseline with tick marks below
it, and no y-axis rule or ticks. Use
[`scale_colour_economist()`](https://jrnold.github.io/ggthemes/reference/scale_economist.md)
with it.

Two conventions of the house style cannot be expressed as theme
elements, and have to be set on the plot itself:

- *The Economist* puts the y axis on the right. Use
  `scale_y_continuous(position = "right")`.

- Charts are tagged with a small red rectangle above the title. Draw it
  with
  [`annotate()`](https://ggplot2.tidyverse.org/reference/annotate.html)
  or [`grid.rect()`](https://rdrr.io/r/grid/grid.rect.html) in "Econ
  red", which is `ggthemes_data$economist$main` row `"econ red"`.

*The Economist* sets charts in "Econ Sans", which is not publicly
available. Any narrow humanist sans is a reasonable substitute; with the
extrafont package, "Roboto Condensed" or "Fira Sans Condensed" are
close.

## References

- [The Economist](https://www.economist.com/)

- *The Economist visual styleguide*, version 1.2, 4 May 2017.

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
     facet_wrap(~am) +
     # The Economist puts the y-axis labels on the right-hand side
     scale_y_continuous(position = "right") +
     labs(
       title = "Heavier, thirstier",
       subtitle = "Fuel economy v weight, by number of forward gears",
       caption = "Source: Motor Trend, 1974"
     )

## Standard
p + theme_economist() +
  scale_colour_economist()


# Vertical gridlines, for use with coord_flip()
p + theme_economist(horizontal = FALSE) +
    scale_colour_economist() +
    coord_flip()


## Ordered data uses one hue's equal-lightness steps instead
ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = hp)) +
  scale_colour_economist_c(hue = "blue") +
  theme_economist()


if (FALSE) { # \dontrun{

## The Economist sets charts in "Econ Sans", which is not publicly
## available. Any narrow humanist sans is a reasonable substitute.
library("extrafont")
p + theme_economist(base_family = "Roboto Condensed") +
    scale_colour_economist()

} # }
```
