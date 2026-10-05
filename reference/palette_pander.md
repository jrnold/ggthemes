# Color palette from the pander package

The pander ships with a default colorblind and printer-friendly color
palette borrowed from `https://jfly.iam.u-tokyo.ac.jp/color/`.

## Usage

``` r
palette_pander(n, random_order = FALSE)
```

## Arguments

- n:

  number of colors. This palette supports up to eight colors.

- random_order:

  if the palette should be reordered randomly before rendering each plot
  to get colorful images

## Value

A character vector of `n` hex colors, recycled if `n` exceeds the number
of colors available. Unlike the other `*_pal()` functions, this is
itself the palette function.

## See also

Other color pander:
[`scale_color_pander()`](https://jrnold.github.io/ggthemes/reference/scale_pander.md)

## Examples

``` r
palette_pander(8)
#> [1] "#56B4E9" "#009E73" "#F0E442" "#0072B2" "#D55E00" "#CC79A7" "#999999"
#> [8] "#E69F00"
# the same colors in a random order
palette_pander(8, random_order = TRUE)
#> [1] "#D55E00" "#999999" "#0072B2" "#E69F00" "#009E73" "#F0E442" "#56B4E9"
#> [8] "#CC79A7"
```
