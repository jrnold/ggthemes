# Inverse gray theme

Theme with white panel and gray background.

## Usage

``` r
theme_igray(base_size = 12, base_family = "")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Details

This theme inverts the colors in the
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html),
a white panel and a light gray area around it. This keeps a white
background for the color scales like
[`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).
But by using a gray background, the plot is closer to the typographical
color of the document, which is the motivation for using a gray panel in
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).
This is similar to the style of plots in Stata and Tableau.

## See also

[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html),
[`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](https://jrnold.github.io/ggthemes/reference/theme_solid.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_igray()
```
