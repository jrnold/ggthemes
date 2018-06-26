context("theme_map")

test_that("theme_map works", {
  thm <- theme_map()
  expect_is(thm, "theme")
  expect_equal(thm$panel.background, element_blank())
})
