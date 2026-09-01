test_that("excel_clasic_pal works", {
  pal <- excel_pal()
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("excel_clasic_pal with line = TRUE works", {
  pal <- excel_pal(line = TRUE)
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("calc_shape_pal raises warning for large n", {
  expect_warning(excel_pal()(8))
})

test_that("excel_new_pal works", {
  pal <- excel_new_pal()
  n <- 5L
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("excel_new_pal raises error for bad n", {
  expect_warning(excel_new_pal()(7))
})

test_that("theme_excel works", {
  expect_s3_class(theme_excel(), "theme")
})

test_that("theme_excel respects base_family and base_size", {
  thm <- theme_excel(base_family = "mono", base_size = 20)
  expect_equal(thm$text$family, "mono")
  expect_equal(thm$text$size, 20)
})

test_that("excel_new_pal raises error with bad theme name", {
  expect_error(excel_new_pal("adfaasdfa"), regexp = "`theme` must be one of")
})

test_that("scale_fill_excel works", {
  expect_s3_class(scale_fill_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_s3_class(scale_colour_excel(), "ScaleDiscrete")
})

test_that("scale_colour_excel works", {
  expect_s3_class(scale_fill_excel_new(), "ScaleDiscrete")
})

test_that("scale_fill_excel works", {
  expect_s3_class(scale_colour_excel_new(), "ScaleDiscrete")
})

test_that("theme_excel with horizontal = FALSE works", {
  thm <- theme_excel(horizontal = FALSE)
  expect_equal(thm$panel.grid.major.y, element_blank())
})

test_that("theme_excel_new respects base_size for all text elements", {
  thm <- theme_excel_new(base_size = 20)
  expect_equal(thm$text$size, 20)
  expect_equal(thm$axis.text$size, 20)
  expect_equal(thm$strip.text$size, 20)
  expect_equal(thm$legend.text$size, 20)
})

test_that("theme_excel_new does not blank out axis titles", {
  thm <- theme_excel_new()
  expect_null(thm$axis.title)
})

test_that("theme_excel draws correctly", {
  expect_doppelganger("theme_excel", theme_test_plot() + theme_excel())
})

test_that("theme_excel_new draws correctly", {
  expect_doppelganger("theme_excel_new", theme_test_plot() + theme_excel_new())
})
