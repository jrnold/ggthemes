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

test_that("calc_shape_pal raises warning for large n", {
  expect_warning(calc_shape_pal()(100))
})
