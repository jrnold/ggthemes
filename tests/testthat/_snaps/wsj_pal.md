# wsj_pal() rejects an unknown palette

    Code
      wsj_pal("asdgasa")
    Condition
      Error in `wsj_pal()`:
      ! `palette` must be one of "comparison", "actual_forecast", "direction", "party", "categorical", "categorical_light", "categorical_dark", "blues", "greens", "reds", "golds", and "oranges", not "asdgasa".

# theme_wsj() rejects an unknown paper

    Code
      theme_wsj(paper = "purple")
    Condition
      Error in `theme_wsj()`:
      ! `paper` must be one of "ivory" and "gray", not "purple".

# pre-8.0.0 palette names are deprecated

    Code
      x <- wsj_pal("rgby")(2)
    Condition
      Warning:
      The "rgby" palette of `wsj_pal()` was deprecated in ggthemes 8.0.0.
      This palette has no like-for-like replacement.
      i The current palettes are "comparison", "actual_forecast", "direction", "party", "categorical", "categorical_light", "categorical_dark", "blues", "greens", "reds", "golds", "oranges".
      i They use different colors, so switching will change the plot.
    Code
      x <- wsj_pal("red_green")(2)
    Condition
      Warning:
      The "red_green" palette of `wsj_pal()` was deprecated in ggthemes 8.0.0.
      This palette has no like-for-like replacement.
      i The current palettes are "comparison", "actual_forecast", "direction", "party", "categorical", "categorical_light", "categorical_dark", "blues", "greens", "reds", "golds", "oranges".
      i They use different colors, so switching will change the plot.
    Code
      x <- wsj_pal("black_green")(2)
    Condition
      Warning:
      The "black_green" palette of `wsj_pal()` was deprecated in ggthemes 8.0.0.
      This palette has no like-for-like replacement.
      i The current palettes are "comparison", "actual_forecast", "direction", "party", "categorical", "categorical_light", "categorical_dark", "blues", "greens", "reds", "golds", "oranges".
      i They use different colors, so switching will change the plot.
    Code
      x <- wsj_pal("dem_rep")(2)
    Condition
      Warning:
      The "dem_rep" palette of `wsj_pal()` was deprecated in ggthemes 8.0.0.
      i Please use the "party" palette instead.
    Code
      x <- wsj_pal("colors6")(2)
    Condition
      Warning:
      The "colors6" palette of `wsj_pal()` was deprecated in ggthemes 8.0.0.
      This palette has no like-for-like replacement.
      i The current palettes are "comparison", "actual_forecast", "direction", "party", "categorical", "categorical_light", "categorical_dark", "blues", "greens", "reds", "golds", "oranges".
      i They use different colors, so switching will change the plot.

# theme_wsj(color=) warns once, not twice

    Code
      thm <- theme_wsj(color = "brown")
    Condition
      Warning:
      The `color` argument of `theme_wsj()` is deprecated as of ggthemes 8.0.0.
      i Please use the `paper` argument instead.

# palette errors name the input and the function called

    Code
      wsj_pal(NULL)
    Condition
      Error in `wsj_pal()`:
      ! `palette` must be a string, not NULL.
    Code
      scale_fill_gradient_wsj("x")
    Condition
      Error in `scale_fill_gradient_wsj()`:
      ! `palette` must be one of "steel" and "blue", not "x".
    Code
      wsj_callout(1, 1, "x", facets = list("b"))
    Condition
      Error in `wsj_callout()`:
      ! `facets` must be a list named by faceting variable, as in `facets = list(panel = "A")`.
    Code
      wsj_callout(1, 1, "x", facets = list(f = 1:3))
    Condition
      Error in `wsj_callout()`:
      ! `facets$f` must have length 1, not 3.
    Code
      wsj_callout(1:2, 1:2, c("x", "y"), facets = list(f = 1:3))
    Condition
      Error in `wsj_callout()`:
      ! `facets$f` must have length 1 or 2, not 3.

