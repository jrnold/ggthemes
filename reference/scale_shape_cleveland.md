# Shape scales from Cleveland "Elements of Graphing Data"

Shape scales from Cleveland "Elements of Graphing Data"

## Usage

``` r
scale_shape_cleveland(
  overlap = TRUE,
  ...,
  unicode = NULL,
  edition = c("1985", "1994")
)
```

## Arguments

- overlap:

  If `TRUE` (the default), use the symbols for data where overlap causes
  problems: an open circle, a plus sign, an S, a triangle and a U. If
  `FALSE`, use the symbols for data with little overlap: a solid circle,
  an open circle, a circle with a vertical line, a heavy ring, and a
  circled dot.

- ...:

  Arguments passed on to
  [`discrete_scale`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)

  `breaks`

  :   One of:

      - `NULL` for no breaks

      - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
        for the default breaks (the scale limits)

      - A character vector of breaks

      - A function that takes the limits as input and returns breaks as
        output. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation.

  `limits`

  :   One of:

      - `NULL` to use the default scale values

      - A character vector that defines possible values of the scale and
        their order

      - A function that accepts the existing (automatic) values and
        returns new ones. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation.

  `drop`

  :   Should unused factor levels be omitted from the scale? The
      default, `TRUE`, uses the levels that appear in the data; `FALSE`
      includes the levels in the factor. Please note that to display
      every level in a legend, the layer should use
      `show.legend = TRUE`.

  `na.translate`

  :   Unlike continuous scales, discrete scales can easily show missing
      values, and do so by default. If you want to remove missing values
      from a discrete scale, specify `na.translate = FALSE`.

  `na.value`

  :   If `na.translate = TRUE`, what aesthetic value should the missing
      values be displayed as? Does not apply to position scales where
      `NA` is always placed at the far right.

  `aesthetics`

  :   The names of the aesthetics that this scale works with.

  `minor_breaks`

  :   One of:

      - `NULL` for no minor breaks

      - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
        for the default breaks (none for discrete, one minor break
        between each major break for continuous)

      - A numeric vector of positions

      - A function that given the limits returns a vector of minor
        breaks. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation. When the function has two arguments, it will
        be given the limits and major break positions.

  `labels`

  :   One of the options below. Please note that when `labels` is a
      vector, it is highly recommended to also set the `breaks` argument
      as a vector to protect against unintended mismatches.

      - `NULL` for no labels

      - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
        for the default labels computed by the transformation object

      - A character vector giving labels (must be same length as
        `breaks`)

      - An expression vector (must be the same length as breaks). See
        ?plotmath for details.

      - A function that takes the breaks as input and returns labels as
        output. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation.

  `call`

  :   The `call` used to construct the scale for reporting messages.

  `super`

  :   The super class to use for the constructed scale

- unicode:

  If `TRUE`, return pch codes derived from Unicode glyphs, which exist
  for every shape of the palette. They are drawn by the device font, so
  they render as blank boxes in a font without coverage and at unrelated
  sizes in most fonts; the font from
  [`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md)
  has the shapes of this palette at a common size. If `FALSE`, return
  base pch codes, which every font can draw but which exist only for
  some shapes. The default depends on the palette.

- edition:

  Which edition of the book to take the symbols from. One of:

  - `"1985"` (the default): the first edition, Figure 3.70.

  - `"1994"`: the revised (second) edition.

## Value

A ggplot2 scale object.

## References

Cleveland WS. The Elements of Graphing Data. Revised Edition. Hobart
Press, Summit, NJ, 1994, pp. 154-164, 234-239.

## See also

[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md)
for a description of the palette.

Other shapes:
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`embed_shapes_font()`](https://jrnold.github.io/ggthemes/reference/embed_shapes_font.md),
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md),
[`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md),
[`scale_shape_tremmel()`](https://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
library(ggplot2)

ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland(unicode = FALSE)
```
