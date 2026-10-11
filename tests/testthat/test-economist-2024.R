# theme_economist_2024() and its palettes are reverse-engineered from charts
# published since the March 2024 redesign. The expected values below are the
# corpus measurements, so a failure says which observation changed.

economist_2024_spec <- function(media) ggthemes::ggthemes_data$economist_2024[[media]]

resolved_size <- function(thm, element) ggplot2::calc_element(element, thm)$size

# Palettes ---------------------------------------------------------------------

test_that("economist_2024_pal returns the observed six-color orders", {
  expect_equal(
    economist_2024_pal("web")(6),
    c("#E3120B", "#FBA493", "#3A4DAC", "#7892C5", "#6A6654", "#BEBCAB")
  )
  expect_equal(
    economist_2024_pal("print")(6),
    c("#ED1C24", "#F8AB90", "#28479D", "#659BD2", "#636466", "#C6C8CA")
  )
  expect_equal(attr(economist_2024_pal(), "max_n"), 6)
})

test_that("economist_2024_pal gives single-series charts the brighter red", {
  expect_equal(economist_2024_pal("print")(1), "#F04F38")
  expect_equal(economist_2024_pal("web")(1), "#F6423C")
  # Two or more series lead with the emphasis red.
  expect_equal(economist_2024_pal("web")(2)[1], economist_2024_spec("web")$accent)
  # Reversing a single color still gives the single-series red.
  expect_equal(economist_2024_pal("web", direction = -1)(1), "#F6423C")
})

test_that("economist_2024_pal reverses and checks its arguments", {
  expect_equal(economist_2024_pal("web", direction = -1)(3), rev(economist_2024_pal("web")(3)))
  expect_snapshot(error = TRUE, economist_2024_pal(direction = 0))
  expect_snapshot(economist_2024_pal()(7))
})

test_that("economist_2024 gradient palettes run between their end stops", {
  for (media in c("print", "web")) {
    spec <- economist_2024_spec(media)
    red <- economist_2024_seq_gradient_pal("red", media)
    expect_equal(toupper(red(c(0, 1))), toupper(spec$sequential_red$value[c(1, nrow(spec$sequential_red))]))
    div <- economist_2024_div_gradient_pal(media)
    expect_equal(toupper(div(0.5)), toupper(spec$diverging$value[4]), info = media)
  }
  expect_equal(
    economist_2024_seq_gradient_pal("gray", "web", direction = -1)(0),
    economist_2024_spec("web")$sequential_gray$value[7]
  )
})

test_that("economist_2024_gradient_pal checks its arguments", {
  expect_snapshot(error = TRUE, economist_2024_gradient_pal("blue"))
  expect_snapshot(error = TRUE, economist_2024_seq_gradient_pal("red-gray"))
  expect_snapshot(error = TRUE, economist_2024_div_gradient_pal(direction = 2))
})

test_that("economist_2024 scales are ggplot2 scales", {
  expect_s3_class(scale_colour_economist_2024(), "ScaleDiscrete")
  expect_s3_class(scale_fill_economist_2024("web"), "ScaleDiscrete")
  expect_s3_class(scale_fill_gradient_economist_2024("gray"), "ScaleContinuous")
  expect_s3_class(scale_colour_gradient2_economist_2024(midpoint = 1), "ScaleContinuous")
  expect_identical(scale_color_economist_2024, scale_colour_economist_2024)
})

test_that("economist_2024 gradient scales honor direction and midpoint", {
  spec <- economist_2024_spec("web")
  red <- scale_fill_gradient_economist_2024("red", "web", direction = -1)
  red$train(c(0, 10))
  expect_equal(toupper(red$map(0)), toupper(spec$sequential_red$value[nrow(spec$sequential_red)]))
  div <- scale_colour_gradient2_economist_2024("web", midpoint = 8)
  div$train(c(0, 10))
  # The midpoint, not the middle of the range, takes the neutral color.
  expect_equal(toupper(div$map(8)), toupper(spec$diverging$value[4]))
  expect_false(toupper(div$map(5)) == toupper(spec$diverging$value[4]))
})

