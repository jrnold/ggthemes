context("solarized")

test_that("theme_solarized_works", {
  expect_is(theme_solarized(), "theme")
  expect_is(theme_solarized(light = FALSE), "theme")
})

test_that("theme_solarized_2_works", {
  expect_is(theme_solarized_2(), "theme")
  expect_is(theme_solarized_2(light = FALSE), "theme")
})

test_that("scale_colour_solarized works", {
  expect_is(scale_colour_solarized(), "ScaleDiscrete")
})

test_that("scale_color_solarized works", {
  expect_equal(scale_colour_solarized(), scale_color_solarized())
})

test_that("scale_fill_solarized works", {
  expect_is(scale_fill_solarized(), "ScaleDiscrete")
})

test_that("solarized_pal works", {
  pal <- solarized_pal()
  expect_is(pal, "function")
  n <- 5L
  values <- pal(n)
  expect_is(values, "character")
  expect_equal(length(values), n)
})
