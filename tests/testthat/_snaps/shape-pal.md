# cleveland's palettes still default to base pch, and say the default will change

    Code
      values <- cleveland_shape_pal()(5)
    Condition
      Warning:
      Calling `cleveland_shape_pal()` without `unicode` was deprecated in ggthemes 8.0.0.
      i `unicode` defaults to `FALSE`, and will default to `TRUE` in ggthemes 9.0.0.
      i Set `unicode = FALSE` to keep base pch shapes, or `unicode = TRUE` to draw all five symbols.
    Code
      scale <- scale_shape_cleveland(overlap = FALSE)
    Condition
      Warning:
      Calling `scale_shape_cleveland()` without `unicode` was deprecated in ggthemes 8.0.0.
      i `unicode` defaults to `FALSE`, and will default to `TRUE` in ggthemes 9.0.0.
      i Set `unicode = FALSE` to keep base pch shapes, or `unicode = TRUE` to draw all five symbols.

# cleveland's edition is 1985 unless asked otherwise

    Code
      cleveland_shape_pal(unicode = FALSE, edition = "1994 revised")
    Condition
      Error in `cleveland_shape_pal()`:
      ! `edition` must be one of "1985" or "1994", not "1994 revised".

---

    Code
      scale_shape_cleveland(unicode = FALSE, edition = "second")
    Condition
      Error in `scale_shape_cleveland()`:
      ! `edition` must be one of "1985" or "1994", not "second".

# `unicode` must be TRUE or FALSE

    Code
      calc_shape_pal(unicode = NA)
    Condition
      Error in `calc_shape_pal()`:
      ! `unicode` must be `TRUE` or `FALSE`, not `NA`.

---

    Code
      tableau_shape_pal("arrows", unicode = c(TRUE, FALSE))
    Condition
      Error in `tableau_shape_pal()`:
      ! `unicode` must be `TRUE` or `FALSE`, not a logical vector.

---

    Code
      cleveland_shape_pal(unicode = "yes")
    Condition
      Error in `cleveland_shape_pal()`:
      ! `unicode` must be `TRUE` or `FALSE`, not a string.

