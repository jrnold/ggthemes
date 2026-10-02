test_that("theme_solid works", {
  thm <- theme_solid(fill = "red")
  expect_s3_class(thm, "theme")
  expect_equal(thm$rect$fill, "red")
})

test_that("theme_solid fills the panel, not just the plot background", {
  thm <- theme_solid(fill = "red")
  for (el in c("plot.background", "panel.background", "legend.key", "strip.background")) {
    expect_equal(ggplot2::calc_element(el, thm)$fill, "red", label = el)
  }
})

test_that("theme_solid draws correctly", {
  expect_doppelganger("theme_solid", theme_test_plot() + theme_solid())
})
