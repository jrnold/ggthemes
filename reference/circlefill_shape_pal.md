# Filled Circle Shape palette (discrete)

\`r lifecycle::badge("deprecated")\`

This function was deprecated because unicode glyphs used for the circles
vary in size, making them unusable for plotting.

Shape palette with circles varying by amount of fill. This uses the set
of 3 circle fill values in Lewandowsky and Spence (1989): solid, hollow,
half-filled, with two additional fill amounts: three-quarters, and
one-quarter.

This palette supports up to five values.

## Usage

``` r
circlefill_shape_pal()
```

## Value

A palette function. It takes the number of shapes `n` and returns an
integer vector of `n` shape (`pch`) codes, and can be used as the
`palette` argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## References

Lewandowsky, Stephan and Ian Spence (1989) "Discriminating Strata in
Scatterplots", Journal of the American Statistical Association,
<https://www.jstor.org/stable/2289649>

## See also

Other shapes:
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`scale_shape_circlefill()`](https://jrnold.github.io/ggthemes/reference/scale_shape_circlefill.md),
[`scale_shape_cleveland()`](https://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](https://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
circlefill_shape_pal()(3)
#> Warning: `circlefill_shape_pal()` was deprecated in ggthemes 5.0.0.
#> [1] -9675 -9679 -9683
```
