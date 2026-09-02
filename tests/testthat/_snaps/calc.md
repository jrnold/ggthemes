# calc_pal works

    Code
      x <- pal(100)
    Condition
      Warning:
      This manual palette can handle a maximum of 12 values. You have supplied 100

---

    Code
      pal(-1)
    Condition
      Error in `pal()`:
      ! `n` must be a non-negative integer, not -1.

# calc_shape_pal raises warning for large n

    Code
      x <- calc_shape_pal()(100)
    Condition
      Warning:
      This palette can handle a maximum of 7 values. You have supplied 100.

