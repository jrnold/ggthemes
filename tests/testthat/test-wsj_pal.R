test_that("theme_wsj works", {
  expect_s3_class(theme_wsj(), "theme")
})

test_that("wsj_pal works", {
  p <- wsj_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  expect_hexcolor(p(3))
  # Measured on the 2010-2014 corpus, in the order of charts with three or more
  # lines: red, steel, green, black, gold, orange.
  expect_equal(p(6), c("#c72e29", "#5d8ca8", "#65a479", "#000000", "#be9c2e", "#fb832d"))
})

test_that("wsj palettes use semantic roles", {
  # A highlight is a darker shade of the same hue, not a color against gray.
  expect_equal(wsj_pal("comparison")(2), c("#016392", "#5d8ca8"))
  expect_equal(wsj_pal("direction")(2), c("#65a479", "#c72e29"))
  expect_equal(wsj_pal("actual_forecast")(2), c("#5d8ca8", "#abbdcb"))
})

test_that("theme_wsj() sets the field and rejects an unknown one", {
  expect_s3_class(theme_wsj(), "theme")
  expect_equal(theme_wsj(paper = "gray")$plot.background$fill, "#efefef")
  # "brown" is the pre-8.0.0 name for "ivory": deprecated, not an error.
  expect_error(theme_wsj(paper = "chartreuse"), regexp = "must be one of")
})

test_that("wsj_pal() rejects an unknown palette", {
  expect_snapshot(wsj_pal("asdgasa"), error = TRUE)
})

test_that("theme_wsj() rejects an unknown paper", {
  expect_snapshot(theme_wsj(paper = "purple"), error = TRUE)
})

test_that("scale_colour_wsj works", {
  expect_s3_class(scale_colour_wsj(), "ScaleDiscrete")
})

test_that("scale_fill_wsj works", {
  expect_s3_class(scale_fill_wsj(), "ScaleDiscrete")
})

test_that("continuous WSJ scales work", {
  expect_s3_class(scale_colour_gradient_wsj(), "ScaleContinuous")
  expect_s3_class(scale_fill_gradient_wsj(), "ScaleContinuous")
  expect_s3_class(scale_colour_gradient2_wsj(), "ScaleContinuous")
  expect_s3_class(scale_fill_gradient2_wsj(), "ScaleContinuous")
})

test_that("theme_wsj draws correctly", {
  expect_doppelganger("theme_wsj", theme_test_plot() + theme_wsj())
})

test_that("pre-8.0.0 palette names still resolve to their original colors", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(wsj_pal("rgby")(4), c("#d3ba68", "#d5695d", "#5d8ca8", "#65a479"))
  expect_equal(wsj_pal("red_green")(2), c("#088158", "#ba2f2a"))
  expect_equal(
    wsj_pal("black_green")(4),
    c("#000000", "#595959", "#59a77f", "#008856")
  )
  expect_equal(wsj_pal("dem_rep")(3), c("#006a8e", "#b1283a", "#a8a6a7"))
  expect_equal(
    wsj_pal("colors6")(6),
    c("#c72e29", "#016392", "#be9c2e", "#098154", "#fb832d", "#000000")
  )
})

test_that("pre-8.0.0 palette names are deprecated", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot({
    x <- wsj_pal("rgby")(2)
    x <- wsj_pal("red_green")(2)
    x <- wsj_pal("black_green")(2)
    x <- wsj_pal("dem_rep")(2)
    x <- wsj_pal("colors6")(2)
  })
})

test_that("current palettes are not deprecated", {
  withr::local_options(lifecycle_verbosity = "warning")
  for (pal in wsj_current_palettes()) {
    expect_no_warning(wsj_pal(pal)(2))
  }
})

test_that("wsj_pal() error lists only current palettes", {
  expect_error(wsj_pal("nope"), regexp = "comparison")
  expect_error(wsj_pal("nope"), regexp = "^(?!.*colors6).*$", perl = TRUE)
})

