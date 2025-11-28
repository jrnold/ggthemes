# Clean theme for maps

A clean theme that is good for displaying maps from
[`geom_map()`](https://ggplot2.tidyverse.org/reference/geom_map.html).

## Usage

``` r
theme_map(base_size = 9, base_family = "")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Examples

``` r
library("maps")
#> 
#> Attaching package: ‘maps’
#> The following object is masked from ‘package:purrr’:
#> 
#>     map
library("ggplot2")

us <- fortify(map_data("state"), region = "region")
#> Warning: Arguments in `...` must be used.
#> ✖ Problematic argument:
#> • region = "region"
#> ℹ Did you misspell an argument name?
gg <- ggplot() +
  geom_map(
    data = us, map = us,
    aes(x = long, y = lat, map_id = region, group = group),
    fill = "white", color = "black", size = 0.25
  ) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  theme_map()
#> Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
#> ℹ Please use `linewidth` instead.
#> Warning: Ignoring unknown aesthetics: x and y
gg
```
