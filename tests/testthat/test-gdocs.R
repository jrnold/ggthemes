context("gdocs")

test_that("gdocs_pal works", {
  pal <- gdocs_pal()
  expect_is(pal, "function")
  n <- 3
  vals <- pal(n)
  expect_is(vals, "character")
  expect_equal(length(vals), n)
})

test_that("scale_fill_gdocs works", {
  expect_is(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_colour_gdocs works", {
  expect_is(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_color_gdocs works", {
  expect_equal(scale_color_gdocs(), scale_colour_gdocs())
})

test_that("theme_gdocs works", {
  expect_is(theme_gdocs(), "theme")
})