test_that("the print CMYK specs match the print palette they explain", {
  spec <- economist_2024_spec("print")
  pal <- spec$palette
  observed <- setNames(pal$observed, pal$name)
  expect_equal(unname(observed[spec$qualitative$name]), spec$qualitative$value)
  expect_equal(unname(observed[spec$bg$name]), spec$bg$value)
  expect_equal(observed[["single red"]], spec$single)
  expect_equal(observed[["text"]], spec$text)
  # Economist Red's print spec, from the brand guide.
  expect_equal(pal$cmyk[pal$name == "red"], "0/100/100/0")
  # Every spec renders close to its color, except where marked low.
  expect_true(all(pal$delta_e[pal$confidence != "low"] <= 1))
  expect_match(pal$cmyk, "^[0-9.]+(/[0-9.]+){3}$")
})

colourbar_plot <- function(base_size = 10, ...) {
  df <- expand.grid(x = 1:10, y = 1:10)
  df$z <- df$x * 60
  ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, fill = .data$z)) +
    ggplot2::geom_tile() +
    scale_fill_gradient_economist_2024("red", "web", ...) +
    theme_economist_2024("web", base_size = base_size, base_family = "sans")
}

# The bar's own cell in the guide's gtable, in points.
colourbar_size <- function(p) {
  withr::local_pdf(NULL)
  gt <- ggplot2::ggplotGrob(p)
  guide <- gt$grobs[[which(gt$layout$name == "guide-box-top")]]$grobs[[1]]
  bar <- guide$layout[guide$layout$name == "bar", ]
  c(
    width = grid::convertWidth(guide$widths[bar$l], "pt", valueOnly = TRUE),
    height = grid::convertHeight(guide$heights[bar$t], "pt", valueOnly = TRUE),
    label_row = guide$layout$t[startsWith(guide$layout$name, "label")],
    bar_row = bar$t
  )
}

test_that("guide_colourbar_economist_2024 sizes the bar from the label size", {
  # 13.8 by 0.67 times the labels, as on 20260801_WOM946, at any base size.
  for (base_size in c(10, 15)) {
    size <- colourbar_size(colourbar_plot(base_size))
    expect_equal(unname(size[c("width", "height")]), c(13.8, 0.67) * base_size, tolerance = 1e-6)
    # Labels above the bar.
    expect_lt(size[["label_row"]], size[["bar_row"]])
  }
  expect_identical(guide_colorbar_economist_2024, guide_colourbar_economist_2024)
  expect_s3_class(guide_colourbar_economist_2024(), "GuideColourbar")
})

test_that("guide_colourbar_economist_2024 lets its own theme win", {
  guide <- guide_colourbar_economist_2024(
    theme = ggplot2::theme(legend.key.width = grid::unit(100, "pt"), legend.text.position = "bottom")
  )
  size <- colourbar_size(colourbar_plot(guide = guide))
  # A width in the guide's own theme is the bar's length.
  expect_equal(size[["width"]], 100, tolerance = 1e-6)
  expect_gt(size[["label_row"]], size[["bar_row"]])
})

# Theme --------------------------------------------------------------------------

test_that("theme_economist_2024 sets the observed grounds and inks", {
  for (media in c("print", "web")) {
    spec <- economist_2024_spec(media)
    thm <- theme_economist_2024(media)
    expect_equal(thm$plot.background$fill, spec$bg$value[1], info = media)
    expect_equal(ggplot2::calc_element("text", thm)$colour, spec$text, info = media)
    expect_equal(ggplot2::calc_element("panel.grid.major.y", thm)$colour, spec$grid, info = media)
    expect_equal(ggplot2::calc_element("plot.caption", thm)$colour, spec$source, info = media)
  }
  expect_equal(theme_economist_2024("print")$plot.background$fill, "#ECEBE0")
  expect_equal(theme_economist_2024("web")$plot.background$fill, "#FFFFFF")
})

test_that("theme_economist_2024 follows the ai2html type scale", {
  # 20px title, 17px subtitle and panel heading, 15px axis labels and source.
  thm <- theme_economist_2024("web", base_size = 15)
  expect_equal(resolved_size(thm, "axis.text.x"), 15)
  expect_equal(resolved_size(thm, "plot.title"), 20)
  expect_equal(resolved_size(thm, "plot.subtitle"), 17)
  expect_equal(resolved_size(thm, "strip.text.x"), 17)
  expect_equal(resolved_size(thm, "plot.caption"), 15)
  expect_equal(ggplot2::calc_element("plot.title", thm)$face, "bold")
  expect_equal(ggplot2::calc_element("plot.subtitle", thm)$face, "plain")
  expect_equal(ggplot2::calc_element("plot.subtitle", theme_economist_2024("print"))$face, "bold")
})

