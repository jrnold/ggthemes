test_that("economist_pal returns the current Economist chart colours", {
  expect_equal(
    economist_pal()(3),
    c("#006ba2", "#3ebcd2", "#379a8b")
  )
})

test_that("economist_pal supports up to 9 colours", {
  p <- economist_pal()
  expect_type(p, "closure")
  expect_equal(attr(p, "max_n"), 9L)
  for (i in 1:9) {
    expect_hexcolor(p(i))
  }
})

test_that("economist_pal puts red last, reserved for emphasis", {
  expect_equal(economist_pal()(9)[[9]], "#db444b")
})

test_that("economist_pal raises warning with large number", {
  expect_warning(economist_pal()(10))
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

test_that("theme economist with horizontal=FALSE works", {
  thm <- theme_economist(horizontal = FALSE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$panel.grid.major.y, element_blank())
})

test_that("theme_economist draws a white panel on a pale ground", {
  thm <- theme_economist()
  expect_equal(thm$panel.background$fill, "#ffffff")
  expect_equal(thm$plot.background$fill, "#e9edf0")
})

test_that("theme_economist draws horizontal gridlines only, by default", {
  thm <- theme_economist()
  expect_equal(thm$panel.grid.major.x, element_blank())
  expect_equal(thm$panel.grid.minor, element_blank())
  expect_equal(thm$panel.grid.major$colour, "#b7c6cf")
})

test_that("theme_economist points tick marks outward", {
  # The pre-2017 theme used a negative length to draw ticks inside the
  # panel; the current design puts them below the x-axis baseline.
  expect_gt(as.numeric(theme_economist()$axis.ticks.length), 0)
})

test_that("theme_economist leaves the y axis unruled and unticked", {
  thm <- theme_economist()
  expect_equal(thm$axis.line.y, element_blank())
  expect_equal(thm$axis.ticks.y, element_blank())
})

test_that("theme_economist uses the styleguide's text colours", {
  thm <- theme_economist()
  expect_equal(thm$text$colour, "#3f5661")
  expect_equal(thm$plot.title$colour, "#0c0c0c")
  expect_equal(thm$plot.title$face, "bold")
})

test_that("theme_economist draws legend keys with no box behind them", {
  # A filled key shows as a white square against the pale plot ground.
  expect_true(is.na(theme_economist()$legend.key$fill))
})

test_that("theme_economist gives horizontal colour bars room for labels", {
  # The bar length follows legend.key.width; too narrow and the bar's
  # own labels overprint each other.
  thm <- theme_economist()
  width <- grid::convertWidth(thm$legend.key.width, "points", valueOnly = TRUE)
  height <- grid::convertHeight(
    thm$legend.key.height,
    "points",
    valueOnly = TRUE
  )
  expect_gt(width, height)
})

test_that("theme_economist ranges the title against the whole plot", {
  expect_equal(theme_economist()$plot.title.position, "plot")
})

test_that("theme_economist left-aligns the source note", {
  expect_equal(theme_economist()$plot.caption$hjust, 0)
})

test_that("theme_economist_white is deprecated", {
  expect_snapshot(x <- theme_economist_white())
})

test_that("theme_economist_white still returns the current theme", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(theme_economist_white(), theme_economist())
})

test_that("theme_economist(dkpanel=) is deprecated", {
  expect_snapshot(x <- theme_economist(dkpanel = TRUE))
})

test_that("theme_economist(dkpanel=) no longer changes the theme", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(theme_economist(dkpanel = TRUE), theme_economist())
})

test_that("economist_pal(fill=) is deprecated", {
  expect_snapshot(x <- economist_pal(fill = TRUE))
})

test_that("economist_pal(fill=) no longer changes the palette", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(economist_pal(fill = FALSE)(9), economist_pal()(9))
})
