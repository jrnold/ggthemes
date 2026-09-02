# geom_rangeframe drops rows with NA x/y before drawing

    Code
      filtered <- GeomRangeFrame$handle_na(data, list(na.rm = FALSE))
    Condition
      Warning:
      Removed 2 rows containing missing values or values outside the scale range (`geom_range_frame()`).

