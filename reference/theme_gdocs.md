# Theme with Google Docs Chart defaults

Theme similar to the default look of charts in Google Docs.

## Usage

``` r
theme_gdocs(base_size = 12, base_family = "sans")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_gdocs() + scale_color_gdocs()
```