test_that("theme_economist_2024 keeps keys flush left in both media", {
  for (media in c("print", "web")) {
    thm <- theme_economist_2024(media)
    expect_equal(thm$legend.position, "top", info = media)
    expect_equal(thm$legend.justification, "left", info = media)
  }
})

test_that("theme_economist_2024 rules vertical grid lines for horizontal bars", {
  thm <- theme_economist_2024(horizontal = FALSE)
  expect_s3_class(ggplot2::calc_element("panel.grid.major.y", thm), "element_blank")
  expect_s3_class(ggplot2::calc_element("panel.grid.major.x", thm), "element_line")
})

# Chart furniture ---------------------------------------------------------------

test_that("economist_2024_chart draws a tab, panel rules and an outlined number box", {
  p <- theme_test_plot() + theme_economist_2024("print", base_family = "sans")
  chart <- economist_2024_chart(p, "print", number = 2)
  gt <- grid::makeContent(chart)$children[[1]]
  names <- gt$layout$name
  expect_contains(names, c("economist-tab", "economist-number"))
  expect_false("economist-rule" %in% names)
  expect_true(any(startsWith(names, "economist-marker-")))
  tab <- gt$grobs[[which(names == "economist-tab")]]
  expect_equal(tab$gp$fill, economist_2024_spec("print")$accent)
  # 3.4 by 0.45 times the base size of 10.
  expect_equal(as.numeric(c(tab$width, tab$height)), c(34, 4.5))
  marker <- gt$grobs[[which(startsWith(names, "economist-marker-"))[1]]]
  expect_equal(marker$gp$fill, economist_2024_spec("print")$text)
  box <- gt$grobs[[which(names == "economist-number")]]$children[[1]]
  expect_true(is.na(box$gp$fill))
})

test_that("economist_2024_chart keeps a web key in place, with no red rule", {
  p <- theme_test_plot() + ggplot2::labs(title = "Title") + theme_economist_2024("web", base_family = "sans")
  gt <- grid::makeContent(economist_2024_chart(p, "web"))$children[[1]]
  layout <- gt$layout
  expect_false("economist-rule" %in% layout$name)
  # theme_economist_2017()'s web chart raises the key into the title's row.
  expect_gt(layout$t[layout$name == "guide-box-top"], layout$t[layout$name == "title"])
  tab <- gt$grobs[[which(layout$name == "economist-tab")]]
  expect_equal(as.numeric(c(tab$width, tab$height)), c(26.7, 2.7))
})

test_that("economist_2024_chart checks its arguments", {
  expect_snapshot(error = TRUE, economist_2024_chart(theme_test_plot(), tab = 1))
  expect_snapshot(error = TRUE, economist_2024_chart("plot"))
})

# Visual regression --------------------------------------------------------------

test_that("theme_economist_2024 draws correctly", {
  for (media in c("print", "web")) {
    p <- theme_test_plot() +
      ggplot2::scale_y_continuous(position = "right") +
      scale_colour_economist_2024(media) +
      # Pinned, so the snapshot does not depend on which fonts are installed.
      theme_economist_2024(media, base_family = "sans")
    expect_doppelganger(paste0("theme_economist_2024-", media), p)
    expect_doppelganger(
      paste0("economist_2024_chart-", media),
      economist_2024_chart(p, media, number = 1)
    )
  }
})

test_that("guide_colourbar_economist_2024 draws correctly", {
  p <- colourbar_plot() + ggplot2::labs(title = "Title", fill = NULL)
  expect_doppelganger("guide_colourbar_economist_2024", p)
})

test_that("economist_2024 palettes draw correctly", {
  expect_doppelganger(
    "economist_2024_pal",
    swatch_plot(
      list(print = economist_2024_pal("print")(6), web = economist_2024_pal("web")(6)),
      "economist_2024_pal()"
    )
  )
})
