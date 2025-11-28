# Show linetypes

A quick and dirty way to show linetypes.

## Usage

``` r
show_linetypes(linetypes, labels = TRUE)
```

## Arguments

- linetypes:

  A character vector of linetypes. See
  [`par()`](https://rdrr.io/r/graphics/par.html).

- labels:

  Label each line with its linetype (lty) value.

## Value

This function called for the side effect of creating a plot. It returns
`linetypes`.

## See also

[`show_col()`](https://scales.r-lib.org/reference/show_col.html),
`show_linetypes()`

## Examples

``` r
library("scales")

show_linetypes(linetype_pal()(3))

show_linetypes(linetype_pal()(3), labels = TRUE)
```
