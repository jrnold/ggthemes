# hc_pal raises error with invalid palette

    Code
      hc_pal(palette = "asdgasdgasdgas")
    Condition
      Error in `hc_pal()`:
      ! `palette` must be one of "default" and "darkunica", not "asdgasdgasdgas".

# bgcolor raises warning

    Code
      x <- theme_hc(bgcolor = "darkunica")
    Condition
      Warning:
      `bgcolor` is deprecated. Use `style` instead.

