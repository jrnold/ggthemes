test_that("theme_clean works", {
  thm <- theme_clean()
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.background, element_blank())
  expect_equal(thm$axis.line.x$colour, "black")
})

test_that("theme_clean respects base_size and base_family", {
  thm <- theme_clean(base_size = 20, base_family = "serif")
  expect_equal(thm$axis.title$size, ceiling(20 * 0.8))
  expect_equal(thm$legend.text$family, "sans")
})

test_that("theme_clean draws correctly", {
  expect_doppelganger("theme_clean", theme_test_plot() + theme_clean())
})
