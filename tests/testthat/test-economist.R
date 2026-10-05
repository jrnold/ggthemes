# theme_economist(), theme_economist_white() and economist_pal() draw the
# classic, pre-2017 Economist style, as they did before 7.0.0. 7.0.0 briefly
# replaced it with the 2017 design; these tests pin the classic behaviour so
# that code written for it keeps drawing the same thing.

economist_bg <- function(name) {
  bg <- ggthemes::ggthemes_data$economist$bg
  bg$value[bg$name == name]
}

test_that("economist_pal fill=TRUE works", {
  p <- economist_pal(fill = TRUE)
  expect_type(p, "closure")
  for (i in 1:9) {
    expect_hexcolor(p(i))
    expect_length(p(i), i)
  }
})

test_that("economist_pal fill=FALSE works", {
  p <- economist_pal(fill = FALSE)
  expect_type(p, "closure")
  for (i in 1:9) {
    expect_hexcolor(p(i))
    expect_length(p(i), i)
  }
})

test_that("economist_pal returns the classic colours", {
  # The pre-7.0.0 orders: blues, grays and greens, red held back for emphasis.
  expect_equal(economist_pal()(1), "#014d64")
  expect_equal(economist_pal()(3), c("#6794a7", "#014d64", "#01a2d9"))
  expect_equal(
    economist_pal()(9),
    c("#6794a7", "#014d64", "#01a2d9", "#7ad2f6", "#00887d", "#76c0c1", "#7c260b", "#ee8f71", "#adadad")
  )
  expect_equal(economist_pal(fill = FALSE)(3), c("#014d64", "#01a2d9", "#7ad2f6"))
})

test_that("economist_pal fill= changes the palette", {
  expect_false(identical(economist_pal(fill = TRUE)(6), economist_pal(fill = FALSE)(6)))
})

test_that("economist_pal returns no colours for n = 0", {
  # Before 7.0.0, the fill palette failed with "object 'i' not found".
  expect_equal(economist_pal(fill = TRUE)(0), character(0))
  expect_equal(economist_pal(fill = FALSE)(0), character(0))
})

test_that("economist_pal raises warning with large number", {
  expect_warning(economist_pal()(10), "maximum of 9")
})

test_that("ggthemes_data$economist keeps the classic fg and bg tables", {
  expect_named(ggthemes_data$economist, c("bg", "fg", "scales"), ignore.order = TRUE)
  expect_equal(nrow(ggthemes_data$economist$fg), 12)
  expect_equal(economist_bg("blue-gray"), "#d5e4eb")
})

test_that("scale_colour_economist equals scale_color_economist", {
  expect_equal_scale(scale_color_economist(), scale_colour_economist())
})

test_that("scale_colour_economist works", {
  expect_s3_class(scale_color_economist(), "ScaleDiscrete")
})

test_that("scale_fill_economist works", {
  expect_s3_class(scale_fill_economist(), "ScaleDiscrete")
})

test_that("economist_seq_pal returns one hue's six steps, darkest first", {
  expect_equal(
    economist_seq_pal("blue")(6),
    c("#00588d", "#1270a8", "#3d89c3", "#5da4df", "#7bbffc", "#98daff")
  )
})

test_that("economist_seq_pal defaults to blue", {
  expect_equal(economist_seq_pal()(6), economist_seq_pal("blue")(6))
})

test_that("economist_seq_pal rejects a hue that is not in the palette", {
  expect_error(economist_seq_pal("chartreuse"), "chartreuse")
})

test_that("economist_seq_pal warns beyond six steps", {
  expect_warning(economist_seq_pal("blue")(7))
})

test_that("economist_gradient_pal interpolates across a hue", {
  pal <- economist_gradient_pal("blue")
  expect_equal(pal(0), "#00588D")
  expect_equal(pal(1), "#98DAFF")
})

test_that("scale_colour_economist_c is continuous", {
  expect_s3_class(scale_colour_economist_c(), "ScaleContinuous")
})

test_that("scale_fill_economist_c is continuous", {
  expect_s3_class(scale_fill_economist_c(), "ScaleContinuous")
})

test_that("scale_colour_economist_c equals scale_color_economist_c", {
  expect_equal_scale(scale_color_economist_c(), scale_colour_economist_c())
})

test_that("scale_colour_economist_ordinal is discrete", {
  expect_s3_class(scale_colour_economist_ordinal(), "ScaleDiscrete")
})

test_that("scale_fill_economist_ordinal is discrete", {
  expect_s3_class(scale_fill_economist_ordinal(), "ScaleDiscrete")
})


test_that("theme economist works", {
  expect_s3_class(theme_economist(), "theme")
})

test_that("theme_economist respects base_family and base_size", {
  thm <- theme_economist(base_family = "mono", base_size = 20)
  expect_equal(thm$text$family, "mono")
  expect_equal(thm$text$size, 20)
})

test_that("theme_economist draws the classic blue-gray ground", {
  thm <- theme_economist()
  expect_equal(thm$plot.background$fill, economist_bg("blue-gray"))
  # White gridlines on the ground, ticks drawn into the panel.
  expect_equal(thm$panel.grid.major$colour, "white")
  expect_lt(grid::convertUnit(thm$axis.ticks.length, "pt", valueOnly = TRUE), 0)
})

