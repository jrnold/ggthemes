context("hc")

test_that("hc_pal works", {
  pal <- hc_pal()
  expect_is(pal, "function")
  n <- 5
  values <- pal(n)
  expect_is(values, "character")
  expect_equal(length(values), n)
})

test_that("hc_pal raises error with invalid palette", {
  expect_error(hc_pal(palette = "asdgasdgasdgas"),
               regexp = "not valid")
})

test_that("scale_colour_hc works", {
  expect_is(scale_colour_hc(), "ScaleDiscrete")
})

test_that("scale_color_hc works", {
  expect_equal(scale_colour_hc(), scale_color_hc())
})

test_that("scale_fill_hc works", {
  expect_is(scale_fill_hc(), "ScaleDiscrete")
})

test_that("theme_hc works", {
  expect_is(theme_hc(), "theme")
  expect_is(theme_hc(style = "darkunica"), "theme")
})

test_that("bgcolor raises warning", {
  expect_warning(theme_hc(bgcolor = "darkunica"), regexp = "deprecated")
})
