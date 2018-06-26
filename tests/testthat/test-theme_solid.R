context("theme_solid")

test_that("theme_solid works", {
  thm <- theme_solid(fill = "red")
  expect_is(thm, "theme")
  expect_equal(thm$rect$fill, "red")
})
