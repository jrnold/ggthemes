# Highcharts color palette (discrete)

Highcharts uses many different color palettes in its plots. This
collects the palettes shipped with Highcharts 13, plus the default
Highcharts used before v11.

## Usage

``` r
hc_pal(palette = "default")
```

## Arguments

- palette:

  `character` The name of the Highcharts palette to use. One of
  `"default"`, `"default_dark"`, `"classic"`, `"darkunica"`,
  `"grid_light"`, `"sand_signika"`, `"high_contrast_light"`,
  `"high_contrast_dark"`, `"avocado"`, `"sunset"` .

## Value

A palette function. It takes the number of colours `n` and returns a
character vector of `n` hex colours, and can be used as the `palette`
argument of
[`discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Details

`"default"` and `"default_dark"` are the light- and dark-mode forms of
the palette Highcharts has used by default since v11.0.0; they differ
only in positions 2 and 3. `"classic"` is the default Highcharts used
from v5.0.0 through v10.x. The remaining palettes come from the themes
bundled with Highcharts.

Note that `"avocado"` and `"sunset"` have only four colors.

## See also

Other colour hc:
[`scale_colour_hc()`](https://jrnold.github.io/ggthemes/reference/scale_hc.md)

## Examples

``` r
hc_pal()(6)
#> [1] "#2caffe" "#544fc5" "#00e272" "#fe6a35" "#6b8abc" "#d568fb"

scales::show_col(hc_pal("darkunica")(4))
```
