# zero_range errors for vectors of the wrong length

    Code
      zero_range(c(1, 2, 3))
    Condition
      Error in `zero_range()`:
      ! `x` must be length 1 or 2, not 3.

# smart_digits and smart_digits_format are deprecated

    Code
      out <- smart_digits(c(1.234, 5.678))
    Condition
      Warning:
      `smart_digits()` was deprecated in ggthemes 8.0.0.
      i Please use `scales::label_number()` instead.
    Code
      fmt <- smart_digits_format()
    Condition
      Warning:
      `smart_digits_format()` was deprecated in ggthemes 8.0.0.
      i Please use `scales::label_number()` instead.

