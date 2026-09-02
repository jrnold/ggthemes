test_that("canva_pal works", {
  p <- canva_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(4))
})

test_that("canva_pal works with alt palette", {
  expect_hexcolor(canva_pal("Pop art")(4))
})

test_that("canva_pal raises warning with to large n", {
  expect_snapshot(x <- canva_pal()(10))
})


test_that("canva_pal raises error with invalid palette", {
  expect_snapshot(canva_pal("adsffafd"), error = TRUE)
})

test_that("scale_colour_canva works", {
  expect_s3_class(scale_colour_canva(), "ScaleDiscrete")
})

test_that("scale_color_canva works", {
  expect_equal_scale(scale_color_canva(), scale_colour_canva())
})

test_that("scale_colour_canva works", {
  expect_s3_class(scale_fill_canva(), "ScaleDiscrete")
})
