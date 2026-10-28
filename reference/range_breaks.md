# Pretty axis breaks inclusive of extreme values

This function returns pretty axis breaks that always include the extreme
values of the data. This works by calling the extended Wilkinson
algorithm (Talbot et al., 2010), constrained to solutions interior to
the data range. Then, the minimum and maximum labels are moved to the
minimum and maximum of the data range.

## Usage

``` r
extended_range_breaks(n = 5, ...)
```

## Arguments

- n:

  Desired number of breaks.

- ...:

  Other arguments passed to the algorithm:

  - `Q`: set of nice numbers, by default `c(1, 5, 2, 2.5, 4, 3)`.

  - `w`: weights applied to the four optimization components
    (simplicity, coverage, density, and legibility), by default
    `c(0.25, 0.2, 0.5, 0.05)`.

## Value

A function which takes a single argument, a vector of data, and returns
the vector of axis label locations.

## Details

`extended_range_breaks()` follows the conventions of the scales package:
it returns a function that takes a vector of data and returns the
breaks.

Note that ggplot2 hands a `breaks` function the expanded scale limits,
not the data range. Passing `extended_range_breaks()` directly to
`breaks` therefore places the end labels at the panel edges rather than
at the extremes of the data. To label the extremes, which is what pairs
with
[`geom_rangeframe()`](https://jrnold.github.io/ggthemes/reference/geom_rangeframe.md),
apply the function to the data instead:
`scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt))`.

## References

Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of Wilkinson's
Algorithm for Positioning Tick Labels on Axes, InfoVis 2010.

## See also

Other tufte:
[`geom_rangeframe()`](https://jrnold.github.io/ggthemes/reference/geom_rangeframe.md),
[`geom_tufteboxplot()`](https://jrnold.github.io/ggthemes/reference/geom_tufteboxplot.md),
[`theme_tufte()`](https://jrnold.github.io/ggthemes/reference/theme_tufte.md)

## Author

Justin Talbot <jtalbot@stanford.edu>, Jeffrey B. Arnold, Baptiste Auguie

## Examples

``` r
# Pretty breaks that always include the extremes of the data
extended_range_breaks()(mtcars$wt)
#> [1] 1.513 3.000 4.000 5.424

library(ggplot2)

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_rangeframe() +
  scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt)) +
  scale_y_continuous(breaks = extended_range_breaks()(mtcars$mpg)) +
  theme_tufte()
```
