# Points drawn from the shapes font

`geom_point_glyph()` is
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
for the shape palettes made with `unicode = TRUE`. It draws their shapes
from the font that ships with ggthemes (see
[`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md)),
reading the font file itself, so the shapes come out at a common size
without setting a font family on the device or a viewport, and the plot
can be saved with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

## Usage

``` r
geom_point_glyph(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping:

  Set of aesthetic mappings created by
  [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html). If
  specified and `inherit.aes = TRUE` (the default), it is combined with
  the default mapping at the top level of the plot. You must supply
  `mapping` if there is no plot mapping.

- data:

  The data to be displayed in this layer. There are three options:

  If `NULL`, the default, the data is inherited from the plot data as
  specified in the call to
  [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

  A `data.frame`, or other object, will override the plot data. All
  objects will be fortified to produce a data frame. See
  [`fortify()`](https://ggplot2.tidyverse.org/reference/fortify.html)
  for which variables will be created.

  A `function` will be called with a single argument, the plot data. The
  return value must be a `data.frame`, and will be used as the layer
  data. A `function` can be created from a `formula` (e.g.
  `~ head(.x, 10)`).

- stat:

  The statistical transformation to use on the data for this layer. When
  using a `geom_*()` function to construct a layer, the `stat` argument
  can be used to override the default coupling between geoms and stats.
  The `stat` argument accepts the following:

  - A `Stat` ggproto subclass, for example `StatCount`.

  - A string naming the stat. To give the stat as a string, strip the
    function name of the `stat_` prefix. For example, to use
    [`stat_count()`](https://ggplot2.tidyverse.org/reference/geom_bar.html),
    give the stat as `"count"`.

  - For more information and other ways to specify the stat, see the
    [layer
    stat](https://ggplot2.tidyverse.org/reference/layer_stats.html)
    documentation.

- position:

  A position adjustment to use on the data for this layer. This can be
  used in various ways, including to prevent overplotting and improving
  the display. The `position` argument accepts the following:

  - The result of calling a position function, such as
    [`position_jitter()`](https://ggplot2.tidyverse.org/reference/position_jitter.html).
    This method allows for passing extra arguments to the position.

  - A string naming the position adjustment. To give the position as a
    string, strip the function name of the `position_` prefix. For
    example, to use
    [`position_jitter()`](https://ggplot2.tidyverse.org/reference/position_jitter.html),
    give the position as `"jitter"`.

  - For more information and other ways to specify the position, see the
    [layer
    position](https://ggplot2.tidyverse.org/reference/layer_positions.html)
    documentation.

- ...:

  Other arguments passed on to
  [`layer()`](https://ggplot2.tidyverse.org/reference/layer.html)'s
  `params` argument. These arguments broadly fall into one of 4
  categories below. Notably, further arguments to the `position`
  argument, or aesthetics that are required can *not* be passed through
  `...`. Unknown arguments that are not part of the 4 categories below
  are ignored.

  - Static aesthetics that are not mapped to a scale, but are at a fixed
    value and apply to the layer as a whole. For example,
    `colour = "red"` or `linewidth = 3`. The geom's documentation has an
    **Aesthetics** section that lists the available options. The
    'required' aesthetics cannot be passed on to the `params`. Please
    note that while passing unmapped aesthetics as vectors is
    technically possible, the order and required length is not
    guaranteed to be parallel to the input data.

  - When constructing a layer using a `stat_*()` function, the `...`
    argument can be used to pass on parameters to the `geom` part of the
    layer. An example of this is
    `stat_density(geom = "area", outline.type = "both")`. The geom's
    documentation lists which parameters it can accept.

  - Inversely, when constructing a layer using a `geom_*()` function,
    the `...` argument can be used to pass on parameters to the `stat`
    part of the layer. An example of this is
    `geom_area(stat = "density", adjust = 0.5)`. The stat's
    documentation lists which parameters it can accept.

  - The `key_glyph` argument of
    [`layer()`](https://ggplot2.tidyverse.org/reference/layer.html) may
    also be passed on through `...`. This can be one of the functions
    described as [key
    glyphs](https://ggplot2.tidyverse.org/reference/draw_key.html), to
    change the display of the layer in the legend.

- na.rm:

  If `FALSE`, the default, missing values are removed with a warning. If
  `TRUE`, missing values are silently removed.

- show.legend:

  logical. Should this layer be included in the legends? `NA`, the
  default, includes if any aesthetics are mapped. `FALSE` never
  includes, and `TRUE` always includes. It can also be a named logical
  vector to finely select the aesthetics to display. To include legend
  keys for all levels, even when no data exists, use `TRUE`. If `NA`,
  all levels are shown in legend, but unobserved levels are omitted.

- inherit.aes:

  If `FALSE`, overrides the default aesthetics, rather than combining
  with them. This is most useful for helper functions that define both
  data and aesthetics and shouldn't inherit behaviour from the default
  plot specification, e.g.
  [`annotation_borders()`](https://ggplot2.tidyverse.org/reference/annotation_borders.html).

## Value

A ggplot2 layer.

## Devices

A device that can draw glyphs from a font file draws the shapes that
way. That needs R 4.3 or later and a device that reports
`dev.capabilities()$glyphs`, such as
[`pdf()`](https://rdrr.io/r/grDevices/pdf.html), the ragg devices and
the quartz devices. Other devices, such as
[`postscript()`](https://rdrr.io/r/grDevices/postscript.html) and
svglite, draw the shapes as ordinary points in the font family
`"ggthemes shapes"`, which ggthemes registers with systemfonts when it
loads. Devices that read fonts through systemfonts find it there; the
rest fall back to their own fonts.

[`pdf()`](https://rdrr.io/r/grDevices/pdf.html) refers to the font
without embedding it, so the file draws the shapes only where the font
is installed.
[`embed_shapes_font()`](https://jrnold.github.io/ggthemes/reference/embed_shapes_font.md)
embeds it.

Shapes the font does not have, such as the pictographs of
`tableau_shape_pal("weather", unicode = TRUE)`, and base `pch` shapes
are drawn as
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
draws them.

Calling `geom_point_glyph()` tells the `unicode = TRUE` palettes that
the shapes font is in use, so they stop warning about shapes it has, for
every plot in the session, including plots drawn with
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html).
That lasts until ggthemes is unloaded, for example by restarting R or
with `unloadNamespace("ggthemes")`.

## Aesthetics

The aesthetics of
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html):
`x`, `y`, `alpha`, `colour`, `fill`, `shape`, `size` and `stroke`. A
shape drawn from the font is a single solid glyph, so `fill` applies
only to base `pch` shapes 21 to 25.

## See also

Other shapes:
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`embed_shapes_font()`](https://jrnold.github.io/ggthemes/reference/embed_shapes_font.md),
[`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md),
[`scale_shape_cleveland()`](https://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](https://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
library(ggplot2)

# geom_point_glyph() reads the font with the systemfonts package.
if (rlang::is_installed("systemfonts")) {
  # The five symbols of Cleveland's set for little overlap, drawn from the
  # shapes font at a common size. `cut` has five levels, one per symbol.
  diamonds_sample <- head(diamonds, 200)
  ggplot(diamonds_sample, aes(x = carat, y = price, shape = cut)) +
    geom_point_glyph(size = 3) +
    scale_shape_cleveland(overlap = FALSE, unicode = TRUE)

  # Arrows have no base pch, so they need `unicode = TRUE`.
  directions <- data.frame(x = 1:8, y = 1, direction = factor(1:8))
  ggplot(directions, aes(x, y, shape = direction)) +
    geom_point_glyph(size = 8) +
    scale_shape_tableau("arrows", unicode = TRUE) +
    theme_void() +
    theme(legend.position = "none")
}
```
