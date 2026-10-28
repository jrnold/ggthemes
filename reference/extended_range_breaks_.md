# Pretty axis breaks inclusive of extreme values, from a range

**\[deprecated\]**

`extended_range_breaks_()` was deprecated in ggthemes 8.0.0. Use
[`extended_range_breaks()`](https://jrnold.github.io/ggthemes/reference/range_breaks.md)
instead: `extended_range_breaks_(dmin, dmax, n)` is
`extended_range_breaks(n)(c(dmin, dmax))`.

## Usage

``` r
extended_range_breaks_(
  dmin,
  dmax,
  n = 5,
  Q = c(1, 5, 2, 2.5, 4, 3),
  w = c(0.25, 0.2, 0.5, 0.05)
)
```

## Arguments

- dmin:

  Minimum of the data range.

- dmax:

  Maximum of the data range.

- n:

  Desired number of breaks.

- Q:

  Set of nice numbers.

- w:

  Weights applied to the four optimization components (simplicity,
  coverage, density, and legibility).

## Value

The vector of axis label locations.
