context("igray")

test_that("theme_igray works", {
  thm <- theme_igray()
  expect_is(thm, "theme")
  expect_eqNe(thm$plot.background$fill, "gray90")
})
