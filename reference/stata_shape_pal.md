# Stata shape palette (discrete)

Shape palette based on the symbol palette in Stata used in scheme
s2mono. This palette supports up to 10 values.

## Usage

``` r
stata_shape_pal(unicode = FALSE)
```

## Arguments

- unicode:

  If `TRUE`, return pch codes derived from Unicode glyphs, as this
  palette did before ggthemes 6.1.0. Glyph shapes are drawn by the
  device font, so they render as blank boxes in a font without coverage;
  the default returns base pch codes, which every font can draw.

## Note

Stata's ten plotting symbols all have a base pch equivalent, so this
palette supports ten values on either branch and nothing is dropped:
solid and hollow circle, diamond, square and triangle, plus the X and
the plus sign.

## See also

See
[`scale_shape_stata()`](http://jrnold.github.io/ggthemes/reference/scale_shape_stata.md)
for examples.
