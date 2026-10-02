test_that("theme_solarized_works", {
  expect_s3_class(theme_solarized(), "theme")
  expect_s3_class(theme_solarized(light = FALSE), "theme")
})

test_that("theme_solarized_2_works", {
  expect_s3_class(theme_solarized_2(), "theme")
  expect_s3_class(theme_solarized_2(light = FALSE), "theme")
})

test_that("scale_colour_solarized works", {
  expect_s3_class(scale_colour_solarized(), "ScaleDiscrete")
})

test_that("scale_color_solarized works", {
  expect_equal_scale(scale_colour_solarized(), scale_color_solarized())
})

test_that("scale_fill_solarized works", {
  expect_s3_class(scale_fill_solarized(), "ScaleDiscrete")
})

test_that("solarized_pal works", {
  pal <- solarized_pal()
  expect_type(pal, "closure")
  n <- 5L
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("solarized_pal stores max_n as an integer", {
  pal <- solarized_pal()
  expect_equal(attr(pal, "max_n"), length(ggthemes::ggthemes_data$solarized$palettes$blue))
})

test_that("solarized_pal pads with NA beyond max_n", {
  pal <- solarized_pal()
  max_n <- attr(pal, "max_n")
  expect_warning(out <- pal(max_n + 1L), "maximum")
  expect_length(out, max_n + 1L)
  expect_equal(out[seq_len(max_n)], pal(max_n))
  expect_true(is.na(out[[max_n + 1L]]))
})

test_that("solarized_pal returns no colours for n = 0", {
  expect_equal(solarized_pal()(0), character())
})

test_that("theme_solarized draws correctly", {
  expect_doppelganger("theme_solarized", theme_test_plot() + theme_solarized())
})

test_that("theme_solarized_2 draws correctly", {
  expect_doppelganger("theme_solarized_2", theme_test_plot() + theme_solarized_2())
})