test_that("theme_wsj(color=) is deprecated but still works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(theme_wsj(color = "brown")$plot.background$fill, "#f8f2e4")
  expect_equal(theme_wsj(color = "gray")$plot.background$fill, "#efefef")
  expect_equal(theme_wsj(color = "green")$plot.background$fill, "#e9f3ea")
  expect_equal(theme_wsj(color = "blue")$plot.background$fill, "#d4dee7")
})

test_that("theme_wsj(color=) warns once, not twice", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot(thm <- theme_wsj(color = "brown"))
})

test_that("pre-8.0.0 field names still work positionally", {
  withr::local_options(lifecycle_verbosity = "quiet")
  # theme_wsj(12, "brown") was a valid call before `color` was renamed.
  expect_equal(theme_wsj(12, "brown")$plot.background$fill, "#f8f2e4")
  expect_equal(theme_wsj(12, "blue")$plot.background$fill, "#d4dee7")
})

test_that("current paper values do not warn", {
  withr::local_options(lifecycle_verbosity = "warning")
  for (pp in c("ivory", "gray")) {
    expect_no_warning(theme_wsj(paper = pp))
  }
  expect_no_warning(theme_wsj())
})

test_that("theme_wsj draws x ticks but not y ticks", {
  thm <- theme_wsj()
  expect_s3_class(thm$axis.ticks.x, "element_line")
  expect_equal(thm$axis.ticks.x$colour, "#000000")
  expect_s3_class(thm$axis.ticks.y, "element_blank")
  expect_true(as.numeric(thm$axis.ticks.length) > 0)
})

test_that("theme_wsj draws no axis rule", {
  # The heavy horizontal line in WSJ charts is the zero baseline, drawn by the
  # plot, not an axis line drawn by the theme.
  expect_s3_class(theme_wsj()$axis.line, "element_blank")
})

test_that("the white field is gone", {
  expect_error(theme_wsj(paper = "white"), regexp = "must be one of")
  expect_equal(names(ggthemes_data$wsj$paper), c("ivory", "gray"))
})

test_that("palette errors name the input and the function called", {
  expect_snapshot(error = TRUE, {
    wsj_pal(NULL)
    scale_fill_gradient_wsj("x")
    wsj_callout(1, 1, "x", facets = list("b"))
    wsj_callout(1, 1, "x", facets = list(f = 1:3))
    wsj_callout(1:2, 1:2, c("x", "y"), facets = list(f = 1:3))
  })
})

test_that("palette names must be single strings", {
  expect_error(wsj_pal(c("reds", "blues")), regexp = "must be a string")
  expect_error(wsj_pal(NULL), regexp = "must be a string")
  expect_error(scale_fill_gradient_wsj(c("steel", "blue")), regexp = "must be a string")
  expect_error(scale_fill_gradient2_wsj(NULL), regexp = "must be a string")
})

test_that("categorical light and dark variants hold hue order", {
  base <- wsj_pal("categorical")(6)
  light <- wsj_pal("categorical_light")(6)
  dark <- wsj_pal("categorical_dark")(6)
  expect_hexcolor(light)
  expect_hexcolor(dark)
  expect_length(light, length(base))
  expect_length(dark, length(base))
  # light is lighter than base, dark is darker, for every color
  lum <- function(x) {
    rgb <- grDevices::col2rgb(x) / 255
    rgb <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
    as.vector(c(0.2126, 0.7152, 0.0722) %*% rgb)
  }
  expect_true(all(lum(light) > lum(base)))
  # Black has no darker shade; every hue does.
  expect_true(all(lum(dark)[-4] < lum(base)[-4]))
  expect_equal(dark[4], base[4])
})

test_that("wsj_label prints the unit on the topmost break only", {
  expect_equal(wsj_label(suffix = "%", hang = FALSE)(c(-5, 0, 5, 10)), c("-5", "0", "5", "10%"))
  expect_equal(wsj_label(prefix = "$")(c(0, 100, 200)), c("0", "100", "$200"))
})

test_that("wsj_label formats the topmost break like the others", {
  # a plain paste() would render 200000 as "$2e+05"
  expect_equal(
    wsj_label(prefix = "$")(c(0, 100000, 200000)),
    c("0", "100,000", "$200,000")
  )
})

