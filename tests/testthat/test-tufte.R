context("tufte")

test_that("theme_tufte works", {
  thm <- theme_tufte()
  expect_is(thm, "theme")
})

test_that("theme_tufte works with ticks = FALSE", {
  thm <- theme_tufte(ticks = FALSE)
  expect_is(thm, "theme")
  expect_equal(thm$axis.ticks, element_blank())
})
