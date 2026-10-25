# Theme based on base graphics parameters

Theme which uses the current "base" graphics parameter values from
[`graphics::par()`](https://rdrr.io/r/graphics/par.html). Not all
[`par()`](https://rdrr.io/r/graphics/par.html) parameters are supported,
and not all are relevant to ggplot2 themes.

## Usage

``` r
theme_par(base_size = par("ps") * par("cex"), base_family = par("family"))
```

## Arguments

- base_size:

  Base font size, in points. Defaults to the base graphics text size,
  `par("ps") * par("cex")`.

- base_family:

  Base font family. Defaults to `par("family")`.

## Value

A ggplot2 theme object (class `theme`).

## Details

Currently this theme uses the values of the parameters: `"adj"`,
`"ann"`, `"bg"`, `"bty"`, `"cex"`, `"cex.axis"`, `"cex.lab"`,
`"cex.main"`, `"cex.sub"`, `"cin"`, `"col.axis"`, `"col.lab"`,
`"col.main"`, `"col.sub"`, `"family"`, `"fg"`, `"font"`, `"font.axis"`,
`"font.lab"`, `"font.main"`, `"font.sub"`, `"las"`, `"lend"`,
`"lheight"`, `"lty"`, `"lwd"`, `"mar"`, `"mex"`, `"mgp"`, `"oma"`,
`"pin"`, `"ps"`, `"tck"`, `"tcl"`, `"xaxt"`, `"yaxt"`.

The `"sub"` parameters style `plot.subtitle`, `plot.caption` and
`strip.text`. Box types (`"bty"`) other than `"o"`, `"l"` and `"n"` are
drawn as a full box, since a theme can only draw axis lines on the sides
that have an axis. As in base graphics, `bty = "n"` still draws the axis
lines; `guide_axis(cap = "both")` ends them at the outermost ticks the
way [`graphics::axis()`](https://rdrr.io/r/graphics/axis.html) does. A
`tck` of 0.5 or more draws grid lines, and a smaller `tck` is converted
using the current plot region size, `"pin"`.

This theme does not translate the base graphics perfectly, so the graphs
produced by it will not be identical to those produced by base graphics,
most notably in the spacing of the margins.

Like [`graphics::par()`](https://rdrr.io/r/graphics/par.html) itself,
`theme_par()` opens a graphics device if none is open, because the
parameter values belong to a device.

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_foundation()`](https://jrnold.github.io/ggthemes/reference/theme_foundation.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_map()`](https://jrnold.github.io/ggthemes/reference/theme_map.md),
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
