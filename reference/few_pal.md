# Color palettes from Few's "Show Me the Numbers"

Qualitative color palettes from Stephen Few (2012) *Show Me the
Numbers*. There are three palettes: Light, Medium, and Dark. Each
palette comprises nine colors: gray, blue, orange, green, pink, brown,
purple, yellow, red. For `n = 1`, gray is used. For `n > 1`, the eight
non-gray colors are used.

## Usage

``` r
few_pal(palette = "Medium")
```

## Arguments

- palette:

  One of `"Light"`, `"Medium"`, `"Dark"`.

## Value

A palette function. It takes the number of colors `n` and returns a
character vector of `n` hex colors, and can be used as the `palette`
argument of
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Details

Use the light palette for filled areas, such as bar charts. Use the
medium palette for points and lines. Use the dark palette for
highlighting specific points or for small and thin lines and points.

## References

Few, S. (2012) *Show Me the Numbers: Designing Tables and Graphs to
Enlighten*. 2nd edition. Analytics Press.

["Practical Rules for Using Color in
Charts"](https://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).

## See also

Other color few:
[`scale_colour_few()`](https://jrnold.github.io/ggthemes/reference/scale_few.md)

## Examples

``` r
library("scales")

show_col(few_pal()(7))

show_col(few_pal("Dark")(7))

show_col(few_pal("Light")(7))
```
