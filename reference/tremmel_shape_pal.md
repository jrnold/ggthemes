# Shape palette from Tremmel (1995) (discrete)

Based on experiments Tremmel (1995) suggests the following shape
palettes:

## Usage

``` r
tremmel_shape_pal(overlap = FALSE, alt = FALSE)
```

## Arguments

- overlap:

  use an empty circle instead of a solid circle when `n == 2`.

- alt:

  If `TRUE`, then when `n == 3`, use a solid circle, plus sign and empty
  triangle. Otherwise use a solid circle, empty circle, and empty
  triangle. Defaults to `FALSE`, the triple Tremmel's Experiment 1
  actually measured; the `TRUE` triple is argued on feature-dimension
  grounds that Tremmel flags as not directly supported by the
  experiments.

## Details

If two symbols, then use a solid circle and plus sign.

If three symbols, then use a solid circle, empty circle, and an empty
triangle. However, that set of symbols does not satisfy the requirement
that each symbol should differ from the other symbols in the same
feature dimension. A set of three symbols that satisfies this is a
circle (curvature), plus sign (number of terminators), triangle (line
orientation).

This palette supports up to three values. If more than three groups of
data, then separate the groups into different plots.

## References

Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in
Scatterplots" Journal of Computational and Graphical Statistics,
<https://www.jstor.org/stable/1390760>

## See also

Other shapes:
[`circlefill_shape_pal()`](http://jrnold.github.io/ggthemes/reference/circlefill_shape_pal.md),
[`cleveland_shape_pal()`](http://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`scale_shape_circlefill()`](http://jrnold.github.io/ggthemes/reference/scale_shape_circlefill.md),
[`scale_shape_cleveland()`](http://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](http://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md)
