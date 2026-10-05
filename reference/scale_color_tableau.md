# Tableau color scales (discrete)

Categorical (qualitative) color scales used in Tableau. Use the function
[`scale_colour_gradient_tableau()`](https://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md)
for the sequential and
[`scale_colour_gradient2_tableau()`](https://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md)
for the diverging continuous color scales from Tableau.

## Usage

``` r
scale_colour_tableau(
  palette = "Tableau 10",
  ...,
  type = "regular",
  direction = 1
)

scale_fill_tableau(
  palette = "Tableau 10",
  ...,
  type = "regular",
  direction = 1
)

scale_color_tableau(
  palette = "Tableau 10",
  ...,
  type = "regular",
  direction = 1
)
```

## Arguments

- palette:

  Palette name. See
  [`tableau_color_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_color_pal.md)
  for available palettes.

- ...:

  Other arguments passed on to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

- type:

  The type of palette, one of:

  - `"regular"`, the default: discrete, qualitative palettes.

  - `"ordered-sequential"`: sequential palettes.

  - `"ordered-diverging"`: diverging palettes.

- direction:

  If `1` (the default), use the original order of colors. If `-1`,
  reverse the order.

## Value

A ggplot2 scale object.

## See also

[`tableau_color_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_color_pal.md)
for references.

Other color tableau:
[`scale_colour_gradient2_tableau()`](https://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
[`scale_colour_gradient_tableau()`](https://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
[`tableau_color_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_color_pal.md),
[`tableau_gradient_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_gradient_pal.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am) +
  theme_igray()

palettes <- ggthemes_data[["tableau"]][["color-palettes"]][["regular"]]
for (palette in head(names(palettes), 3L)) {
  print(p + scale_colour_tableau(palette) + ggtitle(palette))
}




# the order of colour can be reversed
p + scale_color_tableau(direction = -1)
```
