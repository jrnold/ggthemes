test_that("colorblind_pal works", {
  p <- colorblind_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(4))
  expect_type(attr(p, "max_n"), "integer")
})

test_that("colorblind_pal raises warning with to large n", {
  expect_snapshot(x <- colorblind_pal()(20))
})

test_that("colorblind_pal(black = FALSE) drops black from the palette", {
  p <- colorblind_pal(black = FALSE)
  expect_equal(attr(p, "max_n"), 7L)
  expect_no_match(p(7), "^#000000$")
})

test_that("scale_colour_colourblind works", {
  expect_s3_class(scale_colour_colourblind(), "ScaleDiscrete")
})

test_that("scale_colour_colourblind(black = FALSE) works", {
  expect_s3_class(scale_colour_colourblind(black = FALSE), "ScaleDiscrete")
})

test_that("scale_colour_colorblind is deprecated", {
  lifecycle::expect_deprecated(scale_colour_colorblind())
})

test_that("scale_color_colorblind works", {
  expect_equal_scale(scale_color_colorblind(), scale_colour_colourblind())
})

test_that("scale_fill_colorblind works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(scale_fill_colorblind(), "ScaleDiscrete")
})

test_that("scale_fill_colorblind(black = FALSE) works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(scale_fill_colorblind(black = FALSE), "ScaleDiscrete")
})