test_that("wsj_label marks the largest break, not the last", {
  expect_equal(wsj_label(suffix = "%", hang = FALSE)(c(10, 5, 0)), c("10%", "5", "0"))
})

test_that("wsj_label handles NA and non-finite breaks", {
  expect_equal(wsj_label(suffix = "%", hang = FALSE)(c(0, 5, NA, 10))[3], NA_character_)
  expect_true(is.na(wsj_label(suffix = "%")(c(0, 5, NA, 10))[[3]]))
  expect_length(wsj_label()(c(NA_real_, NA_real_)), 2L)
})

test_that("wsj_label can drop the lowest break", {
  expect_equal(
    wsj_label(suffix = "%", drop_lowest = TRUE, hang = FALSE)(c(0, 5, 10)),
    c("", "5", "10%")
  )
})

test_that("wsj_label hangs the suffix past the other labels", {
  labels <- wsj_label(suffix = "%")(c(-5, 0, 5, 10))
  expect_type(labels, "expression")
  expect_equal(labels[[4]], "10%")
  expect_equal(labels[[1]], quote("-5" * phantom("%")))
  # A prefix hangs by right alignment alone, so the labels stay text.
  expect_equal(wsj_label(prefix = "$")(c(0, 100, 200)), c("0", "100", "$200"))
  expect_type(wsj_label()(c(0, 5)), "character")
})

test_that("theme_wsj sets the late gray type on the gray field, the title in black", {
  ink <- function(thm, element) ggplot2::calc_element(element, ggplot2::theme_grey() + thm)$colour
  for (el in c("axis.text.y.left", "plot.subtitle", "plot.caption", "strip.text.x.top")) {
    expect_equal(ink(theme_wsj(), el), "#000000", label = el)
    expect_equal(ink(theme_wsj(paper = "gray"), el), "#444444", label = el)
  }
  expect_equal(ink(theme_wsj(paper = "gray"), "plot.title"), "#000000")
})

test_that("theme_wsj prints black type and no axis titles", {
  thm <- theme_wsj()
  expect_equal(thm$text$colour, "#000000")
  expect_s3_class(thm$axis.title, "element_blank")
  # Regular-weight subtitles, as from July 2012.
  expect_null(thm$plot.subtitle$face)
})

test_that("shade palettes run darkest first", {
  lightness <- function(x) farver::decode_colour(x, to = "lab")[, "l"]
  for (pal in c("blues", "greens", "reds", "golds", "oranges")) {
    cols <- wsj_pal(pal)(attr(wsj_pal(pal), "max_n"))
    expect_true(all(diff(lightness(cols)) > 0), label = pal)
  }
  expect_equal(wsj_pal("comparison")(2), wsj_pal("blues")(2))
  # Every family has three shades; the lightest orange is extrapolated.
  for (pal in c("blues", "greens", "reds", "golds", "oranges")) {
    expect_equal(attr(wsj_pal(pal), "max_n"), 3L, label = pal)
  }
  expect_equal(wsj_pal("oranges")(3), c("#fb832d", "#fcac67", "#fdd1ab"))
})

test_that("the green_red diverging scale follows the direction colours", {
  expect_s3_class(scale_fill_gradient2_wsj("green_red"), "ScaleContinuous")
  pal <- ggthemes_data$wsj$diverging$green_red$value
  expect_equal(pal[c(1, 3)], c("#c72e29", "#098154"))
  expect_error(scale_fill_gradient2_wsj("nope"), regexp = "must be one of")
})

test_that("wsj_year_label writes the first year in full", {
  f <- wsj_year_label()
  expect_equal(f(c(2011, 2012, 2013)), c("2011", "'12", "'13"))
  expect_equal(f(as.Date(c("2011-01-01", "2012-01-01"))), c("2011", "'12"))
  expect_equal(f(c(1999, 2000, 2001)), c("1999", "'00", "'01"))
})

test_that("wsj_year_label marks the earliest year, not the first element", {
  expect_equal(wsj_year_label()(c(2013, 2012, 2011)), c("'13", "'12", "2011"))
})

