# Filled Circle Shape palette (discrete)

**\[defunct\]**

This function was deprecated in ggthemes 5.0.0 and is now defunct,
because the unicode glyphs used for the circles vary in size, making
them unusable for plotting. For circles that vary by amount of fill, use
`tableau_shape_pal("proportions", unicode = TRUE)`.

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
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## References

Lewandowsky, Stephan and Ian Spence (1989) "Discriminating Strata in
Scatterplots", Journal of the American Statistical Association,
<https://www.jstor.org/stable/2289649>
