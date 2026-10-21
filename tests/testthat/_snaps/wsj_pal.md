# theme_wsj raises error with invalid palette

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

