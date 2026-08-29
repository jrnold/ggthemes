# Tableau diverging colour scales (continuous)

Continuous color scales using the diverging color scales in Tableau. See
[`scale_colour_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md)
for Tabaleau discrete color scales, and
[`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md)
for sequential color scales.

## Usage

``` r
scale_colour_gradient2_tableau(
  palette = "Orange-Blue Diverging",
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = "colourbar"
)

scale_fill_gradient2_tableau(
  palette = "Orange-Blue Diverging",
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = "colourbar"
)

scale_color_gradient2_tableau(
  palette = "Orange-Blue Diverging",
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = "colourbar"
)
```

## Arguments

- palette:

  Palette name.

  `"ordered-sequential"`

  :   `"Blue-Green Sequential"`, `"Blue Light"`, `"Orange Light"`,
      `"Blue"`, `"Orange"`, `"Green"`, `"Red"`, `"Purple"`, `"Brown"`,
      `"Gray"`, `"Gray Warm"`, `"Blue-Teal"`, `"Orange-Gold"`,
      `"Green-Gold"`, `"Red-Gold"`, `"Classic Green"`, `"Classic Gray"`,
      `"Classic Blue"`, `"Classic Red"`, `"Classic Orange"`,
      `"Classic Area Red"`, `"Classic Area Green"`,
      `"Classic Area-Brown"`

  `"ordered-diverging"`

  :   `"Orange-Blue Diverging"`, `"Red-Green Diverging"`,
      `"Green-Blue Diverging"`, `"Red-Blue Diverging"`,
      `"Red-Black Diverging"`, `"Gold-Purple Diverging"`,
      `"Red-Green-Gold Diverging"`, `"Sunset-Sunrise Diverging"`,
      `"Orange-Blue-White Diverging"`, `"Red-Green-White Diverging"`,
      `"Green-Blue-White Diverging"`, `"Red-Blue-White Diverging"`,
      `"Red-Black-White Diverging"`, `"Orange-Blue Light Diverging"`,
      `"Temperature Diverging"`, `"Classic Red-Green"`,
      `"Classic Red-Blue"`, `"Classic Red-Black"`,
      `"Classic Area Red-Green"`, `"Classic Orange-Blue"`,
      `"Classic Green-Blue"`, `"Classic Red-White-Green"`,
      `"Classic Red-White-Black"`, `"Classic Orange-White-Blue"`,
      `"Classic Red-White-Black Light"`,
      `"Classic Orange-White-Blue Light"`,
      `"Classic Red-White-Green Light"`, `"Classic Red-Green Light"`

- ...:

  Arguments passed to `tableau_gradient_pal`.

- midpoint:

  The data value that corresponds to the middle color of the diverging
  palette.

- na.value:

  Colour to use for missing values

- guide:

  Type of legend. Use `'colourbar'` for continuous colour bar, or
  `'legend'` for discrete colour legend.

## See also

Other colour tableau:
[`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
[`scale_colour_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md),
[`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md),
[`tableau_gradient_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_gradient_pal.md)

## Examples

``` r
library("ggplot2")

df <- data.frame(
  x = runif(100),
  y = runif(100),
  z1 = rnorm(100),
  z2 = abs(rnorm(100))
)
p <- ggplot(df, aes(x, y)) +
  geom_point(aes(colour = z2))

palettes <-
  ggthemes_data[["tableau"]][["color-palettes"]][["ordered-diverging"]]
for (palette in head(names(palettes))) {
  print(p + scale_colour_gradient2_tableau(palette) + ggtitle(palette))
}







# If you need to reverse a palette, use a transformation
p + scale_colour_gradient2_tableau(trans = "reverse")
```
