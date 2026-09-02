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

