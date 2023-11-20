test_that("theme_map works", {
  thm <- theme_map()
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.background, element_blank())
})
