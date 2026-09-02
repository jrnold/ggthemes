# Shape palette from Cleveland "Elements of Graphing Data" (discrete).

Shape palettes for overlapping and non-overlapping points.

## Usage

``` r
cleveland_shape_pal(overlap = TRUE, unicode = FALSE)
```

## Arguments

- overlap:

  `logical` Use the scale for overlapping points?

- unicode:

  If `TRUE`, return pch codes derived from Unicode glyphs, as this
  palette did before ggthemes 6.1.0. Glyph shapes are drawn by the
  device font, so they render as blank boxes in a font without coverage;
  the default returns base pch codes, which every font can draw.

## Note

In the *Elements of Graphing Data*, W.S. Cleveland suggests two shape
palettes for scatter plots: one for overlapping data and another for
non-overlapping data. The symbols for overlapping data rely on pattern
discrimination, while the symbols for non-overlapping data vary the
amount of fill.

Following Tremmel (1995), the circle with a vertical line is replaced by
an encircled plus sign.

`cleveland_shape_pal(overlap = TRUE)` supports four values on either
branch.

`cleveland_shape_pal(overlap = FALSE)` supports three values by default
and five with `unicode = TRUE`. Its five source symbols encode *fill
fraction*, which base pch cannot express, so the two partially filled
circles are dropped rather than approximated by a different shape. To
encode a proportion, map `alpha` or `fill` instead; to restore the five
glyphs, use `unicode = TRUE` with a font that covers Mathematical
Operators, such as STIX Two Text.

The truncation is arguably an improvement. Tremmel (1995) Experiment 2
tested exactly this five-symbol set and found the fill-graded circles
the worst performers measured, with the encircled plus and encircled dot
the slowest pair and the one producing the most errors. The three shapes
that survive are the better-separating subset.

## References

Cleveland WS. *The Elements of Graphing Data*. Revised Edition. Hobart
Press, Summit, NJ, 1994, pp. 154-164, 234-239.

Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in
Scatterplots", *Journal of Computational and Graphical Statistics*,
<https://www.jstor.org/stable/1390760>

## See also

Other shapes:
[`circlefill_shape_pal()`](http://jrnold.github.io/ggthemes/reference/circlefill_shape_pal.md),
[`scale_shape_circlefill()`](http://jrnold.github.io/ggthemes/reference/scale_shape_circlefill.md),
[`scale_shape_cleveland()`](http://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](http://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](http://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
###   (discrete).

if (FALSE) { # \dontrun{
library("ggplot2")
p <- ggplot(mtcars) +
     geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
     facet_wrap(~am) +
     theme_bw()
# overlapping symbol palette
p + scale_shape_cleveland()
# non-overlapping symbol palette
p + scale_shape_cleveland(overlap = FALSE)
} # }
```
