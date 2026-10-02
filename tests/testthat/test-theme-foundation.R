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

test_that("theme_foundation elements inherit ink and paper rather than theme_grey colours", {
  # The checks above only see the root elements. Resolve the children too:
  # these kept theme_grey()'s grey fills and white lines when the colours
  # were not cleared (as happened with ggplot2 >= 4.0.0's S7 elements).
  thm <- theme_foundation(ink = "navy", paper = "ivory")
  for (el in c("panel.background", "strip.background", "legend.key", "plot.background")) {
    expect_equal(ggplot2::calc_element(el, thm)$fill, "ivory", label = el)
  }
  for (el in c("panel.grid.major.x", "axis.ticks.x.bottom", "plot.background")) {
    expect_equal(ggplot2::calc_element(el, thm)$colour, "navy", label = el)
  }
  expect_equal(ggplot2::calc_element("strip.text.x.top", thm)$colour, "navy")
})

test_that("theme_foundation draws correctly", {
  expect_doppelganger("theme_foundation", theme_test_plot() + theme_foundation())
})
