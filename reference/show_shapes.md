# Show shapes

A quick and dirty way to show shapes.

## Usage

``` r
show_shapes(shapes, labels = TRUE)
```

## Arguments

- shapes:

  A numeric or character vector of shapes. See
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html).

- labels:

  If `TRUE` (the default), label each symbol with its plotting character
  value.

## Value

Called for its side effect of creating a plot; returns `shapes`
invisibly.

## See also

[`scales::show_col()`](https://scales.r-lib.org/reference/show_col.html),
[`show_linetypes()`](https://jrnold.github.io/ggthemes/reference/show_linetypes.md)

## Examples

``` r
library("scales")

show_shapes(shape_pal()(5))

show_shapes(shape_pal()(3), labels = TRUE)
```
