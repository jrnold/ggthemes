# Foundation Theme

This theme is designed to be a foundation from which to build new
themes, and not meant to be used directly. `theme_foundation()` is a
complete theme with only minimal number of elements defined. It is
easier to create new themes by extending this one rather than
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
or [`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html),
because those themes define elements deep in the hierarchy.

## Usage

``` r
theme_foundation(base_size = 12, base_family = "")
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

## Details

This theme takes
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
and sets all `colour` and `fill` values to `NULL`, except for the
top-level elements (`line`, `rect`, and `title`), which have
`colour = "black"`, and `fill = "white"`. This leaves the spacing
and-non colour defaults of the default ggplot2 themes in place.

## See also

Other themes:
[`theme_base()`](http://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](http://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_igray()`](http://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_par()`](http://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](http://jrnold.github.io/ggthemes/reference/theme_solid.md)
