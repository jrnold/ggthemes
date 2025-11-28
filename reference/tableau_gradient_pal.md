# Tableau colour gradient palettes (continuous)

Gradient color palettes using the diverging and sequential continous
color palettes in Tableau. See
[`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md)
for discrete color palettes.

## Usage

``` r
tableau_gradient_pal(palette = "Blue", type = "ordered-sequential")

tableau_seq_gradient_pal(palette = "Blue", ...)

tableau_div_gradient_pal(palette = "Orange-Blue Diverging", ...)
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

- type:

  Palette type, either `"ordered-sequential"` or `"ordered-diverging"`.

- ...:

  Arguments passed to `tableau_gradient_pal`.

## See also

Other colour tableau:
[`scale_colour_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
[`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
[`scale_colour_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md),
[`tableau_color_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_color_pal.md)

## Examples

``` r
library("scales")

x <- seq(0, 1, length = 25)
r <- sqrt(outer(x^2, x^2, "+"))
palettes <-
  ggthemes_data[["tableau"]][["color-palettes"]][["ordered-sequential"]]
for (palname in names(palettes)) {
  col <- tableau_seq_gradient_pal(palname)(seq(0, 1, length = 12))
  image(r, col = col)
  title(main = palname)
}






















```
