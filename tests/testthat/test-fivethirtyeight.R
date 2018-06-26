context("fivethirtyeight")

test_that("theme_fivethirtyeight works", {
  expect_is(theme_fivethirtyeight(), "theme")
})

test_that("scale_fill_fivethirtyeight works", {
  expect_is(scale_fill_fivethirtyeight(), "ScaleDiscrete")
})

test_that("scale_colour_fivethirtyeight works", {
  expect_is(scale_colour_fivethirtyeight(), "ScaleDiscrete")
})

test_that("fivethirtyeight_pal works", {
  p <- fivethirtyeight_pal()
  expect_is(p, "function")
  expect_is(attr(p, "max_n"), "integer")
  expect_hexcolor(p(3))
})
