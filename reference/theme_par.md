# Theme based on base graphics parameters

Theme which uses the current "base" graphics parameter values from
[`graphics::par()`](https://rdrr.io/r/graphics/par.html). Not all
[`par()`](https://rdrr.io/r/graphics/par.html) parameters are supported,
and not all are relevant to ggplot2 themes.

## Usage

``` r
theme_par(base_size = par()$ps, base_family = par()$family)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Value

A ggplot2 theme object (class `theme`).

## Details

Currently this theme uses the values of the parameters: `"ps"`,
`"family"`, `"fg"`, `"bg"`, `"col"`, `"adj"`, `"font"`, `"cex.axis"`,
`"cex.lab"`, `"cex.main"`, `"cex.sub"`, `"col.axis"`, `"col.lab"`,
`"col.main"`, `"col.sub"`, `"font.axis"`, `"font.lab"`, `"font.main"`,
`"font.sub"`, `"las"`, `"lend"`, `"lheight"`, `"lty"`, `"mar"`, `"tcl"`,
`"tck"`, `"xaxt"`, `"yaxt"`.

This theme does not translate the base graphics perfectly, so the graphs
produced by it will not be identical to those produced by base graphics,
most notably in the spacing of the margins.

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_solid()`](https://jrnold.github.io/ggthemes/reference/theme_solid.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)

p + theme_par()


# theme changes with respect to values of par
old_par <- par(font = 2, col.lab = "red", fg = "white", bg = "black")
p + theme_par()

par(old_par)
```
