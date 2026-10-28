# circlefill_shape_pal and scale_shape_circlefill are defunct

    Code
      circlefill_shape_pal()
    Condition
      Error:
      ! `circlefill_shape_pal()` was deprecated in ggthemes 5.0.0 and is now defunct.
      i Please use `tableau_shape_pal("proportions", unicode = TRUE)` instead.

---

    Code
      scale_shape_circlefill()
    Condition
      Error:
      ! `scale_shape_circlefill()` was deprecated in ggthemes 5.0.0 and is now defunct.
      i Please use `scale_shape_tableau(palette = "proportions", unicode = TRUE)` instead.

# warn_unicode_pch warns only for unicode pch on non-UTF-8 locales

    Code
      x <- warn_unicode_pch(c(-9675, -9679))
    Condition
      Warning:
      This shape palette uses pch codes derived from Unicode symbols, and your R session's locale is not UTF-8.
      i Rendering may fail with a low-level error (e.g. "conversion failure ... in 'mbcsToSbcs'").
      i Try a UTF-8 locale, or a Cairo-based graphics device (e.g. cairo_pdf(), agg_png()).

# scale_shape_tremmel() takes alt by name only

    Code
      scale_shape_tremmel(TRUE, TRUE)
    Condition
      Error in `scale_shape_tremmel()`:
      ! Arguments in `...` must be named.
      x Unnamed argument in position 1.

