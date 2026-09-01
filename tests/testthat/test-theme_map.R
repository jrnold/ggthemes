test_that("theme_map works", {
  thm <- theme_map()
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.background, element_blank())
})

test_that("theme_map draws correctly", {
  expect_doppelganger("theme_map", theme_test_plot() + theme_map())
})
