# Show linetypes

A quick and dirty way to show linetypes.

## Usage

``` r
show_linetypes(linetypes, labels = TRUE)
```

## Arguments

- linetypes:

  A character vector of linetypes. See
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html).

- labels:

  If `TRUE` (the default), label each line with its linetype (`lty`)
  value.

## Value

Called for its side effect of creating a plot; returns `linetypes`
invisibly.

## See also

[`scales::show_col()`](https://scales.r-lib.org/reference/show_col.html),
[`show_shapes()`](https://jrnold.github.io/ggthemes/reference/show_shapes.md)

## Examples

``` r
library("scales")

show_linetypes(linetype_pal()(3))

show_linetypes(linetype_pal()(3), labels = TRUE)
```
