# theme_par warns for the symbol font

    Code
      thm <- withr::with_par(list(font.main = 5), theme_par())
    Condition
      Warning in `theme_par()`:
      Font 5 has no ggplot2 font face, so `theme_par()` uses "plain".

