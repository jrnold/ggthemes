test_that("ptol_pal works", {
  p <- ptol_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  expect_hexcolor(p(11))
})

test_that("scale_colour_ptol works", {
  expect_s3_class(scale_colour_ptol(), "ScaleDiscrete")
})

test_that("scale_fill_ptol works", {
  expect_s3_class(scale_fill_ptol(), "ScaleDiscrete")
})
