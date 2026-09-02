# circlefill_pal works

    Code
      pal <- circlefill_shape_pal()
    Condition
      Warning:
      `circlefill_shape_pal()` was deprecated in ggthemes 5.0.0.
    Code
      expect_type(pal, "closure")
      expect_equal(attr(pal, "max_n"), 5L)
      n <- 4L
      values <- pal(n)
      expect_type(values, "integer")
      expect_equal(length(values), n)

# warn_unicode_pch warns only for unicode pch on non-UTF-8 locales

    Code
      x <- warn_unicode_pch(c(-9675, -9679))
    Condition
      Warning:
      This shape palette uses pch codes derived from Unicode symbols, and your R session's locale is not UTF-8.
      i Rendering may fail with a low-level error (e.g. "conversion failure ... in 'mbcsToSbcs'").
      i Try a UTF-8 locale, or a Cairo-based graphics device (e.g. cairo_pdf(), agg_png()).

