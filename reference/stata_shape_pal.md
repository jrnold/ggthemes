# Stata shape palette (discrete)

Shape palette based on the symbol palette in Stata used in scheme
s2mono. This palette supports up to 10 values.

## Usage

``` r
stata_shape_pal(unicode = FALSE)
```

## Arguments

- unicode:

  If `TRUE`, return pch codes derived from Unicode glyphs, which exist
  for every shape of the palette. They are drawn by the device font, so
  they render as blank boxes in a font without coverage and at unrelated
  sizes in most fonts; the font from
  [`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md)
  has the shapes of this palette at a common size. If `FALSE`, return
  base pch codes, which every font can draw but which exist only for
  some shapes. The default depends on the palette.

## Value

A palette function. It takes the number of shapes `n` and returns an
integer vector of `n` shape (`pch`) codes, and can be used as the
`palette` argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Note

Stata's ten plotting symbols all have a base pch equivalent, so this
palette supports ten values on either branch and nothing is dropped:
solid and hollow circle, diamond, square and triangle, plus the X and
the plus sign.

## See also

See
[`scale_shape_stata()`](https://jrnold.github.io/ggthemes/reference/scale_shape_stata.md)
for examples.

Other shapes stata:
[`scale_shape_stata()`](https://jrnold.github.io/ggthemes/reference/scale_shape_stata.md)

## Examples

``` r
stata_shape_pal()(10)
#>  [1] 16 18 15 17  4  3  1  5  0  2

show_shapes(stata_shape_pal()(10))
```
