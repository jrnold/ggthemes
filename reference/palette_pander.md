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

## See also

Other colour pander:
[`scale_color_pander()`](http://jrnold.github.io/ggthemes/reference/scale_pander.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  palette_pander(TRUE)
} # }
```
