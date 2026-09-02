# hc_pal raises error with invalid palette

    Code
      hc_pal(palette = "asdgasdgasdgas")
    Condition
      Error in `hc_pal()`:
      ! `palette` must be one of "default", "default_dark", "classic", "darkunica", "grid_light", "sand_signika", "high_contrast_light", "high_contrast_dark", "avocado", and "sunset", not "asdgasdgasdgas".

# bgcolor raises warning

    Code
      x <- theme_hc(bgcolor = "darkunica")
    Condition
      Warning:
      `bgcolor` is deprecated. Use `style` instead.

