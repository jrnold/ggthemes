test_that("gdocs_pal works", {
  pal <- gdocs_pal()
  expect_type(pal, "closure")
  n <- 3
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("scale_fill_gdocs works", {
  expect_s3_class(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_colour_gdocs works", {
  expect_s3_class(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_color_gdocs works", {
  expect_equal_scale(scale_color_gdocs(), scale_colour_gdocs())
})

test_that("theme_gdocs works", {
  expect_s3_class(theme_gdocs(), "theme")
})
