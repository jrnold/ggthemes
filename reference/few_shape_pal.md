# Shape palette from "Show Me the Numbers" (discrete)

Shape palette from Stephen Few's, "Show Me the Numbers". The shape
palette consists of five shapes: circle, square, triangle, plus, times.

## Usage

``` r
few_shape_pal()
```

## Value

A palette function. It takes the number of shapes `n` and returns an
integer vector of `n` shape (`pch`) codes, and can be used as the
`palette` argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## References

Few, S. (2012) *Show Me the Numbers: Designing Tables and Graphs to
Enlighten*, Analytics Press, p. 208.

## Examples

``` r
few_shape_pal()(5)
#> [1] 1 0 2 3 4

show_shapes(few_shape_pal()(5))
```
