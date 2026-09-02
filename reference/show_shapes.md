# Show shapes

A quick and dirty way to show shapes.

## Usage

``` r
show_shapes(shapes, labels = TRUE)
```

## Arguments

- shapes:

  A numeric or character vector of shapes. See
  [`par()`](https://rdrr.io/r/graphics/par.html).

- labels:

  Include the plotting character value of the symbol.

## Value

This function called for the side effect of creating a plot. It returns
`shapes`.

## See also

[`show_col()`](https://scales.r-lib.org/reference/show_col.html),
[`show_linetypes()`](https://jrnold.github.io/ggthemes/reference/show_linetypes.md)

## Examples

``` r
library("scales")

show_shapes(shape_pal()(5))

show_shapes(shape_pal()(3), labels = TRUE)
```
