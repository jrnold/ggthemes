context("pander")

test_that("scale_colour_pander works", {
  expect_is(scale_colour_pander(), "ScaleDiscrete")
})

test_that("scale_fill_pander works", {
  expect_is(scale_fill_pander(), "ScaleDiscrete")
})

test_that("palette_pander works", {
  colors <- palette_pander(5)
  expect_hexcolor(colors)
})

test_that("palette_pander random_order=TRUE works", {
  colors <- palette_pander(5, random_order = TRUE)
  expect_hexcolor(colors)
})

test_that("theme_pander works", {
  expect_is(theme_pander(), "theme")
})

test_that("theme_pander works with gm = FALSE", {
  thm <- theme_pander(gM = FALSE)
  expect_is(thm, "theme")
  expect_equal(thm$panel.grid, element_blank())
})


test_that("theme_pander warns about ff argument", {
  expect_warning(theme_pander(ff = ""), regexp = "deprecated")
})

test_that("theme_pander warns about fs argument", {
  expect_warning(theme_pander(fs = 1), regexp = "deprecated")
})
