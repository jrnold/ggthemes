test_that("theme_wsj works", {
  expect_s3_class(theme_wsj(), "theme")
})

test_that("wsj_pal works", {
  p <- wsj_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  expect_hexcolor(p(3))
})

test_that("theme_wsj works", {
  expect_s3_class(theme_wsj(), "theme")
})

test_that("theme_wsj raises error with invalid palette", {
  expect_error(wsj_pal("asdgasa"), regexp = "valid palette")
})

test_that("scale_colour_wsj works", {
  expect_s3_class(scale_colour_wsj(), "ScaleDiscrete")
})

test_that("scale_fill_wsj works", {
  expect_s3_class(scale_fill_wsj(), "ScaleDiscrete")
})
