# Tufte's Box Plot

Edward Tufte's revisions of the box plot as described in *The Visual
Display of Quantitative Information*. This functions provides several
box plot variants:

- A point indicating the median, a gap indicating the interquartile
  range, and lines for whiskers.

- An offset line indicating the interquartile range and a gap indicating
  the median.

- A line indicating the interquartile range, a gap indicating the
  median, and points indicating the minimum and maximum values

- A wide line indicating the interquartile range, a gap indicating the
  median, and lines indicating the minimum and maximum.

## Usage

``` r
geom_tufteboxplot(
  mapping = NULL,
  data = NULL,
  stat = "fivenumber",
  position = "dodge",
  outlier.colour = "black",
  outlier.shape = 19,
  outlier.size = 1.5,
  outlier.stroke = 0.5,
  voffset = 0.01,
  hoffset = 0.005,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  median.type = "point",
  whisker.type = "line",
  ...
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

  The statistical transformation to use on the data for this layer, as a
  string. The default (`stat = 'fivenumber'`) calls
  [`stat_fivenumber`](http://jrnold.github.io/ggthemes/reference/stat_fivenumber.md)
  and produces whiskers that extend from the interquartile range to the
  extremes of the data; specifying
  [`stat_boxplot`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html)
  will produce a more traditional boxplot with whiskers extending to the
  most extreme points that are \< 1.5 IQR away from the hinges (i.e.,
  the first and third quartiles).

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

- outlier.colour:

  colour for outlying points

- outlier.shape:

  shape of outlying points

- outlier.size:

  size of outlying points

- outlier.stroke:

  stroke for outlying points

- voffset:

  controls the size of the gap in the line representing the median when
  `median.type = 'line'`. This is a fraction of the range of `y`.

- hoffset:

  controls how much the interquartile line is offset from the whiskers
  when `median.type = 'line'`. This is a fraction of the range of `x`.

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

- median.type:

  If `'point'`, then the median is represented by a point, and the
  interquartile range by a gap in the line. If `median.type='line'`,
  then the interquartile range is represented by a line, possibly
  offset, and the median by a gap in the line.

- whisker.type:

  If `'line'`, then whiskers are represented by lines. If `'point'`,
  then whiskers are represented by points at `ymin` and `ymax`.

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

## Aesthetics

- x \[required\]

- y \[required\]

- colour

- size

- linetype

- shape

- fill

- alpha

## References

Tufte, Edward R. (2001) The Visual Display of Quantitative Information,
Chapter 6.

McGill, R., Tukey, J. W. and Larsen, W. A. (1978) Variations of box
plots. The American Statistician 32, 12-16.

## See also

[`geom_boxplot()`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html)

Other geom tufte:
[`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md)

Other tufte:
[`extended_range_breaks_()`](http://jrnold.github.io/ggthemes/reference/range_breaks.md),
[`geom_rangeframe()`](http://jrnold.github.io/ggthemes/reference/geom_rangeframe.md),
[`theme_tufte()`](http://jrnold.github.io/ggthemes/reference/theme_tufte.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars, aes(factor(cyl), mpg))
# with a point for the median and lines for whiskers
p + geom_tufteboxplot()
#> Warning: The following aesthetics were dropped during statistical transformation: y.
#> ℹ This can happen when ggplot fails to infer the correct grouping structure in
#>   the data.
#> ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
#>   variable into a factor?
#> Warning: Using the `size` aesthetic in this geom was deprecated in ggplot2 3.4.0.
#> ℹ Please use `linewidth` in the `default_aes` field and elsewhere instead.
#> Warning: Using the `size` aesthetic with geom_segment was deprecated in ggplot2 3.4.0.
#> ℹ Please use the `linewidth` aesthetic instead.

# with a line for the interquartile range and points for whiskers
p + geom_tufteboxplot(median.type = "line", whisker.type = "point", hoffset = 0)
#> Warning: The following aesthetics were dropped during statistical transformation: y.
#> ℹ This can happen when ggplot fails to infer the correct grouping structure in
#>   the data.
#> ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
#>   variable into a factor?

# with a wide line for the interquartile range and lines for whiskers
p + geom_tufteboxplot(median.type = "line", hoffset = 0, width = 3)
#> Warning: The following aesthetics were dropped during statistical transformation: y.
#> ℹ This can happen when ggplot fails to infer the correct grouping structure in
#>   the data.
#> ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
#>   variable into a factor?
#> Warning: `position_dodge()` requires non-overlapping x intervals.

# with an offset line for the interquartile range and lines for whiskers
p + geom_tufteboxplot(median.type = "line")
#> Warning: The following aesthetics were dropped during statistical transformation: y.
#> ℹ This can happen when ggplot fails to infer the correct grouping structure in
#>   the data.
#> ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
#>   variable into a factor?

# combined with theme_tufte
p + geom_tufteboxplot() + theme_tufte() + theme(axis.ticks.x = element_blank())
#> Warning: The following aesthetics were dropped during statistical transformation: y.
#> ℹ This can happen when ggplot fails to infer the correct grouping structure in
#>   the data.
#> ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
#>   variable into a factor?

# traditional boxplot with whiskers only out to 1.5 IQR, outlier points
p + geom_tufteboxplot(stat = "boxplot", outlier.shape = 5)
```
