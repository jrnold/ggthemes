# Pretty axis breaks inclusive of extreme values

This function returns pretty axis breaks that always include the extreme
values of the data. This works by calling the extended Wilkinson
algorithm (Talbot et al., 2010), constrained to solutions interior to
the data range. Then, the minimum and maximum labels are moved to the
minimum and maximum of the data range.

## Usage

``` r
extended_range_breaks_(
  dmin,
  dmax,
  n = 5,
  Q = c(1, 5, 2, 2.5, 4, 3),
  w = c(0.25, 0.2, 0.5, 0.05)
)

extended_range_breaks(n = 5, ...)
```

## Arguments

- dmin:

  minimum of the data range

- dmax:

  maximum of the data range

- n:

  desired number of breaks

- Q:

  set of nice numbers

- w:

  weights applied to the four optimization components (simplicity,
  coverage, density, and legibility)

- ...:

  other arguments passed to `extended_range_breaks_()`

## Value

For `extended_range_breaks_`, the vector of axis label locations. For
`extended_range_breaks`, a function which takes a single argument, a
vector of data, and returns the vector of axis label locations.

## Details

`extended_range_breaks_` implements the algorithm and returns the break
values. `extended_range_breaks` uses the conventions of the scales
package, and returns a function.

Note that ggplot2 hands a `breaks` function the expanded scale limits,
not the data range. Passing `extended_range_breaks()` directly to
`breaks` therefore places the end labels at the panel edges rather than
at the extremes of the data. To label the extremes, which is what pairs
with
[`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md),
apply the function to the data instead:
`scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt))`.

## References

Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of Wilkinson's
Algorithm for Positioning Tick Labels on Axes, InfoVis 2010.

## Author

Justin Talbot <jtalbot@stanford.edu>, Jeffrey B. Arnold, Baptiste Auguie
