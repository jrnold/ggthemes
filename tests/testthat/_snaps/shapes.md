# circlefill_pal works

    Code
      pal <- circlefill_shape_pal()
    Condition
      Warning:
      `circlefill_shape_pal()` was deprecated in ggthemes 5.0.0.
    Code
      expect_is(pal, "function")
    Condition
      Warning:
      `expect_is()` was deprecated in the 3rd edition.
      i Use `expect_type()`, `expect_s3_class()`, or `expect_s4_class()` instead
    Code
      expect_eqNe(attr(pal, "max_n"), 5L)
    Condition
      Warning:
      Unused arguments (check.environment = FALSE)
    Code
      n <- 4L
      values <- pal(n)
      expect_is(values, "integer")
    Condition
      Warning:
      `expect_is()` was deprecated in the 3rd edition.
      i Use `expect_type()`, `expect_s3_class()`, or `expect_s4_class()` instead
    Code
      expect_eqNe(length(values), n)
    Condition
      Warning:
      Unused arguments (check.environment = FALSE)

# scale_shape_circlefill works

    Code
      expect_is(scale_shape_circlefill(), "ScaleDiscrete")
    Condition
      Warning:
      `expect_is()` was deprecated in the 3rd edition.
      i Use `expect_type()`, `expect_s3_class()`, or `expect_s4_class()` instead
      Warning:
      `scale_shape_circlefill()` was deprecated in ggthemes 5.0.0.
      Warning:
      `circlefill_shape_pal()` was deprecated in ggthemes 5.0.0.

