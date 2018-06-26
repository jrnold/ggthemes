context("calc")

test_that("calc_shape_pal works", {
  pal <- calc_shape_pal()
  expect_is(pal, "function")
  expect_is(attr(pal, "max_n"), "integer")
  n <- 5L
  shapes <- pal(n)
  expect_is(shapes, "integer")
  expect_true(all(shapes < 0))
  expect_equal(length(shapes), n)
})

test_that("calc_pal works", {
  pal <- calc_pal()
  expect_is(pal, "function")
  expect_is(attr(pal, "max_n"), "integer")
  n <- 5L
  expect_hexcolor(pal(n))
  expect_warning(pal(100))
  expect_error(pal(-1))
})

test_that("calc_shape_pal raises warning for large n", {
  expect_warning(calc_shape_pal()(100))
})

test_that("theme_calc works", {
  expect_is(theme_calc(), "theme")
})

test_that("scale_colour_calc works", {
  expect_is(scale_colour_calc(), "ScaleDiscrete")
})

test_that("scale_fill_calc works", {
  expect_is(scale_fill_calc(), "ScaleDiscrete")
})

test_that("scale_shape_calc works", {
  expect_is(scale_shape_calc(), "ScaleDiscrete")
})
