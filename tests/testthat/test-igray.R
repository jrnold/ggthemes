test_that("theme_igray works", {
  thm <- theme_igray()
  expect_s3_class(thm, "theme")
  expect_equal(thm$plot.background$fill, "gray90")
})

test_that("theme_igray draws correctly", {
  expect_doppelganger("theme_igray", theme_test_plot() + theme_igray())
})
