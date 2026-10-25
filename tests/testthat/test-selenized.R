test_that("theme_selenized works for every variant", {
  for (variant in c("light", "dark", "black", "white")) {
    expect_s3_class(theme_selenized(variant = variant), "theme")
  }
})

test_that("theme_selenized uses the variant's background and foreground", {
  base <- tibble::deframe(ggthemes::ggthemes_data$selenized$dark$base)
  thm <- theme_selenized(variant = "dark")
  expect_equal(thm$plot.background$fill, base[["bg_0"]])
  expect_equal(thm$text$colour, base[["fg_0"]])
  expect_equal(thm$plot.title$colour, base[["fg_1"]])
  expect_equal(thm$panel.grid$colour, base[["bg_1"]])
})

test_that("theme_selenized sets geom colours for dark variants", {
  skip_if_not_installed("ggplot2", "4.0.0")
  base <- tibble::deframe(ggthemes::ggthemes_data$selenized$black$base)
  thm <- theme_selenized(variant = "black")
  expect_equal(thm$geom@ink, base[["fg_0"]])
  expect_equal(thm$geom@paper, base[["bg_0"]])
})

test_that("scale_colour_selenized works", {
  expect_s3_class(scale_colour_selenized(), "ScaleDiscrete")
})

test_that("scale_color_selenized works", {
  expect_equal_scale(scale_colour_selenized(), scale_color_selenized())
})

test_that("scale_fill_selenized works", {
  expect_s3_class(scale_fill_selenized(), "ScaleDiscrete")
})

test_that("selenized_pal starts with the accent", {
  pal <- selenized_pal("red", "dark")
  red <- tibble::deframe(ggthemes::ggthemes_data$selenized$dark$accents)[["red"]]
  expect_equal(pal(1), red)
  expect_length(pal(5), 5)
})

test_that("selenized_pal uses the variant's own accent colours", {
  for (variant in c("light", "dark", "black", "white")) {
    accents <- ggthemes::ggthemes_data$selenized[[variant]]$accents$value
    expect_setequal(selenized_pal(variant = variant)(8), accents)
  }
})

test_that("selenized_pal pads with NA beyond max_n", {
  pal <- selenized_pal()
  expect_equal(attr(pal, "max_n"), 8L)
  expect_warning(out <- pal(9L), "maximum")
  expect_equal(out[1:8], pal(8))
  expect_true(is.na(out[[9]]))
})

test_that("selenized_pal returns no colours for n = 0", {
  expect_equal(selenized_pal()(0), character())
})

test_that("selenized_pal() and theme_selenized() reject unknown values", {
  expect_snapshot(selenized_pal("chartreuse"), error = TRUE)
  expect_snapshot(selenized_pal(variant = "sepia"), error = TRUE)
  expect_snapshot(theme_selenized(variant = "sepia"), error = TRUE)
})

test_that("theme_selenized draws correctly", {
  expect_doppelganger("theme_selenized", theme_test_plot() + theme_selenized())
  expect_doppelganger(
    "theme_selenized_dark",
    theme_test_plot() + theme_selenized(variant = "dark") + scale_colour_selenized(variant = "dark")
  )
})
