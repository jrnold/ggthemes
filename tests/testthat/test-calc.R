test_that("calc_shape_pal works", {
  pal <- calc_shape_pal()
  expect_type(pal, "closure")
  expect_type(attr(pal, "max_n"), "integer")
  n <- 5L
  shapes <- pal(n)
  expect_type(shapes, "integer")
  # Base pch by default; the glyph branch is covered in test-shape-pal.R.
  expect_contains(c(0:25, 32:127), shapes)
  expect_equal(length(shapes), n)
})

test_that("calc_pal works", {
  pal <- calc_pal()
  expect_type(pal, "closure")
  expect_type(attr(pal, "max_n"), "integer")
  n <- 5L
  expect_hexcolor(pal(n))
  expect_snapshot(x <- pal(100))
  expect_snapshot(pal(-1), error = TRUE)
})

test_that("calc_shape_pal raises warning for large n", {
  expect_snapshot(x <- calc_shape_pal()(100))
})

test_that("theme_calc works", {
  expect_s3_class(theme_calc(), "theme")
})

test_that("scale_colour_calc works", {
  expect_s3_class(scale_colour_calc(), "ScaleDiscrete")
})

test_that("scale_fill_calc works", {
  expect_s3_class(scale_fill_calc(), "ScaleDiscrete")
})

test_that("scale_shape_calc works", {
  expect_s3_class(scale_shape_calc(), "ScaleDiscrete")
})

test_that("theme_calc draws correctly", {
  expect_doppelganger("theme_calc", theme_test_plot() + theme_calc())
})