test_that("wsj_year_label keeps NA breaks", {
  expect_equal(wsj_year_label()(c(NA, 2011, 2012)), c(NA, "2011", "'12"))
  expect_equal(wsj_year_label()(c(NA_real_, NA_real_)), c(NA_character_, NA_character_))
})

test_that("wsj_bands takes its fill from the paper", {
  expect_s3_class(wsj_bands(), "LayerInstance")
  expect_equal(wsj_bands()$geom_params$fill, "#efe4c9")
  expect_equal(wsj_bands("gray")$geom_params$fill, "#dddddd")
  expect_equal(wsj_bands(fill = "red")$geom_params$fill, "red")
  expect_error(wsj_bands("chartreuse"), regexp = "must be one of")
})

test_that("wsj_bands shades every other interval from the lowest break", {
  # The bands read the breaks of the y scale, which a data layer has to train.
  p <- ggplot2::ggplot(data.frame(x = 1:2, y = c(0, 10)), ggplot2::aes(x, y)) +
    wsj_bands() +
    ggplot2::geom_blank() +
    ggplot2::scale_y_continuous(breaks = seq(0, 10, 2), expand = c(0, 0))
  grob <- ggplot2::layer_grob(p, 1)[[1]]
  expect_s3_class(grob, "rect")
  # Breaks at 0, 2, ..., 10 give bands over [0, 2], [4, 6] and [8, 10].
  expect_equal(as.numeric(grob$y), c(0, 0.4, 0.8))
  expect_equal(as.numeric(grob$height), rep(0.2, 3))
})

test_that("wsj_bands draws correctly", {
  p <- theme_test_plot() + theme_wsj() + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  p$layers <- c(wsj_bands(), p$layers)
  expect_doppelganger("wsj-bands", p)
})

test_that("the gray field sets gray type and wsj_label hangs the suffix", {
  p <- theme_test_plot() +
    ggplot2::scale_y_continuous(labels = wsj_label(suffix = "%"), breaks = c(2, 4, 6, 8, 10), limits = c(2, 10)) +
    theme_wsj(paper = "gray")
  expect_doppelganger("wsj-gray-hang", p)
})

test_that("wsj_callout resolves the measured fills and picks a readable text colour", {
  black <- wsj_callout(1, 1, "July 4.6%")
  expect_s3_class(black, "LayerInstance")
  expect_equal(black$geom_params$fill, "#000000")
  expect_equal(black$geom_params$colour, "#ffffff")
  yellow <- wsj_callout(1, 1, "3.0%", fill = "yellow")
  expect_equal(yellow$geom_params$fill, "#ffe03d")
  expect_equal(yellow$geom_params$colour, "#000000")
  expect_equal(wsj_callout(1, 1, "x", fill = "#5d8ca8", colour = "red")$geom_params$colour, "red")
  expect_error(wsj_callout(1, 1, "x", shape = "star"), regexp = "must be one of")
})

test_that("wsj_callout draws a tail from the shape to the data point", {
  p <- ggplot2::ggplot(data.frame(x = 1:2, y = 1:2), ggplot2::aes(x, y)) +
    ggplot2::geom_blank() +
    wsj_callout(2, 2, "2Q:\n0.7%") +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0))
  grob <- ggplot2::layer_grob(p, 2)[[1]]
  callout <- grob$children[[1]]
  expect_s3_class(callout$children[[1]], "polygon")
  expect_s3_class(callout$children[[2]], "rect")
  expect_equal(callout$children[[3]]$label, "2Q:\n0.7%")
  # The tail's tip is the data point, the top right corner of the panel.
  tail <- callout$children[[1]]
  expect_equal(grid::convertX(tail$x[1], "npc", valueOnly = TRUE), 1)
  expect_equal(grid::convertY(tail$y[1], "npc", valueOnly = TRUE), 1)
})

test_that("wsj_callout draws one callout per point", {
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(x, y)) +
    ggplot2::geom_blank() +
    wsj_callout(c(1, 3), c(1, 3), c("a", "b"), shape = "circle")
  grob <- ggplot2::layer_grob(p, 2)[[1]]
  expect_length(grob$children, 2)
  expect_s3_class(grob$children[[1]]$children[[2]], "circle")
})

