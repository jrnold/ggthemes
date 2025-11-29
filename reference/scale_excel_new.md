# Excel (current versions) color scales

Discrete color scales used in current versions of Microsoft Office and
Excel.

## Usage

``` r
scale_colour_excel_new(theme = "Office Theme", ...)

scale_color_excel_new(theme = "Office Theme", ...)

scale_fill_excel_new(theme = "Office Theme", ...)
```

## Arguments

- theme:

  The name of the Office theme or color theme (not to be confused with
  ggplot2 themes) from which to derive the color palette. Available
  themes include: `"Atlas"`, `"Badge"`, `"Berlin"`, `"Celestial"`,
  `"Crop"`, `"Depth"`, `"Droplet"`, `"Facet"`, `"Feathered"`,
  `"Gallery"`, `"Headlines"`, `"Integral"`, `"Ion Boardroom"`, `"Ion"`,
  `"Madison"`, `"Main Event"`, `"Mesh"`, `"Office Theme"`, `"Organic"`,
  `"Parallax"`, `"Parcel"`, `"Retrospect"`, `"Savon"`, `"Slice"`,
  `"Vapor Trail"`, `"View"`, `"Wisp"`, `"Wood Type"`, `"Aspect"`,
  `"Blue Green"`, `"Blue II"`, `"Blue Warm"`, `"Blue"`, `"Grayscale"`,
  `"Green Yellow"`, `"Green"`, `"Marquee"`, `"Median"`,
  `"Office 2007-2010"`, `"Orange Red"`, `"Orange"`, `"Paper"`,
  `"Red Orange"`, `"Red Violet"`, `"Red"`, `"Slipstream"`,
  `"Violet II"`, `"Violet"`, `"Yellow Orange"`, `"Yellow"`

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

  `guide`

  :   A function used to create a guide or its name. See
      [`guides()`](https://ggplot2.tidyverse.org/reference/guides.html)
      for more information.

  `call`

  :   The `call` used to construct the scale for reporting messages.

  `super`

  :   The super class to use for the constructed scale

## See also

Other colour excel:
[`excel_new_pal()`](http://jrnold.github.io/ggthemes/reference/excel_new_pal.md),
[`excel_pal()`](http://jrnold.github.io/ggthemes/reference/excel_pal.md),
[`scale_fill_excel()`](http://jrnold.github.io/ggthemes/reference/scale_excel.md)

## Examples

``` r
library("ggplot2")

p <- ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
  facet_wrap(~am)
p + theme_excel_new() + scale_colour_excel_new()
#> Warning: The `size` argument of `element_line()` is deprecated as of ggplot2 3.4.0.
#> ℹ Please use the `linewidth` argument instead.
#> ℹ The deprecated feature was likely used in the ggthemes package.
#>   Please report the issue at <https://github.com/jrnold/ggthemes/issues>.
```
