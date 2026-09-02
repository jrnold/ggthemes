# ggplot theme similar to current Excel plot defaults

Theme for ggplot2 that is similar to the default style of charts in
current versions of Microsoft Excel.

## Usage

``` r
theme_excel_new(base_size = 9, base_family = "sans")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Value

An object of class
[`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## See also

Other themes excel:
[`theme_excel()`](https://jrnold.github.io/ggthemes/reference/theme_excel.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_excel_new() + scale_colour_excel_new()
```
