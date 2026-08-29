test_that("scale_colour_pander works", {
  expect_s3_class(scale_colour_pander(), "ScaleDiscrete")
})

test_that("scale_fill_pander works", {
  expect_s3_class(scale_fill_pander(), "ScaleDiscrete")
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
  expect_s3_class(theme_pander(), "theme")
})

test_that("theme_pander works with gm = FALSE", {
  thm <- theme_pander(gM = FALSE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.grid, element_blank())
})


test_that("theme_pander warns about ff argument", {
  expect_warning(theme_pander(ff = ""), regexp = "deprecated")
})

test_that("theme_pander warns about fs argument", {
  expect_warning(theme_pander(fs = 1), regexp = "deprecated")
})

test_that("theme_pander works with gm = FALSE", {
  thm <- theme_pander(gm = FALSE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.grid.minor, element_blank())
})

test_that("theme_pander works with nomargin = TRUE", {
  thm <- theme_pander(nomargin = TRUE)
  expect_equal(thm$plot.margin, unit(c(0.1, 0.1, 0.1, 0), "lines"))
})

test_that("theme_pander works with boxes = TRUE", {
  thm <- theme_pander(boxes = TRUE)
  expect_s3_class(thm, "theme")
})

test_that("theme_pander rotates axis text for axis = 0", {
  thm <- theme_pander(axis = 0)
  expect_equal(thm$axis.text.y$angle, 90)
})

test_that("theme_pander rotates axis text for axis = 2", {
  thm <- theme_pander(axis = 2)
  expect_equal(thm$axis.text.x$angle, 90)
})

test_that("theme_pander rotates axis text for axis = 3", {
  thm <- theme_pander(axis = 3)
  expect_equal(thm$axis.text.x$angle, 90)
  expect_equal(thm$axis.text.y$angle, 90)
})

test_that("palette_pander recycles colors when n exceeds the palette size", {
  colors <- palette_pander(10)
  expect_hexcolor(colors)
  expect_equal(length(colors), 10)
})