test_that("wsj_callout draws correctly", {
  d <- data.frame(quarter = 1:6, change = c(-7.9, -1.3, 6.8, 0.3, 5.2, 0.7))
  p <- ggplot2::ggplot(d, ggplot2::aes(quarter, change)) +
    ggplot2::geom_col() +
    wsj_callout(6, 0.7, "2Q:\n0.7%", shape = "rounded", nudge_x = -6, nudge_y = 30) +
    wsj_callout(3, 6.8, "3Q 6.8%", fill = "yellow", nudge_x = -20, nudge_y = -20) +
    wsj_callout(1, -7.9, "-7.9%", fill = "yellow", shape = "circle", nudge_x = 20, nudge_y = 10) +
    theme_wsj()
  expect_doppelganger("wsj-callout", p)
})

test_that("wsj_threshold_crossings interpolates where the series crosses", {
  xy <- wsj_threshold_crossings(c(0, 1, 2), c(-1, 1, 3), threshold = 0)
  expect_equal(xy$x, c(0, 0.5, 1, 2))
  expect_equal(xy$y, c(-1, 0, 1, 3))
  # A series that touches the threshold without crossing it adds nothing.
  expect_equal(wsj_threshold_crossings(1:3, c(1, 0, 1), 0)$x, 1:3)
})

test_that("geom_wsj_threshold draws one fill above and one below", {
  d <- data.frame(x = 1:4, y = c(52, 48, 49, 51))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) + geom_wsj_threshold(threshold = 50)
  grob <- ggplot2::layer_grob(p, 1)[[1]]
  polys <- grob$children
  expect_length(polys, 2L)
  expect_equal(polys[[1]]$gp$fill, "#65A479FF")
  expect_equal(polys[[2]]$gp$fill, "#D5695DFF")
  expect_error(geom_wsj_threshold(fill = "red"), regexp = "two colors")
})

test_that("wsj_direction_bar draws two arrows and an optional title", {
  p <- ggplot2::ggplot(data.frame(x = 1:2, y = c(-1, 1)), ggplot2::aes(x, y)) + ggplot2::geom_blank()
  plain <- ggplot2::layer_grob(p + wsj_direction_bar(0), 2)[[1]]
  # Two arrows, each a body and a label.
  expect_length(plain$children, 4L)
  titled <- ggplot2::layer_grob(p + wsj_direction_bar(0, title = "SENTIMENT"), 2)[[1]]
  expect_length(titled$children, 5L)
  expect_equal(titled$children[[5]]$label, "SENTIMENT")
  expect_error(wsj_direction_bar(labels = "Up"), regexp = "two values")
  expect_error(wsj_direction_bar(side = "top"), regexp = "must be one of")
})

test_that("threshold charts draw correctly", {
  d <- data.frame(
    x = 1:12,
    y = c(54.5, 51.7, 51.8, 51.6, 50.1, 49.3, 49.9, 51, 47.7, 48.7, 49.3, 47.8)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    geom_wsj_threshold(threshold = 50) +
    ggplot2::geom_hline(yintercept = 50) +
    ggplot2::geom_line() +
    wsj_direction_bar(50, title = "PMI") +
    ggplot2::coord_cartesian(clip = "off") +
    theme_wsj() +
    ggplot2::theme(plot.margin = ggplot2::margin(12, 30, 12, 12))
  expect_doppelganger("wsj-threshold", p)
})

test_that("theme_wsj sets panel headings flush left with wide gutters", {
  thm <- theme_wsj()
  expect_equal(thm$strip.text$hjust, 0)
  expect_equal(thm$strip.text$face, "bold")
  expect_equal(as.numeric(thm$panel.spacing), 2)
})

test_that("wsj_callout and wsj_direction_bar can target one panel", {
  d <- data.frame(x = rep(1:3, 2), y = c(49, 51, 52, 48, 50, 53), f = rep(c("a", "b"), each = 3))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~f)
  callout <- ggplot2::layer_data(p + wsj_callout(3, 53, "x", facets = list(f = "b")), 2)
  expect_equal(as.integer(callout$PANEL), 2L)
  bar <- ggplot2::layer_data(p + wsj_direction_bar(50, facets = list(f = "a")), 2)
  expect_equal(as.integer(bar$PANEL), 1L)
  # Without facet values they are drawn in every panel, as annotate() is.
  expect_equal(nrow(ggplot2::layer_data(p + wsj_callout(3, 53, "x"), 2)), 2L)
})

