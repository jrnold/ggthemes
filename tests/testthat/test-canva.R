context("canva")

test_that("canva_pal works", {
  p <- canva_pal()
  expect_is(p, "function")
  expect_hexcolor(p(4))
})

test_that("canva_pal works with alt palette", {
  expect_hexcolor(canva_pal("Pop art")(4))
})

test_that("canva_pal raises warning with to large n", {
  expect_warning(canva_pal()(10))
})


test_that("canva_pal raises error with invalid palette", {
  expect_error(canva_pal("adsffafd"), regexp = "not a valid name")
})

test_that("scale_colour_canva works", {
  expect_is(scale_colour_canva(), "ScaleDiscrete")
})

test_that("scale_color_canva works", {
  expect_equal(scale_color_canva(), scale_colour_canva())
})

test_that("scale_colour_canva works", {
  expect_is(scale_fill_canva(), "ScaleDiscrete")
})
