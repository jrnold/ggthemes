context("economist")

test_that("economist_pal fill=FALSE works", {
  p <- economist_pal(fill = FALSE)
  expect_is(p, "function")
  for (i in 1:9) {
    expect_hexcolor(p(i))
  }
})

test_that("economist_pal fill=TRUE works", {
  p <- economist_pal(fill = TRUE)
  expect_is(p, "function")
  for (i in 1:9) {
    expect_hexcolor(p(i))
  }
})

test_that("economist_pal raises warning with large number", {
  expect_warning(economist_pal()(10))
})

test_that("scale_colour_economist equals scale_color_economist", {
  expect_equal(scale_color_economist(), scale_colour_economist())
})

test_that("scale_colour_economist works", {
  expect_is(scale_color_economist(), "ScaleDiscrete")
})

test_that("scale_fill_economist works", {
  expect_is(scale_fill_economist(), "ScaleDiscrete")
})

test_that("theme economist works", {
  expect_is(theme_economist(), "theme")
})

test_that("theme economist with horizontal=FALSE works", {
  thm <- theme_economist(horizontal = FALSE)
  expect_is(thm, "theme")
  expect_equal(thm$panel.grid.major.y, element_blank())
})

test_that("theme economist with dark panel works", {
  thm <- theme_economist(dkpanel = TRUE)
  expect_is(thm, "theme")
  expect_equal(thm$strip.background$fill,
               purrr::pluck(dplyr::filter(ggthemes_data$economist$bg,
                                          name == "dark blue-gray"), "value"))
})

test_that("theme economist_white works", {
  thm <- theme_economist_white(gray_bg = FALSE)
  expect_is(thm, "theme")
  expect_equal(thm$panel.background$fill, "white")
  expect_equal(thm$plot.background$fill, "white")
})

test_that("theme economist_white with gray background works", {
  thm <- theme_economist_white(gray_bg = TRUE)
  expect_is(thm, "theme")
  expect_equal(thm$plot.background$fill,
               purrr::pluck(dplyr::filter(ggthemes_data$economist$bg,
                                          name == "light gray"), "value"))
})
