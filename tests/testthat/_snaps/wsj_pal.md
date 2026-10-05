# theme_wsj raises error with invalid palette

    Code
      wsj_pal("asdgasa")
    Condition
      Error in `wsj_pal()`:
      ! `palette` must be one of "rgby", "red_green", "black_green", "dem_rep", and "colors6", not "asdgasa".

# theme_wsj() rejects an unknown color

    Code
      theme_wsj(color = "purple")
    Condition
      Error in `theme_wsj()`:
      ! `color` must be one of "gray", "green", "blue", and "brown", not "purple".

