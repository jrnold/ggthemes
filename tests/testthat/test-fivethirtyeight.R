test_that("theme_fivethirtyeight works", {
  expect_s3_class(theme_fivethirtyeight(), "theme")
})

test_that("scale_fill_fivethirtyeight works", {
  expect_s3_class(scale_fill_fivethirtyeight(), "ScaleDiscrete")
})

test_that("scale_colour_fivethirtyeight works", {
  expect_s3_class(scale_colour_fivethirtyeight(), "ScaleDiscrete")
})

test_that("fivethirtyeight_pal works", {
  p <- fivethirtyeight_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  expect_hexcolor(p(3))
})
