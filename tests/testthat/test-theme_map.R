test_that("theme_map works", {
  thm <- theme_map()
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.background, element_blank())
})

test_that("theme_map places the legend inside without a numeric legend.position", {
  thm <- theme_map()
  expect_equal(thm$legend.position, "inside")
  expect_equal(thm$legend.position.inside, c(0, 0))
  # ggplot2 >= 3.5.0 converts a numeric legend.position itself, so the fields
  # above match either way; only the deprecation shows the old form.
  withr::local_options(lifecycle_verbosity = "warning")
  expect_no_condition(theme_map(), class = "lifecycle_warning_deprecated")
})

test_that("theme_map draws correctly", {
  expect_doppelganger("theme_map", theme_test_plot() + theme_map())
})
