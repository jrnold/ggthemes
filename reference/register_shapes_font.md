# Register a font that draws the shapes at a common size

The shape palettes made with `unicode = TRUE` draw each shape by asking
the device font for a Unicode character. Fonts draw those characters at
unrelated sizes, so a circle, a triangle and a plus sign from one font
can differ by a factor of two in area, and a font may not have the
character at all. `register_shapes_font()` registers a font that ships
with ggthemes and contains the geometric shapes, arrows, signs and marks
used by the palettes, at the same Unicode characters, so the same
palettes draw with comparable sizes.

## Usage

``` r
register_shapes_font()
```

## Value

The font family name, `"ggthemes shapes"`, to pass as a `fontfamily`. As
side effects, the font is registered with systemfonts again, in case the
registry was cleared, and the palettes stop warning about shapes the
font has.

## Size

Each glyph is scaled until the convex hull of its outline has the area
of one reference circle. That keeps hollow, filled and rotated shapes
comparable, and it is the convention R's own `pch` symbols follow
(circle, square, diamond and triangle have equal area). Stroke widths
are fixed. The exclamation mark is too narrow to reach the reference
area without outgrowing the em box, so it is drawn smaller.

## Coverage

The font covers every shape the `unicode = TRUE` palettes draw, so they
need no other font:
[`calc_shape_pal()`](https://jrnold.github.io/ggthemes/reference/calc_shape_pal.md),
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`stata_shape_pal()`](https://jrnold.github.io/ggthemes/reference/stata_shape_pal.md)
and
[`tableau_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_shape_pal.md).
It also covers the Tableau `"kpi"`, `"arrows"` and `"thin-arrows"`
palettes and the sign shapes of `"gender"` (see
[`tableau_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_shape_pal.md)).
It does not cover the pictograph shapes: the Tableau `"weather"` and
`"bug-tracking"` palettes and the restroom signs of `"gender"`. Those
characters still come from the device font. Palettes with no `unicode`
argument, such as
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md),
use base `pch` symbols and need no font.

## Using the font

The simplest way is
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md)
in place of
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html).
It reads the font file itself, needs no font family set anywhere, and
works with
[`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

With
[`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html),
the font must be set on the device font family, because
[`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
does not take a `family`. With a graphics device that reads fonts
through systemfonts, such as ragg or svglite, set the family on a grid
viewport around the plot:

    family <- register_shapes_font()
    p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
      geom_point() +
      scale_shape_tableau(unicode = TRUE)
    print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))

A palette made with `unicode = TRUE` warns, when the plot is built, if
the device's default font lacks its shapes; it cannot see a family set
on a viewport. Once `register_shapes_font()` or
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md)
has been called, it warns only about shapes this font does not have.
That lasts until ggthemes is unloaded, for example by restarting R or
with `unloadNamespace("ggthemes")`, since the setting lives in the
package namespace.

ggthemes registers the font with systemfonts when it loads, if
systemfonts is installed, so the family name `"ggthemes shapes"` works
even before `register_shapes_font()` is called.

[`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) draws
the plot without that viewport, so the font does not apply through it;
draw the plot to the device yourself, as above.

Devices that look fonts up themselves
([`pdf()`](https://rdrr.io/r/grDevices/pdf.html), and
[`png()`](https://rdrr.io/r/grDevices/png.html) with the cairo type) do
not see fonts registered this way; install
`system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes")` on
the system to use the font there. A copy installed on the system is used
as it is: `register_shapes_font()` does not register the family a second
time.

The font is original work distributed under the same license as the
package. It is built by `data-raw/shapes-font/build.py`.

## See also

[`tableau_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tableau_shape_pal.md)
and
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md)
for palettes made with `unicode = TRUE`.

Other shapes:
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`embed_shapes_font()`](https://jrnold.github.io/ggthemes/reference/embed_shapes_font.md),
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md),
[`scale_shape_cleveland()`](https://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](https://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
if (FALSE) { # rlang::is_installed(c("systemfonts", "ragg")) && interactive()
library("ggplot2")
family <- register_shapes_font()
p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
  geom_point(size = 4) +
  scale_shape_tableau(unicode = TRUE)
png_file <- tempfile(fileext = ".png")
ragg::agg_png(png_file, width = 480, height = 360)
print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
dev.off()
}
```