test_that("theme_economist fills the panel and strips", {
  # Before 7.0.0 these asked for an undefined "ebg" color and got NA.
  thm <- theme_economist()
  expect_equal(thm$rect$fill, economist_bg("blue-gray"))
  expect_equal(thm$strip.background$fill, economist_bg("blue-gray"))
})

test_that("theme_economist separates the subtitle from the title", {
  thm <- theme_economist(base_size = 10)
  expect_equal(grid::convertUnit(thm$plot.title$margin, "pt", valueOnly = TRUE)[3], 5)
})

test_that("theme economist with horizontal=FALSE works", {
  thm <- theme_economist(horizontal = FALSE)
  expect_s3_class(thm, "theme")
  expect_s3_class(thm$panel.grid.major.y, "element_blank")
})

test_that("theme economist with dark panel works", {
  thm <- theme_economist(dkpanel = TRUE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.background$fill, economist_bg("dark blue-gray"))
  expect_equal(thm$strip.background$fill, economist_bg("dark blue-gray"))
})

test_that("theme_economist_white respects base_family and base_size", {
  thm <- theme_economist_white(base_family = "mono", base_size = 20)
  expect_equal(thm$text$family, "mono")
  expect_equal(thm$text$size, 20)
})

test_that("theme economist_white works", {
  thm <- theme_economist_white(gray_bg = FALSE)
  expect_equal(thm$panel.background$fill, "white")
  expect_equal(thm$plot.background$fill, "white")
})

test_that("theme economist_white with gray background works", {
  thm <- theme_economist_white(gray_bg = TRUE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$plot.background$fill, economist_bg("light gray"))
  expect_equal(thm$panel.grid.major$colour, economist_bg("dark gray"))
})

test_that("classic economist themes do not warn", {
  # 7.0.0 deprecated theme_economist_white(), dkpanel and fill=.
  expect_no_warning(theme_economist_white())
  expect_no_warning(theme_economist(dkpanel = TRUE))
  expect_no_warning(economist_pal(fill = FALSE))
})

test_that("theme_economist draws correctly", {
  expect_doppelganger("theme_economist", theme_test_plot() + theme_economist())
})

test_that("theme_economist(dkpanel = TRUE) draws correctly", {
  expect_doppelganger("theme_economist-dkpanel", theme_test_plot() + theme_economist(dkpanel = TRUE))
})

test_that("theme_economist_white draws correctly", {
  expect_doppelganger("theme_economist_white", theme_test_plot() + theme_economist_white())
})

test_that("theme_economist_white(gray_bg = FALSE) draws correctly", {
  expect_doppelganger(
    "theme_economist_white-white",
    theme_test_plot() + theme_economist_white(gray_bg = FALSE)
  )
})

test_that("current Economist design-system tokens are complete", {
  tokens <- ggthemes_data$economist_design_system

  expect_equal(
    nrow(tokens$sources$economist_design_system$tokens),
    38
  )
  expect_equal(nrow(tokens$sources$marber$tokens), 61)
  expect_named(
    tokens$ramps,
    c(
      "economist_red",
      "chicago",
      "hong_kong",
      "tokyo",
      "singapore",
      "new_york",
      "london",
      "los_angeles",
      "paris"
    )
  )
})

test_that("current Economist source tokens use HSL canonically", {
  sources <- ggthemes_data$economist_design_system$sources

  for (source in sources) {
    tokens <- source$tokens
    expect_type(tokens$hue, "double")
    expect_type(tokens$saturation, "double")
    expect_type(tokens$lightness, "double")
    expect_equal(tokens$value, tokens$documented_hex)
  }
})

test_that("current Economist colour ramps use five-point lightness steps", {
  ramps <- ggthemes_data$economist_design_system$ramps
  expected_levels <- seq(5, 100, by = 5)

  for (nm in names(ramps)) {
    expect_equal(ramps[[nm]]$level, expected_levels, info = nm)
    expect_equal(ramps[[nm]]$lightness, expected_levels, info = nm)
    expect_match(ramps[[nm]]$value, "^#[0-9A-F]{6}$", all = TRUE, info = nm)
  }
})

test_that("generated Economist ramps reproduce documented anchor colours", {
  data <- ggthemes_data$economist_design_system
  documented <- data$sources$marber$tokens
  generated <- do.call(rbind, unname(data$ramps))

  documented$level <- suppressWarnings(
    as.integer(sub("^.* ([0-9]+)$", "\\1", documented$name))
  )
  documented <- documented[
    documented$product == "The Economist" &
      documented$group %in% c("Brand", "Base", "Greyscale", "Canvas") &
      documented$family %in% unique(generated$family) &
      documented$level %% 5 == 0,
  ]
  merged <- merge(
    documented,
    generated,
    by = c("family", "group", "level"),
    suffixes = c("_documented", "_generated")
  )

  expect_gt(nrow(merged), 30)
  expect_equal(merged$documented_hex, merged$value_generated)
})
