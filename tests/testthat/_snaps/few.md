# few_shape_pal works

    Code
      x <- out(10)
    Condition
      Warning:
      This palette can handle a maximum of 5 values. You have supplied 10.

# few_pal runs

    Code
      x <- p(10)
    Condition
      Warning:
      This palette can handle a maximum of 8 values. You have supplied 10.

# few_pal raises error with bad palette

    Code
      few_pal("Foo")
    Condition
      Error in `few_pal()`:
      ! `palette` must be one of "Light", "Medium", and "Dark", not "Foo".

