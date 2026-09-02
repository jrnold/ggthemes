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
