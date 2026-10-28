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

test_that("theme_solid passes base_size and base_family to text geoms", {
  thm <- theme_solid(base_size = 20, base_family = "serif")
  expect_equal(thm$geom@fontsize, 20 / ggplot2::.pt)
  expect_equal(thm$geom@family, "serif")
})
