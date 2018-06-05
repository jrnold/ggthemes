context("excel")

test_that("excel_clasic_pal works", {
  pal <- excel_classic_pal()
  n <- 5L
  values <- pal(n)
  expect_is(values, "character")
  expect_true(all(values < 0))
  expect_equal(length(values), n)
})

test_that("calc_shape_pal raises warning for large n", {
  expect_warning(excel_classic_pal()(8))
})

test_that("excel_pal works", {
  pal <- excel_pal()
  n <- 5L
  vals <- pal(n)
  expect_is(vals, "character")
  expect_true(all(vals < 0))
  expect_equal(length(vals), n)
})

test_that("excel_pal raises error for bad n", {
  expect_warning(excel_pal()(7))
})

test_that("theme_excel_classic works", {
  expect_is(theme_excel_classic(), "theme")
})
