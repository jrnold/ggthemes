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

  `logical`. Horizontal axis lines?

## Value

An object of class
[`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## See also

Other themes excel:
[`theme_excel_new()`](https://jrnold.github.io/ggthemes/reference/theme_excel_new.md)

## Examples

``` r
library("ggplot2")

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
