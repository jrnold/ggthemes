context("wsj")

test_that("theme_wsj works", {
  expect_is(theme_wsj(), "theme")
})

test_that("wsj_pal works", {
  p <- wsj_pal()
  expect_is(p, "function")
  expect_is(attr(p, "max_n"), "integer")
  expect_hexcolor(p(3))
})

test_that("theme_wsj works", {
  expect_is(theme_wsj(), "theme")
})

test_that("theme_wsj raises error with invalid palette", {
  expect_error(wsj_pal("asdgasa"), regexp = "valid palette")
})

test_that("scale_colour_wsj works", {
  expect_is(scale_colour_wsj(), "ScaleDiscrete")
})

test_that("scale_fill_wsj works", {
  expect_is(scale_fill_wsj(), "ScaleDiscrete")
})
