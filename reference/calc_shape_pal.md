# Calc shape palette (discrete)

Shape palette based on the shapes used in LibreOffice Calc.

## Usage

``` r
calc_shape_pal(unicode = FALSE)
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

This palette supports seven values by default and thirteen with
`unicode = TRUE`. Six of Calc's thirteen symbols – the solid down, left
and right triangles, the bowtie, the hourglass and the four-pointed star
– have no base pch equivalent and are dropped rather than approximated
by a different shape. Restoring them with `unicode = TRUE` needs a font
covering Geometric Shapes, Dingbats and Miscellaneous Mathematical
Symbols-B; Noto Sans Symbols 2 is effectively the only free font with
the last of these.

## See also

Other shapes calc:
[`scale_shape_calc()`](https://jrnold.github.io/ggthemes/reference/scale_shape_calc.md)

## Examples

``` r
# The seven shapes with a font-independent equivalent.
show_shapes(calc_shape_pal()(7))


if (FALSE) { # \dontrun{
  # All thirteen, drawn from the device font. Needs a font covering Geometric
  # Shapes, Dingbats and Miscellaneous Mathematical Symbols-B, such as
  # Noto Sans Symbols 2.
  show_shapes(calc_shape_pal(unicode = TRUE)(13))
} # }
```
