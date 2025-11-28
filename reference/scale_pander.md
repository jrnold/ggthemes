# Color scale from the pander package

The pander ships with a default colorblind and printer-friendly color
palette borrowed from `https://jfly.iam.u-tokyo.ac.jp/color/`.

## Usage

``` r
scale_color_pander(...)

scale_colour_pander(...)

scale_fill_pander(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`discrete_scale`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)

  `palette`

  :   A palette function that when called with a single integer argument
      (the number of levels in the scale) returns the values that they
      should take (e.g.,
      [`scales::pal_hue()`](https://scales.r-lib.org/reference/pal_hue.html)).

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

  `labels`

  :   One of:

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

[`theme_pander()`](http://jrnold.github.io/ggthemes/reference/theme_pander.md)

Other colour pander:
[`palette_pander()`](http://jrnold.github.io/ggthemes/reference/palette_pander.md)
