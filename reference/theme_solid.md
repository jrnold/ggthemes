# Theme with nothing other than a background color

Theme that removes all non-geom elements (lines, text, etc.). Use it
when only the geometric objects are desired. The `base_family` argument
is ignored; it is kept for consistency with
[`ggplot2::theme_grey()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).

## Usage

``` r
theme_solid(base_size = 12, base_family = "", fill = NA)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- fill:

  The background color of the plot.

## Value

A ggplot2 theme object (class `theme`).

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_map()`](https://jrnold.github.io/ggthemes/reference/theme_map.md),
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md)

## Examples

``` r
library("ggplot2")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_solid(fill = "white")


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = "white") +
  theme_solid(fill = "black")
```
