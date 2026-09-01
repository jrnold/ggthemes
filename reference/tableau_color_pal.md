# Tableau Color Palettes (discrete)

Color palettes used in [Tableau](https://www.tableau.com/).

## Usage

``` r
tableau_color_pal(
  palette = "Tableau 10",
  type = c("regular", "ordered-sequential", "ordered-diverging"),
  direction = 1
)
```

## Arguments

- palette:

  Palette name. See Details for available palettes.

- type:

  Type of palette. One of `"regular"`, `"ordered-diverging"`, or
  `"ordered-sequential"`.

- direction:

  If 1, the default, then use the original order of colors. If -1, then
  reverse the order.

## Details

Tableau provides three types of color palettes: `"regular"` (discrete,
qualitative categories), `"ordered-sequential"`, and
`"ordered-diverging"`.

- `"regular"`:

  `"Tableau 10"`, `"Tableau 20"`, `"Color Blind"`, `"Seattle Grays"`,
  `"Traffic"`, `"Miller Stone"`, `"Superfishel Stone"`,
  `"Nuriel Stone"`, `"Jewel Bright"`, `"Summer"`, `"Winter"`,
  `"Green-Orange-Teal"`, `"Blue-Red-Brown"`, `"Purple-Pink-Gray"`,
  `"Hue Circle"`, `"Classic 10"`, `"Classic 10 Medium"`,
  `"Classic 10 Light"`, `"Classic 20"`, `"Classic Gray 5"`,
  `"Classic Color Blind"`, `"Classic Traffic Light"`,
  `"Classic Purple-Gray 6"`, `"Classic Purple-Gray 12"`,
  `"Classic Green-Orange 6"`, `"Classic Green-Orange 12"`,
  `"Classic Blue-Red 6"`, `"Classic Blue-Red 12"`, `"Classic Cyclic"`

- `"ordered-diverging"`:

  `"Orange-Blue Diverging"`, `"Red-Green Diverging"`,
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

- `"ordered-sequential"`:

  `"Blue-Green Sequential"`, `"Blue Light"`, `"Orange Light"`, `"Blue"`,
  `"Orange"`, `"Green"`, `"Red"`, `"Purple"`, `"Brown"`, `"Gray"`,
  `"Gray Warm"`, `"Blue-Teal"`, `"Orange-Gold"`, `"Green-Gold"`,
  `"Red-Gold"`, `"Classic Green"`, `"Classic Gray"`, `"Classic Blue"`,
  `"Classic Red"`, `"Classic Orange"`, `"Classic Area Red"`,
  `"Classic Area Green"`, `"Classic Area Brown"`

## References

<http://vis.stanford.edu/color-names/analyzer/>

Maureen Stone, 'Designing Colors for Data' (slides), at the
International Symposium on Computational Aesthetics in Graphics,
Visualization, and Imaging, Banff, AB, Canada, June 22, 2007.

Heer, Jeffrey and Maureen Stone, 2012 'Color Naming Models for Color
Selection, Image Editing and Palette Design', ACM Human Factors in
Computing Systems (CHI)
<http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf>.

## See also

Other colour tableau:
[`scale_colour_gradient2_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient2_tableau.md),
[`scale_colour_gradient_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_colour_gradient_tableau.md),
[`scale_colour_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_color_tableau.md),
[`tableau_gradient_pal()`](http://jrnold.github.io/ggthemes/reference/tableau_gradient_pal.md)

## Examples

``` r
library("scales")

palettes <- ggthemes_data[["tableau"]][["color-palettes"]][["regular"]]
for (palname in names(palettes)) {
  pal <- tableau_color_pal(palname)
  max_n <- attr(pal, "max_n")
  show_col(pal(max_n))
  title(main = palname)
}




























```
