test_that("theme_igray works", {
  thm <- theme_igray()
  expect_s3_class(thm, "theme")
  expect_equal(thm$plot.background$fill, "gray90")
})
