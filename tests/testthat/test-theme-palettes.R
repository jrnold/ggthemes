# Each theme makes its own palettes the defaults for discrete scales, so a
# plot needs no matching scale_*() to draw in the theme's colours.

theme_palette_cases <- function() {
  list(
    calc = list(theme_calc(), calc_pal()),
    economist = list(theme_economist(), economist_pal()),
    economist_white = list(theme_economist_white(), economist_pal()),
    excel = list(theme_excel(), excel_pal(line = TRUE), excel_pal(line = FALSE)),
    excel_new = list(theme_excel_new(), excel_new_pal()),
    few = list(theme_few(), few_pal()),
    fivethirtyeight = list(theme_fivethirtyeight(), fivethirtyeight_pal()),
    gdocs = list(theme_gdocs(), gdocs_pal()),
    hc = list(theme_hc(), hc_pal()),
    hc_darkunica = list(theme_hc(style = "darkunica"), hc_pal("darkunica")),
    numbers = list(theme_numbers(), numbers_pal()),
    pander = list(theme_pander(), palette_pander),
    selenized_dark = list(theme_selenized(variant = "dark"), selenized_pal(variant = "dark")),
    solarized = list(theme_solarized(), solarized_pal()),
    solarized_2 = list(theme_solarized_2(), solarized_pal()),
    stata = list(theme_stata(scheme = "s2color"), stata_pal("s2color")),
    stata_mono = list(theme_stata(scheme = "s2mono"), stata_pal("mono")),
    stata_st = list(theme_stata(scheme = "stcolor_alt"), stata_pal("stcolor")),
    wsj = list(theme_wsj(), wsj_pal())
  )
}

test_that("themes draw discrete colour and fill with their own palettes", {
  d <- data.frame(x = 1:3, y = 1:3, g = c("a", "b", "c"))
  base <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g, fill = g)) + ggplot2::geom_point(shape = 21)
  for (nm in names(theme_palette_cases())) {
    case <- theme_palette_cases()[[nm]]
    fill_pal <- if (length(case) == 3) case[[3]] else case[[2]]
    drawn <- ggplot2::layer_data(base + case[[1]])
    expect_equal(drawn$colour, case[[2]](3), label = nm)
    expect_equal(drawn$fill, fill_pal(3), label = nm)
  }
})

test_that("an explicit scale overrides the theme palette", {
  d <- data.frame(x = 1:3, y = 1:3, g = c("a", "b", "c"))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    theme_economist() +
    scale_colour_tableau()
  expect_equal(ggplot2::layer_data(p)$colour, tableau_color_pal()(3))
})

test_that("themes with shape and linetype palettes use them", {
  d <- data.frame(x = 1:3, y = 1:3, g = c("a", "b", "c"))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, shape = g, linetype = g)) + ggplot2::geom_point()
  expect_equal(ggplot2::layer_data(p + theme_few())$shape, few_shape_pal()(3))
  expect_equal(ggplot2::layer_data(p + theme_calc())$shape, calc_shape_pal()(3))
  stata <- ggplot2::layer_data(p + theme_stata(scheme = "s2color"))
  expect_equal(stata$shape, stata_shape_pal()(3))
  expect_equal(stata$linetype, stata_linetype_pal()(3))
})

test_that("themes without a palette leave the ggplot2 default", {
  for (thm in list(theme_tufte(), theme_clean(), theme_igray(), theme_map(), theme_foundation())) {
    expect_null(thm$palette.colour.discrete)
  }
})

test_that("dark themes draw unmapped geoms in their foreground colour", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  ink <- function(thm) unique(ggplot2::layer_data(p + thm)$colour)
  dark <- solarized_rebase(FALSE)
  expect_equal(ink(theme_solarized(light = FALSE)), unname(dark["rebase0"]))
  expect_equal(ink(theme_solarized_2(light = FALSE)), unname(dark["rebase0"]))
  expect_equal(ink(theme_hc(style = "darkunica")), "#E0E0E3")
  expect_equal(ink(theme_hc(style = "default_dark")), "#d0d0d0")
  expect_equal(ink(theme_stata(scheme = "s1rcolor")), "white")
  expect_equal(ink(theme_hc()), "black")
})

test_that("a theme palette that runs out falls back to ggplot2's default with a warning", {
  d <- data.frame(x = 1:5, y = 1:5, g = letters[1:5])
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g, shape = g)) + ggplot2::geom_point() + theme_fivethirtyeight()
  expect_snapshot(drawn <- ggplot2::layer_data(p))
  expect_equal(drawn$colour, scales::pal_hue()(5))
})

test_that("a theme palette within its size draws without a warning", {
  d <- data.frame(x = 1:3, y = 1:3, g = letters[1:3])
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) + ggplot2::geom_point() + theme_fivethirtyeight()
  expect_no_warning(ggplot2::layer_data(p))
})
