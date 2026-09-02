# Tableau Shape Palettes (discrete)

Shape palettes used by [Tableau](https://www.tableau.com/).

## Usage

``` r
tableau_shape_pal(
  palette = c("default", "filled", "proportions"),
  unicode = FALSE
)
```

## Arguments

- palette:

  Palette name.

- unicode:

  If `TRUE`, return pch codes derived from Unicode glyphs, as this
  palette did before ggthemes 6.1.0. Glyph shapes are drawn by the
  device font, so they render as blank boxes in a font without coverage;
  the default returns base pch codes, which every font can draw.

## Details

Not all shape palettes in Tableau are supported, and these palettes are
not exact.

Shape palettes in Tableau are used to expose images for use as markers
in charts, and thus are sometimes groupings of closely related symbols.

## Note

Supported values by palette: `"default"` eight (ten with
`unicode = TRUE`), `"filled"` six (ten), `"proportions"` two (five).
Shapes with no base pch equivalent – the sideways triangles, the solid
star, and the partially filled circles – are dropped rather than
approximated by a different shape.

`"proportions"` encodes *fill fraction*, which base pch cannot express
at all, so only its empty and full circles survive; they remain
meaningful as a two-value scale. To encode a proportion, map `alpha` or
`fill` instead, or use `unicode = TRUE` with a font covering Geometric
Shapes, such as DejaVu Sans.

## See also

Other shapes tableau:
[`scale_shape_tableau()`](http://jrnold.github.io/ggthemes/reference/scale_shape_tableau.md)

## Examples

``` r
# The eight shapes with a font-independent equivalent.
show_shapes(tableau_shape_pal()(8))


if (FALSE) { # \dontrun{
  # All ten, drawn from the device font. Needs a font covering Geometric
  # Shapes, such as DejaVu Sans.
  show_shapes(tableau_shape_pal(unicode = TRUE)(10))
} # }
```
