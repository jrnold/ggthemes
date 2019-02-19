context("excel")

test_that("excel_clasic_pal works", {
  pal <- excel_pal()
  n <- 5L
  values <- pal(n)
  expect_is(values, "character")
  expect_equal(length(values), n)
})

test_that("excel_clasic_pal with line = TRUE works", {
  pal <- excel_pal(line = TRUE)
  n <- 5L
  values <- pal(n)
  expect_is(values, "character")
  expect_equal(length(values), n)
})

test_that("calc_shape_pal raises warning for large n", {
  expect_warning(excel_pal()(8))
})

test_that("excel_new_pal works", {
  pal <- excel_new_pal()
  n <- 5L
  vals <- pal(n)
  expect_is(vals, "character")
  expect_equal(length(vals), n)
})

test_that("excel_new_pal raises error for bad n", {
  expect_warning(excel_new_pal()(7))
})

test_that("theme_excel works", {
  expect_is(theme_excel(), "theme")
})

test_that("excel_new_pal raises error with bad theme name", {
  expect_error(excel_new_pal("adfaasdfa"), regexp = "`theme` must be one of")
})

test_that("scale_fill_excel works", {
  expect_is(scale_fill_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_is(scale_colour_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_is(scale_fill_excel_new(), "ScaleDiscrete")
})

test_that("scale_fill_excel works", {
  expect_is(scale_colour_excel_new(), "ScaleDiscrete")
})

test_that("theme_excel with horizontal = FALSE works", {
  thm <- theme_excel(horizontal = FALSE)
  expect_equal(thm$panel.grid.major.y, element_blank())
})
