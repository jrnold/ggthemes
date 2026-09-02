# canva_pal raises warning with to large n

    Code
      x <- canva_pal()(10)
    Condition
      Warning:
      This manual palette can handle a maximum of 4 values. You have supplied 10

# canva_pal raises error with invalid palette

    Code
      canva_pal("adsffafd")
    Condition
      Error in `canva_pal()`:
      ! "adsffafd" is not a valid `palette` name.
      i See `names(canva_palettes)` for valid names.

