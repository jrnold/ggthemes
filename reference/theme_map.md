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

## Value

A ggplot2 theme object (class `theme`).

## Examples

``` r
library("ggplot2")

if (requireNamespace("maps", quietly = TRUE) && requireNamespace("mapproj", quietly = TRUE)) {
  us <- map_data("state")
  gg <- ggplot(us, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", color = "black", linewidth = 0.25) +
    coord_map("albers", lat0 = 39, lat1 = 45) +
    theme_map()
  gg
}
```
