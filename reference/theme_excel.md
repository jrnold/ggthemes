# ggplot theme based on old Excel plots

Theme to replicate the ugly monstrosity that was the old gray-background
Excel chart. Please never use this. This theme should be combined with
the
[`scale_colour_excel()`](https://jrnold.github.io/ggthemes/reference/scale_excel.md)
color scale.

## Usage

``` r
theme_excel(base_size = 12, base_family = "", horizontal = TRUE)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- horizontal:

  If `TRUE` (the default), draw horizontal grid lines.

## Value

An object of class
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## Palettes

The theme sets
[`excel_pal()`](https://jrnold.github.io/ggthemes/reference/excel_pal.md)
for discrete color (`line = TRUE`) and fill (`line = FALSE`) as the
default palettes, so a plot draws in the theme's colors without a
matching scale. A `scale_*()` added to the plot still takes precedence.

## See also

Other themes excel:
[`theme_excel_new()`](https://jrnold.github.io/ggthemes/reference/theme_excel_new.md)

## Examples

``` r
library(ggplot2)

# Line and scatter plot colors
p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_excel() + scale_colour_excel()


# Bar plot (area/fill) colors
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar() +
  scale_fill_excel() +
  theme_excel()
```
