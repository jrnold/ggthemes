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

test_that("ggthemes_data$economist$bg keeps its first five rows in place", {
  # Code that reads the table by position, as `bg$value[3]` for the red, keeps
  # working; new colors go after these rows.
  bg <- ggthemes_data$economist$bg
  expect_equal(bg$name[1:5], c("blue-gray", "dark blue-gray", "red", "light gray", "dark gray"))
  expect_equal(bg$value[1:5], c("#d5e4eb", "#c3d6df", "#ed111a", "#ebebeb", "#c9c9c9"))
  expect_equal(bg$name[6:7], c("deep blue-gray", "pale blue-gray"))
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

# The classic charts of 2012 to 2018, measured in the chart corpus: one-column
# charts, 160pt wide, in a base size of 6.5pt.
test_that("theme_economist sets the title block flush left with the chart", {
  thm <- theme_economist()
  expect_equal(thm$plot.title.position, "plot")
  expect_equal(thm$plot.caption.position, "plot")
  for (element in c("plot.title", "plot.subtitle", "plot.caption")) {
    expect_equal(thm[[element]]$hjust, 0, info = element)
  }
  expect_equal(thm$legend.justification, "left")
  expect_equal(thm$legend.location, "plot")
})

test_that("theme_economist sizes the title block in base sizes, as the corpus measures", {
  thm <- theme_economist()
  # Title 9.5pt, subtitle 7.6pt and source 6.3pt, at a base size of 6.5pt.
  expect_equal(as.numeric(thm$plot.title$size), 1.45)
  expect_equal(as.numeric(thm$plot.subtitle$size), 1.15)
  expect_equal(as.numeric(thm$plot.caption$size), 0.95)
  expect_equal(as.numeric(thm$legend.text$size), 1)
  # The title is 1.29 times the subtitle in the corpus.
  expect_equal(as.numeric(thm$plot.title$size) / as.numeric(thm$plot.subtitle$size), 1.26, tolerance = 0.05)
})

test_that("theme_economist draws gridlines of the corpus's weight", {
  # 0.53pt on a chart 160pt wide: 0.08 base sizes. ggplot2 draws `linewidth`
  # millimetres as `linewidth * .pt` lwd, and a lwd is 0.75pt.
  drawn <- function(base_size) {
    theme_economist(base_size = base_size)$panel.grid.major$linewidth * ggplot2::.pt * 0.75
  }
  expect_equal(drawn(6.5), 0.52, tolerance = 0.02)
  expect_equal(drawn(13), 2 * drawn(6.5))
})

test_that("theme_economist scales margins, gridlines and legend keys with base_size", {
  # They did not before: the margins were fixed at 12pt and 10pt, the gridlines
  # at 1.9pt and the legend keys sized in "lines".
  pts <- function(x) grid::convertUnit(x, "pt", valueOnly = TRUE)
  small <- theme_economist(base_size = 5)
  big <- theme_economist(base_size = 20)
  expect_equal(pts(big$plot.margin), 4 * pts(small$plot.margin))
  expect_equal(big$panel.grid.major$linewidth, 4 * small$panel.grid.major$linewidth)
  expect_equal(pts(big$legend.key.width), 4 * pts(small$legend.key.width))
  expect_equal(pts(big$legend.key.height), 4 * pts(small$legend.key.height))
})

test_that("theme_economist's side margins are 1.9 base sizes, 12.2pt at the corpus's 6.5pt", {
  margin <- grid::convertUnit(theme_economist(base_size = 6.5)$plot.margin, "pt", valueOnly = TRUE)
  expect_equal(margin[c(2, 4)], rep(12.35, 2), tolerance = 0.02)
})

test_that("theme_economist has the 2017 guide's tick sizes, pointing into the panel", {
  # The guide's ticks are 0.4pt wide and 5pt long beside 7pt axis labels.
  pts <- function(x) grid::convertUnit(x, "pt", valueOnly = TRUE)
  thm <- theme_economist(base_size = 7)
  expect_equal(pts(thm$axis.ticks.length), -5)
  expect_equal(thm$axis.ticks$linewidth * ggplot2::.pt * 0.75, 0.4)
  expect_equal(as.numeric(thm$axis.minor.ticks.length), 0.6)
  # Scaled with base_size, and drawn into the panel (negative), as the classic charts do.
  big <- theme_economist(base_size = 14)
  expect_equal(pts(big$axis.ticks.length), -10)
  expect_equal(big$axis.ticks$linewidth, 2 * thm$axis.ticks$linewidth)
  expect_s3_class(thm$axis.ticks.y, "element_blank")
})

test_that("theme_economist has the 2017 guide's margins for axis titles", {
  # 0.5pt between an x axis and its title, 3pt between a y axis and its title,
  # beside 7pt axis labels; margin() is top, right, bottom, left.
  pts <- function(x) grid::convertUnit(x, "pt", valueOnly = TRUE)
  thm <- theme_economist(base_size = 7)
  expect_equal(pts(thm$axis.title.x$margin)[1], 0.5)
  expect_equal(pts(thm$axis.title.x.top$margin)[3], 0.5)
  expect_equal(pts(thm$axis.title.y$margin)[2], 3)
  expect_equal(pts(thm$axis.title.y.right$margin)[4], 3)
  # The titles are still rotated along their axes.
  expect_equal(thm$axis.title.y$angle, 90)
  expect_equal(thm$axis.title.y.right$angle, -90)
  expect_equal(pts(theme_economist(base_size = 14)$axis.title.y$margin)[2], 6)
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

brightness <- function(color) sum(grDevices::col2rgb(color) * c(0.2126, 0.7152, 0.0722))

test_that("dkpanel draws the panel darker than the ground", {
  thm <- theme_economist(dkpanel = TRUE)
  expect_lt(brightness(thm$panel.background$fill), brightness(thm$plot.background$fill))
})

test_that("theme_economist(lightpanel = TRUE) draws pale panels on a deep ground", {
  thm <- theme_economist(lightpanel = TRUE)
  expect_s3_class(thm, "theme")
  expect_equal(thm$plot.background$fill, economist_bg("deep blue-gray"))
  expect_equal(thm$panel.background$fill, economist_bg("pale blue-gray"))
  # The panel headings and the legend keys sit on the ground, not on the panels.
  expect_equal(thm$strip.background$fill, economist_bg("deep blue-gray"))
  expect_equal(thm$legend.key$fill, economist_bg("deep blue-gray"))
  expect_gt(brightness(thm$panel.background$fill), brightness(thm$plot.background$fill))
})

test_that("lightpanel keeps the rest of the classic theme", {
  plain <- theme_economist()
  light <- theme_economist(lightpanel = TRUE)
  for (element in c("panel.grid.major", "axis.line", "axis.ticks.length", "plot.margin", "plot.title")) {
    expect_equal(light[[element]], plain[[element]], info = element)
  }
})

test_that("dkpanel and lightpanel cannot both be set", {
  expect_error(theme_economist(dkpanel = TRUE, lightpanel = TRUE), "cannot both")
  expect_no_error(theme_economist(dkpanel = TRUE, lightpanel = FALSE))
  expect_no_error(theme_economist(dkpanel = FALSE, lightpanel = TRUE))
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
  expect_no_warning(theme_economist(lightpanel = TRUE))
  expect_no_warning(economist_pal(fill = FALSE))
})

test_that("theme_economist draws correctly", {
  expect_doppelganger("theme_economist", theme_test_plot() + theme_economist())
})

test_that("theme_economist(dkpanel = TRUE) draws correctly", {
  expect_doppelganger("theme_economist-dkpanel", theme_test_plot() + theme_economist(dkpanel = TRUE))
})

test_that("theme_economist(lightpanel = TRUE) draws correctly", {
  expect_doppelganger("theme_economist-lightpanel", theme_test_plot() + theme_economist(lightpanel = TRUE))
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
