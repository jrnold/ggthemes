test_that("colorblind_pal works", {
  p <- colorblind_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(4))
  expect_type(attr(p, "max_n"), "integer")
})

test_that("colorblind_pal raises warning with to large n", {
  expect_warning(colorblind_pal()(20))
})

test_that("scale_colour_colorblind works", {
  expect_s3_class(scale_colour_colorblind(), "ScaleDiscrete")
})

test_that("scale_color_canva works", {
  expect_equal_scale(scale_color_colorblind(), scale_colour_colorblind())
})

test_that("scale_fill_colorblind works", {
  expect_s3_class(scale_fill_colorblind(), "ScaleDiscrete")
})
