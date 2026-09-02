test_that("theme_foundation runs", {
  expect_s3_class(theme_foundation(), "theme")
})

test_that("theme_foundation defaults to black ink and white paper", {
  thm <- theme_foundation()
  expect_equal(thm$text$colour, "black")
  expect_equal(thm$line$colour, "black")
  expect_equal(thm$rect$colour, "black")
  expect_equal(thm$rect$fill, "white")
})

test_that("theme_foundation respects ink and paper arguments", {
  thm <- theme_foundation(ink = "red", paper = "blue")
  expect_equal(thm$text$colour, "red")
  expect_equal(thm$line$colour, "red")
  expect_equal(thm$rect$colour, "red")
  expect_equal(thm$rect$fill, "blue")
})

test_that("theme_foundation draws correctly", {
  expect_doppelganger("theme_foundation", theme_test_plot() + theme_foundation())
})
