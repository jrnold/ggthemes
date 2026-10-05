# Clean theme for maps

A clean theme that is good for displaying maps from
[`ggplot2::geom_map()`](https://ggplot2.tidyverse.org/reference/geom_map.html).

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

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](https://jrnold.github.io/ggthemes/reference/theme_solid.md)

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
