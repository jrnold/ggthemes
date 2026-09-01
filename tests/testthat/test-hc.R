test_that("hc_pal works", {
  pal <- hc_pal()
  expect_type(pal, "closure")
  n <- 5
  values <- pal(n)
  expect_type(values, "character")
  expect_equal(length(values), n)
})

test_that("hc_pal raises error with invalid palette", {
  expect_error(hc_pal(palette = "asdgasdgasdgas"), regexp = "must be one of")
  # A numeric `palette` must not be treated as a positional index.
  expect_error(hc_pal(palette = 1), regexp = "must be one of")
})

test_that("hc_pal works for every palette in ggthemes_data", {
  for (nm in names(ggthemes_data$hc)) {
    values <- hc_pal(nm)(4)
    expect_length(values, 4)
    expect_false(anyNA(values), info = nm)
  }
})

test_that("hc_pal sets the max_n attribute", {
  expect_equal(attr(hc_pal("default"), "max_n"), 10)
  expect_equal(attr(hc_pal("darkunica"), "max_n"), 11)
  expect_equal(attr(hc_pal("avocado"), "max_n"), 4)
})

test_that("hc_pal warns when n exceeds the palette size", {
  # `avocado` and `sunset` have only four colours upstream, so they are the
  # palettes most likely to be overrun.
  expect_warning(hc_pal("avocado")(5), regexp = "maximum of 4 values")
  expect_warning(hc_pal("sunset")(5), regexp = "maximum of 4 values")
  expect_no_warning(hc_pal("avocado")(4))
})

test_that("hc_pal default is the Highcharts >= 11 palette", {
  expect_equal(
    hc_pal("default")(10),
    c(
      "#2caffe",
      "#544fc5",
      "#00e272",
      "#fe6a35",
      "#6b8abc",
      "#d568fb",
      "#2ee0ca",
      "#fa4b42",
      "#feb56a",
      "#91e8e1"
    )
  )
})

test_that("hc_pal default_dark differs from default only in positions 2 and 3", {
  light <- hc_pal("default")(10)
  dark <- hc_pal("default_dark")(10)
  expect_equal(which(light != dark), c(2L, 3L))
  expect_equal(dark[2:3], c("#00e272", "#efdf00"))
})

test_that("hc_pal classic is the Highcharts 5-10 palette", {
  expect_equal(
    hc_pal("classic")(10),
    c(
      "#7cb5ec",
      "#434348",
      "#90ed7d",
      "#f7a35c",
      "#8085e9",
      "#f15c80",
      "#e4d354",
      "#2b908f",
      "#f45b5b",
      "#91e8e1"
    )
  )
})

test_that("scale_colour_hc works", {
  expect_s3_class(scale_colour_hc(), "ScaleDiscrete")
})

test_that("scale_colour_hc accepts the newer Highcharts palettes", {
  expect_s3_class(scale_colour_hc("high_contrast_light"), "ScaleDiscrete")
  expect_s3_class(scale_fill_hc("sunset"), "ScaleDiscrete")
})

test_that("scale_color_hc works", {
  expect_equal_scale(scale_colour_hc(), scale_color_hc())
})

test_that("scale_fill_hc works", {
  expect_s3_class(scale_fill_hc(), "ScaleDiscrete")
})

test_that("theme_hc works", {
  expect_s3_class(theme_hc(), "theme")
  expect_s3_class(theme_hc(style = "darkunica"), "theme")
})

test_that("theme_hc works for every style", {
  for (style in names(ggthemes:::hc_theme_styles)) {
    expect_s3_class(theme_hc(style = style), "theme")
  }
})

test_that("theme_hc rejects palette-only Highcharts themes", {
  # `high_contrast_*`, `avocado` and `sunset` are `hc_pal()` palettes but not
  # `theme_hc()` styles, because upstream they restyle nothing but the colours.
  expect_error(theme_hc(style = "high_contrast_light"))
  expect_error(theme_hc(style = "avocado"))
})

test_that("theme_hc styles set the documented background and grid colours", {
  bg <- function(style) theme_hc(style = style)$rect$fill
  grid <- function(style) theme_hc(style = style)$panel.grid.major.y$colour
  expect_equal(bg("default"), "#FFFFFF")
  expect_equal(bg("darkunica"), "#2a2a2b")
  expect_equal(bg("default_dark"), "#141414")
  expect_equal(bg("sand_signika"), "#F7F7F7")
  expect_equal(grid("default"), "#e6e6e6")
  expect_equal(grid("darkunica"), "#707073")
  expect_equal(grid("default_dark"), "#2c2c2c")
})

test_that("only grid_light draws vertical grid lines", {
  for (style in names(ggthemes:::hc_theme_styles)) {
    x_grid <- theme_hc(style = style)$panel.grid.major.x
    if (style == "grid_light") {
      expect_s3_class(x_grid, "element_line")
      expect_equal(x_grid$colour, "#e6e6e6")
    } else {
      expect_s3_class(x_grid, "element_blank")
    }
  }
})

test_that("dark theme_hc styles override theme_grey's grey30 axis text", {
  # `theme_hc()` is a partial theme, so an unset `axis.text` falls back to
  # `theme_grey()`'s "grey30", which is unreadable on a dark background.
  for (style in c("darkunica", "default_dark")) {
    expect_equal(
      theme_hc(style = style)$axis.text$colour,
      hc_theme_styles[[style]]$text
    )
  }
})

test_that("theme_hc keeps title justification when a style sets title colour", {
  # `theme() + theme()` should copy only the non-NULL element properties.
  dark <- theme_hc(style = "darkunica")
  expect_equal(dark$title$hjust, 0.5)
  expect_equal(dark$title$colour, "#E0E0E3")
  expect_equal(dark$text$size, 12)
  expect_equal(dark$text$colour, "#E0E0E3")
})

test_that("bgcolor raises warning", {
  expect_warning(theme_hc(bgcolor = "darkunica"), regexp = "deprecated")
})
