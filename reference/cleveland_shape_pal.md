# Shape palette from Cleveland "Elements of Graphing Data" (discrete).

Shape palettes for overlapping and non-overlapping points.

## Usage

``` r
cleveland_shape_pal(overlap = TRUE)
```

## Arguments

- overlap:

  `logical` Use the scale for overlapping points?

## Note

In the *Elements of Graphing Data*, W.S. Cleveland suggests two shape
palettes for scatter plots: one for overlapping data and another for
non-overlapping data. The symbols for overlapping data relies on pattern
discrimination, while the symbols for non-overlapping data vary the
amount of fill. This palette attempts to create these palettes. However,
I found that these were hard to replicate. Using the R shapes and
unicode fonts: the symbols can vary in size, they are dependent of the
fonts used, and there does not exist a unicode symbol for a circle with
a vertical line. If someone can improve this palette, please let me
know.

Following Tremmel (1995), I replace the circle with a vertical line with
an encircled plus sign.

The palette `cleveland_shape_pal()` supports up to five values.

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
