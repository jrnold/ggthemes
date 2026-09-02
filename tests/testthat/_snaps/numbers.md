# numbers_pal raises an error for an unknown palette

    Code
      numbers_pal("Chartreuse")
    Condition
      Error in `numbers_pal()`:
      ! `palette` must be one of "Blue Green", "Blue Violet", "Blue", "Brown", "Classic", "Earth Tone", "Gray", "Green", "Jade", "Mid Century", "Showroom", and "Spectrum", not "Chartreuse".

# numbers_pal raises a warning for large n

    Code
      x <- numbers_pal()(7L)
    Condition
      Warning:
      This palette can handle a maximum of 6 values. You have supplied 7.

