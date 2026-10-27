# Base R graphics theme

Theme similar to the default settings of the "base" R graphics.

## Usage

``` r
theme_base(base_size = 12, base_family = "")
```

## Arguments

- base_size:

  Base font size, in points. The default, 12, is the default text size
  of base graphics devices.

- base_family:

  base font family

## Value

A ggplot2 theme object (class `theme`).

## Details

The theme is fixed: it does not change with
[`graphics::par()`](https://rdrr.io/r/graphics/par.html). Use
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md)
for a theme that follows the current
[`par()`](https://rdrr.io/r/graphics/par.html) values.

## See also

Other themes:
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_map()`](https://jrnold.github.io/ggthemes/reference/theme_map.md),
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](https://jrnold.github.io/ggthemes/reference/theme_solid.md)

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars) +
  geom_point(aes(
    x = wt,
    y = mpg,
    colour = factor(gear)
  )) +
  facet_wrap(~am)
p + theme_base()

# theme_base() is fixed; use theme_par() to follow the current par() values
old_par <- par(fg = "blue", bg = "gray", col.lab = "red", font.lab = 3)
p + theme_par()

par(old_par)
```
