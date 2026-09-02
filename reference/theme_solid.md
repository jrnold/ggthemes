# Theme with nothing other than a background color

Theme that removes all non-geom elements (lines, text, etc), This theme
is when only the geometric objects are desired.

## Usage

``` r
theme_solid(base_size = 12, base_family = "", fill = NA)
```

## Arguments

- base_size:

  Base font size.

- base_family:

  Ignored, kept for consistency with
  [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

- fill:

  Background color of the plot.

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
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
