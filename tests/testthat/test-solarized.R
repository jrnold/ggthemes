test_that("theme_solarized_works", {
  expect_s3_class(theme_solarized(), "theme")
  expect_s3_class(theme_solarized(light = FALSE), "theme")
})

test_that("theme_solarized_2_works", {
  expect_s3_class(theme_solarized_2(), "theme")
  expect_s3_class(theme_solarized_2(light = FALSE), "theme")
})

test_that("scale_colour_solarized works", {
  expect_s3_class(scale_colour_solarized(), "ScaleDiscrete")
})

test_that("scale_color_solarized works", {
  expect_equal_scale(scale_colour_solarized(), scale_color_solarized())
})

test_that("scale_fill_solarized works", {
  expect_s3_class(scale_fill_solarized(), "ScaleDiscrete")
})

test_that("solarized_pal works", {
  pal <- solarized_pal()
  expect_type(pal, "closure")
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})
