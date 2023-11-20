test_that("theme_tufte works", {
  thm <- theme_tufte()
  expect_s3_class(thm, "theme")
})

test_that("theme_tufte works with ticks = FALSE", {
  thm <- theme_tufte(ticks = FALSE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$axis.ticks, element_blank())
})
