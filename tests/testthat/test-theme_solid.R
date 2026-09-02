test_that("theme_solid works", {
  thm <- theme_solid(fill = "red")
  expect_s3_class(thm, "theme")
  expect_equal(thm$rect$fill, "red")
})

test_that("theme_solid draws correctly", {
  expect_doppelganger("theme_solid", theme_test_plot() + theme_solid())
})
