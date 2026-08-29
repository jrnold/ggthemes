test_that("colorblind_pal works", {
  p <- colorblind_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(4))
  expect_type(attr(p, "max_n"), "integer")
})

test_that("colorblind_pal raises warning with to large n", {
  expect_warning(colorblind_pal()(20))
})

test_that("colorblind_pal(black = FALSE) drops black from the palette", {
  p <- colorblind_pal(black = FALSE)
  expect_equal(attr(p, "max_n"), 7L)
  expect_false("#000000" %in% p(7))
})

test_that("scale_colour_colourblind works", {
  expect_s3_class(scale_colour_colourblind(), "ScaleDiscrete")
})

test_that("scale_colour_colourblind(black = FALSE) works", {
  expect_s3_class(scale_colour_colourblind(black = FALSE), "ScaleDiscrete")
})

test_that("scale_fill_colorblind works", {
  expect_s3_class(scale_fill_colorblind(), "ScaleDiscrete")
})

test_that("scale_fill_colorblind(black = FALSE) works", {
  expect_s3_class(scale_fill_colorblind(black = FALSE), "ScaleDiscrete")
})
