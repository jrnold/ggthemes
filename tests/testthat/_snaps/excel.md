# calc_shape_pal raises warning for large n

    Code
      x <- excel_pal()(8)
    Condition
      Warning:
      This manual palette can handle a maximum of 7 values. You have supplied 8

# excel_new_pal raises error for bad n

    Code
      x <- excel_new_pal()(7)
    Condition
      Warning:
      This manual palette can handle a maximum of 6 values. You have supplied 7

# excel_new_pal raises error with bad theme name

    Code
      excel_new_pal("adfaasdfa")
    Condition
      Error in `excel_new_pal()`:
      ! `theme` must be one of "Atlas", "Badge", "Berlin", "Celestial", "Crop", "Depth", "Droplet", "Facet", "Feathered", "Gallery", "Headlines", "Integral", "Ion Boardroom", "Ion", "Madison", "Main Event", "Mesh", "Office Theme", ..., "Yellow Orange", and "Yellow".

