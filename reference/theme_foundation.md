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
theme_foundation(
  base_size = 12,
  base_family = "",
  ink = "black",
  paper = "white",
  accent = "#3366FF"
)
```

## Arguments

- base_size:

  base font size, given in pts.

- base_family:

  base font family

- ink, paper, accent:

  colour for foreground, background, and accented elements respectively.

## Details

This theme takes
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
and sets all `colour` and `fill` values to `NULL`, except for the
top-level elements (`line`, `rect`, and `title`), which have
`colour = ink`, and `fill = paper`. This leaves the spacing and-non
colour defaults of the default ggplot2 themes in place.

Unlike `theme_foundation()`, the other themes in this package (e.g.
[`theme_economist()`](https://jrnold.github.io/ggthemes/reference/theme_economist.md),
[`theme_excel()`](https://jrnold.github.io/ggthemes/reference/theme_excel.md),
[`theme_hc()`](https://jrnold.github.io/ggthemes/reference/theme_hc.md))
intentionally replicate a fixed, published visual style, so they do not
expose `ink`/`paper`/`accent` arguments.

## See also

Other themes:
[`theme_base()`](https://jrnold.github.io/ggthemes/reference/theme_base.md),
[`theme_clean()`](https://jrnold.github.io/ggthemes/reference/theme_clean.md),
[`theme_igray()`](https://jrnold.github.io/ggthemes/reference/theme_igray.md),
[`theme_par()`](https://jrnold.github.io/ggthemes/reference/theme_par.md),
[`theme_solid()`](https://jrnold.github.io/ggthemes/reference/theme_solid.md)