test_that("facet values must be named and fit the data", {
  expect_error(wsj_callout(1, 1, "x", facets = list("b")), regexp = "named")
  expect_error(wsj_callout(1, 1, "x", facets = "b"), regexp = "named")
  expect_error(wsj_callout(1:2, 1:2, c("x", "y"), facets = list(f = c("a", "b", "c"))), regexp = "length 1 or 2")
})

test_that("misspelled arguments are errors, not facet values", {
  expect_error(wsj_callout(1, 1, "x", nudgex = 5), regexp = "unused argument")
  expect_error(wsj_direction_bar(0, lables = c("a", "b")), regexp = "unused argument")
})

test_that("geom_wsj_threshold breaks its fills at missing values", {
  d <- data.frame(x = 1:7, y = c(1, -1, 1, NA, 2, -2, 1))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) + geom_wsj_threshold()
  fills <- ggplot2::layer_grob(p)[[1]]$children
  # Two runs, each an above and a below polygon.
  expect_length(fills, 4L)
  # No polygon spans the gap at x = 4.
  r <- ggplot2::ggplot_build(p)$layout$panel_params[[1]]$x.range
  gap <- (4 - r[1]) / diff(r)
  spans_gap <- vapply(fills, function(g) min(as.numeric(g$x)) < gap && max(as.numeric(g$x)) > gap, logical(1))
  expect_false(any(spans_gap))
})

test_that("multi-panel WSJ charts draw correctly", {
  d <- data.frame(
    x = rep(1:12, 2),
    panel = rep(c("China's official PMI", "Taiwan's HSBC PMI"), each = 12),
    y = c(
      50.5,
      51,
      49.5,
      50.2,
      50.8,
      49.6,
      49.2,
      50.1,
      50.6,
      51.2,
      50.4,
      51,
      55,
      53,
      51,
      48,
      47,
      49.5,
      52,
      49,
      46,
      45,
      47,
      51
    )
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    geom_wsj_threshold(threshold = 50) +
    ggplot2::geom_hline(yintercept = 50) +
    ggplot2::geom_line() +
    wsj_callout(12, 51, "Dec. 51", facets = list(panel = "Taiwan's HSBC PMI")) +
    wsj_direction_bar(50, side = "left", offset = 30, facets = list(panel = "China's official PMI")) +
    ggplot2::facet_wrap(~panel, scales = "free_y") +
    ggplot2::coord_cartesian(clip = "off") +
    theme_wsj() +
    ggplot2::theme(plot.margin = ggplot2::margin(12, 12, 12, 44))
  expect_doppelganger("wsj-panels", p)
})

test_that("the default sequential ramp is the measured steel ramp", {
  steel <- ggthemes_data$wsj$sequential$steel$value
  expect_equal(steel, c("#eff4f9", "#d7e4ee", "#abbdcb", "#5d8ca8", "#016392"))
  lightness <- farver::decode_colour(steel, to = "lab")[, "l"]
  expect_true(all(diff(lightness) < 0))
  sc <- scale_fill_gradient_wsj()
  sc$train(c(0, 1))
  expect_equal(toupper(sc$map(c(0, 1))), toupper(steel[c(1, 5)]))
  expect_s3_class(scale_fill_gradient_wsj("blue"), "ScaleContinuous")
  expect_error(scale_fill_gradient_wsj("nope"), regexp = "must be one of")
})

test_that("the light partner of black is a neutral gray", {
  light <- wsj_pal("categorical_light")(6)
  expect_equal(light[4], "#bdbdbd")
})
