context("ptol")

test_that("ptol_pal works", {
  p <- ptol_pal()
  expect_is(p, "function")
  expect_is(attr(p, "max_n"), "integer")
  expect_hexcolor(p(11))
})

test_that("scale_colour_ptol works", {
  expect_is(scale_colour_ptol(), "ScaleDiscrete")
})

test_that("scale_fill_ptol works", {
  expect_is(scale_fill_ptol(), "ScaleDiscrete")
})
