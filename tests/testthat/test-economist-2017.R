# theme_economist_2017() and its palettes implement The Economist visual
# styleguide, v1.2 (4 May 2017). The expected values below are the guide's own,
# with the page they come from, so a failure says which rule changed.

# Columns are referenced through the `.data` pronoun; the local binding lets
# lintr's object_usage_linter see where the name comes from.
.data <- rlang::.data

economist_2017_spec <- function(media) ggthemes::ggthemes_data$economist_2017[[media]]

# Size of a theme element in points, with rel() resolved against the theme.
resolved_size <- function(thm, element) {
  ggplot2::calc_element(element, thm)$size
}

# A linewidth in ggplot2 units, converted back to points.
linewidth_pt <- function(linewidth) linewidth * ggplot2::.pt * 0.75

unit_pt <- function(x) grid::convertUnit(x, "pt", valueOnly = TRUE)

# Palettes ---------------------------------------------------------------------

test_that("economist_2017_pal returns the guide's print orders", {
  expected <- list(
    bar_side = c("blue1", "blue2", "gold", "teal", "maroon", "mauve"),
    stacked = c("blue1", "blue2", "gold", "teal", "mint", "navy"),
    line_side = c("blue1", "blue2", "gold", "maroon", "teal", "mauve"),
    dot = c("blue2", "maroon", "gold", "blue1", "teal", "mauve"),
    pie = c("blue1", "blue2", "gold", "teal", "maroon", "mint")
  )
  for (type in names(expected)) {
    pal <- economist_2017_pal("print", type = type)
    ref <- economist_2017_spec("print")$qualitative[[type]]
    expect_equal(ref$name, expected[[type]], info = type)
    expect_equal(pal(6), ref$value, info = type)
    expect_equal(attr(pal, "max_n"), 6, info = type)
  }
})

test_that("economist_2017_pal print orders reuse the same six hues", {
  qual <- economist_2017_spec("print")$qualitative
  hues <- unique(unlist(lapply(qual[c("bar_side", "stacked", "line_side", "dot", "pie")], `[[`, "value")))
  # bar_side's six plus mint and navy, which replace mauve or maroon in the
  # stacked and pie orders (pp.14, 16, 20).
  expect_length(hues, 8)
})

test_that("economist_2017_pal has the supporting print sets", {
  expect_equal(economist_2017_pal(set = "bright")(4), c("#A15E7F", "#ED6D46", "#ECA300", "#BBBC22"))
  expect_equal(economist_2017_pal(set = "dark")(3), c("#00597A", "#125B55", "#8D8B7A"))
  # type has no effect on a supporting set
  expect_equal(
    economist_2017_pal(set = "bright", type = "dot")(4),
    economist_2017_pal(set = "bright")(4)
  )
})

test_that("economist_2017_pal is the same for print and web", {
  for (type in c("bar_side", "stacked", "line_side", "dot", "pie")) {
    expect_equal(economist_2017_pal("web", type = type)(6), economist_2017_pal("print", type = type)(6), info = type)
  }
  for (set in c("bright", "dark")) {
    pal <- economist_2017_pal("print", set = set)
    expect_equal(economist_2017_pal("web", set = set)(attr(pal, "max_n")), pal(attr(pal, "max_n")), info = set)
  }
  # The guide's web charts (pp.3, 7, 9) open blue1, blue2, gold, as print does.
  expect_equal(economist_2017_pal("web")(3), c("#006AA0", "#3DBCD2", "#E5B65F"))
  expect_equal(
    economist_2017_gradient_pal("red", media = "web")(seq(0, 1, 0.25)),
    economist_2017_gradient_pal("red", media = "print")(seq(0, 1, 0.25))
  )
})

test_that("economist_2017 web swatches list p.12", {
  sw <- ggthemes_data$economist_2017$web$swatches
  expect_named(sw, c("name", "group", "value"))
  expect_equal(as.vector(table(factor(sw$group, unique(sw$group)))), c(10, 4))
  expect_equal(
    sw$value[sw$group == "main"],
    c("#E3120B", "#DB444B", "#006BA2", "#3EBCD2", "#379A8B", "#EBB434", "#B4BA39", "#9A607F", "#D1B07C", "#758D99")
  )
  expect_false(anyDuplicated(sw$name) > 0)
})

test_that("economist_2017_pal rejects unknown arguments", {
  expect_error(economist_2017_pal("screen"))
  expect_error(economist_2017_pal(type = "area"))
})

test_that("economist_2017_pal warns past its maximum and handles n = 0", {
  expect_warning(out <- economist_2017_pal()(7), "maximum of 6")
  expect_length(out, 7)
  expect_true(is.na(out[7]))
  expect_equal(economist_2017_pal()(0), character(0))
})

test_that("economist_2017 palettes are valid hex with no repeats", {
  spec <- ggthemes_data$economist_2017
  colour_sets <- c(
    lapply(spec$print$qualitative, `[[`, "value"),
    lapply(spec$web$qualitative, `[[`, "value"),
    spec$print$sequential,
    spec$web$sequential
  )
  for (nm in names(colour_sets)) {
    expect_match(colour_sets[[nm]], "^#[0-9A-F]{6}$", all = TRUE, info = nm)
    expect_false(anyDuplicated(colour_sets[[nm]]) > 0, info = nm)
  }
})

test_that("economist_2017 print swatches cover p.11", {
  sw <- ggthemes_data$economist_2017$print$swatches
  expect_named(sw, c("name", "group", "c", "m", "y", "k", "value"))
  expect_equal(nrow(sw), 28)
  expect_equal(
    as.vector(table(factor(sw$group, unique(sw$group)))),
    c(6, 5, 4, 3, 3, 3, 4)
  )
  for (ink in c("c", "m", "y", "k")) {
    expect_type(sw[[ink]], "double")
    expect_true(all(sw[[ink]] >= 0 & sw[[ink]] <= 100), info = ink)
  }
  expect_match(sw$value, "^#[0-9A-F]{6}$", all = TRUE)
  expect_false(anyDuplicated(sw$name) > 0)
  # CMYK as printed on p.11, and its FOGRA39 conversion.
  cmyk <- function(nm) unlist(sw[sw$name == nm, c("c", "m", "y", "k")], use.names = FALSE)
  expect_equal(cmyk("blue2"), c(67, 0, 18, 0))
  expect_equal(cmyk("print bkgd"), c(7.5, 0, 0, 5))
  expect_equal(sw$value[sw$name == "econ red"], "#E3000F")
  # K-only swatches are neutral grey under FOGRA39, darkening with K.
  greys <- sw[sw$group == "black", ]
  rgb <- grDevices::col2rgb(greys$value)
  expect_true(all(apply(rgb, 2, function(x) diff(range(x)) <= 2)))
  expect_true(all(diff(rgb[1, ]) < 0))
  # The palette and theme colours are drawn from the swatches.
  print_spec <- ggthemes_data$economist_2017$print
  palette <- unlist(lapply(print_spec$qualitative, `[[`, "value"))
  expect_true(all(palette %in% sw$value))
  backgrounds <- c(print_spec$ground, print_spec$highlight, print_spec$number_box, print_spec$grid, print_spec$accent)
  expect_true(all(backgrounds %in% sw$value))
})

test_that("economist_2017 FOGRA39 print colours reproduce the web palette", {
  skip_if_not_installed("farver")
  sw <- ggthemes_data$economist_2017$print$swatches
  web <- ggthemes_data$economist_2017$web
  web_main <- setNames(web$swatches$value, web$swatches$name)
  pairs <- c(
    "econ red" = web$accent, "blue1" = web_main[["blue"]],
    "blue2" = web_main[["cyan"]], "grey box" = web_main[["grey"]]
  )
  print_cols <- sw$value[match(names(pairs), sw$name)]
  de <- diag(farver::compare_colour(
    farver::decode_colour(print_cols), farver::decode_colour(unname(pairs)),
    from_space = "rgb", method = "cie2000"
  ))
  expect_true(all(de < 1.5), info = paste(names(pairs), round(de, 2), collapse = "; "))
})

test_that("economist_2017 ramps run from light to dark", {
  skip_if_not_installed("farver")
  ramps <- ggthemes_data$economist_2017$print$sequential
  expect_identical(ggthemes_data$economist_2017$web$sequential, ramps)
  expect_named(ramps, c("red", "blue", "cyan", "green", "yellow", "olive", "purple", "gold", "grey"))
  for (nm in names(ramps)) {
    expect_length(ramps[[nm]], 6)
    lightness <- farver::decode_colour(ramps[[nm]], to = "lab")[, "l"]
    expect_true(all(diff(lightness) < 0), info = nm)
  }
})

test_that("economist_2017_gradient_pal interpolates the p.12 ramps", {
  pal <- economist_2017_gradient_pal("blue")
  expect_equal(toupper(pal(c(0, 1))), c("#98DAFF", "#00588D"))
  expect_equal(toupper(economist_2017_gradient_pal("blue", direction = -1)(c(0, 1))), c("#00588D", "#98DAFF"))
  expect_error(economist_2017_gradient_pal("teal"))
  expect_error(economist_2017_gradient_pal(direction = 0), "direction")
})

test_that("economist_2017 scales have the right classes", {
  expect_s3_class(scale_colour_economist_2017(), "ScaleDiscrete")
  expect_s3_class(scale_fill_economist_2017("web"), "ScaleDiscrete")
  expect_identical(scale_color_economist_2017, scale_colour_economist_2017)
  expect_s3_class(scale_colour_economist_2017_c(), "ScaleContinuous")
  expect_s3_class(scale_fill_economist_2017_c(hue = "red"), "ScaleContinuous")
  expect_identical(scale_color_economist_2017_c, scale_colour_economist_2017_c)
  expect_equal(
    scale_fill_economist_2017(type = "dot")$palette(6),
    economist_2017_pal(type = "dot")(6)
  )
})

# Theme ------------------------------------------------------------------------

test_that("theme_economist_2017 is a complete theme for both media", {
  for (media in c("print", "web")) {
    thm <- theme_economist_2017(media)
    expect_s3_class(thm, "theme")
    expect_true(attr(thm, "complete"), info = media)
  }
  expect_error(theme_economist_2017("screen"))
})

test_that("theme_economist_2017 sets the guide's type sizes at base_size 10", {
  # p.6: title 9.5pt, subtitle 8pt, legend and panel headings 7.5pt, axis
  # numbers and axis label 7pt, source 6.5pt.
  thm <- theme_economist_2017()
  expect_equal(resolved_size(thm, "plot.title"), 9.5)
  expect_equal(resolved_size(thm, "plot.subtitle"), 8)
  expect_equal(resolved_size(thm, "legend.title"), 7.5)
  expect_equal(resolved_size(thm, "legend.text"), 7.5)
  expect_equal(resolved_size(thm, "strip.text.x.top"), 7.5)
  expect_equal(resolved_size(thm, "axis.text.x.bottom"), 7)
  expect_equal(resolved_size(thm, "axis.text.y.right"), 7)
  expect_equal(resolved_size(thm, "axis.title.x.bottom"), 7)
  expect_equal(resolved_size(thm, "plot.caption"), 6.5)
})

test_that("theme_economist_2017 sets the guide's leading", {
  # p.6: 9.5/11, 8/9.5, 7.5/9, 7/7.5
  thm <- theme_economist_2017()
  expect_equal(ggplot2::calc_element("plot.title", thm)$lineheight, 11 / 9.5)
  expect_equal(ggplot2::calc_element("plot.subtitle", thm)$lineheight, 9.5 / 8)
  expect_equal(ggplot2::calc_element("legend.text", thm)$lineheight, 9 / 7.5)
  expect_equal(ggplot2::calc_element("axis.title.x.bottom", thm)$lineheight, 7.5 / 7)
})

test_that("theme_economist_2017 maps Econ Sans weights to bold and plain", {
  # Bold title; medium (headings) and lighter weights are drawn plain.
  thm <- theme_economist_2017()
  expect_equal(ggplot2::calc_element("plot.title", thm)$face, "bold")
  for (el in c("plot.subtitle", "legend.title", "strip.text.x.top", "axis.text.x.bottom", "plot.caption")) {
    expect_equal(ggplot2::calc_element(el, thm)$face, "plain", info = el)
  }
})

test_that("theme_economist_2017 rules at the guide's weights", {
  # p.6: gridlines and baseline 0.5pt, tick marks 0.4pt.
  thm <- theme_economist_2017()
  expect_equal(linewidth_pt(ggplot2::calc_element("panel.grid.major.y", thm)$linewidth), 0.5)
  expect_equal(linewidth_pt(ggplot2::calc_element("axis.line.x.bottom", thm)$linewidth), 0.5)
  expect_equal(linewidth_pt(ggplot2::calc_element("axis.ticks.x.bottom", thm)$linewidth), 0.4)
})

test_that("theme_economist_2017 hangs 5pt ticks below the baseline", {
  # p.6: ticks 5pt tall (minor 3pt), outside the panel.
  thm <- theme_economist_2017()
  major <- ggplot2::calc_element("axis.ticks.length.x.bottom", thm)
  minor <- ggplot2::calc_element("axis.minor.ticks.length.x.bottom", thm)
  expect_equal(unit_pt(major), 5)
  expect_equal(unit_pt(minor), 3)
})

test_that("theme_economist_2017 rules only the x axis", {
  # p.6: no y-axis line and no y ticks; the baseline is black (p.18).
  for (media in c("print", "web")) {
    thm <- theme_economist_2017(media)
    expect_s3_class(ggplot2::calc_element("axis.line.y.right", thm), "element_blank")
    expect_s3_class(ggplot2::calc_element("axis.ticks.y.right", thm), "element_blank")
    expect_equal(ggplot2::calc_element("axis.line.x.bottom", thm)$colour, economist_2017_spec(media)$baseline)
  }
})

test_that("theme_economist_2017 draws a top value axis without rule or ticks", {
  # p.13: a horizontal bar chart's value axis is numbers over gridlines.
  for (media in c("print", "web")) {
    thm <- theme_economist_2017(media)
    expect_s3_class(ggplot2::calc_element("axis.line.x.top", thm), "element_blank")
    expect_s3_class(ggplot2::calc_element("axis.ticks.x.top", thm), "element_blank")
    expect_equal(unit_pt(ggplot2::calc_element("axis.ticks.length.x.top", thm)), 0)
    # The bottom axis keeps its baseline and ticks.
    expect_s3_class(ggplot2::calc_element("axis.line.x.bottom", thm), "element_line")
    expect_s3_class(ggplot2::calc_element("axis.ticks.x.bottom", thm), "element_line")
  }
})

test_that("theme_economist_2017 ranges left-axis labels left", {
  # p.13: the categories of a horizontal bar chart start at the chart's edge.
  expect_equal(ggplot2::calc_element("axis.text.y.left", theme_economist_2017())$hjust, 0)
})

test_that("theme_economist_2017 uses each medium's colours", {
  for (media in c("print", "web")) {
    spec <- economist_2017_spec(media)
    thm <- theme_economist_2017(media)
    expect_equal(ggplot2::calc_element("plot.background", thm)$fill, spec$ground, info = media)
    expect_equal(ggplot2::calc_element("panel.grid.major.y", thm)$colour, spec$grid, info = media)
    expect_equal(ggplot2::calc_element("plot.title", thm)$colour, spec$text, info = media)
    expect_equal(ggplot2::calc_element("plot.caption", thm)$colour, spec$source, info = media)
  }
  expect_equal(economist_2017_spec("print")$ground, "#E7F0F5")
  expect_equal(economist_2017_spec("web")$ground, "#FFFFFF")
  # "Source text 75% black" (p.3)
  expect_equal(economist_2017_spec("print")$source, "#404040")
})

test_that("theme_economist_2017 uses print and web outer margins", {
  # p.6: 6pt at the sides and bottom for print. p.7: none at the sides for
  # web. Neither has a top margin: the tab sits on the top edge.
  print_margin <- unit_pt(ggplot2::calc_element("plot.margin", theme_economist_2017("print")))
  web_margin <- unit_pt(ggplot2::calc_element("plot.margin", theme_economist_2017("web")))
  expect_equal(print_margin, c(0, 6, 6, 6))
  expect_equal(web_margin[c(2, 4)], c(0, 0))
  expect_equal(web_margin[1], 0)
})

test_that("theme_economist_2017 spaces panels as the guide does", {
  # p.10: 24pt side by side, 15pt stacked.
  thm <- theme_economist_2017()
  expect_equal(unit_pt(ggplot2::calc_element("panel.spacing.x", thm)), 24)
  expect_equal(unit_pt(ggplot2::calc_element("panel.spacing.y", thm)), 15)
})

test_that("theme_economist_2017 places the key by medium", {
  # p.6: print key flush left under the subtitle. p.7: web key top right.
  expect_equal(ggplot2::calc_element("legend.justification.top", theme_economist_2017("print")), "left")
  expect_equal(ggplot2::calc_element("legend.justification.top", theme_economist_2017("web")), "right")
  for (media in c("print", "web")) {
    thm <- theme_economist_2017(media)
    expect_equal(thm$legend.position, "top")
    expect_equal(thm$legend.location, "plot")
    expect_true(thm$legend.byrow)
  }
})

test_that("theme_economist_2017 aligns title and source to the plot", {
  thm <- theme_economist_2017()
  expect_equal(thm$plot.title.position, "plot")
  expect_equal(thm$plot.caption.position, "plot")
  expect_equal(ggplot2::calc_element("plot.title", thm)$hjust, 0)
  expect_equal(ggplot2::calc_element("plot.caption", thm)$hjust, 0)
})

test_that("theme_economist_2017 scales every size with base_size", {
  small <- theme_economist_2017(base_size = 10)
  large <- theme_economist_2017(base_size = 20)
  expect_equal(resolved_size(large, "plot.title"), 2 * resolved_size(small, "plot.title"))
  expect_equal(resolved_size(large, "axis.text.x.bottom"), 2 * resolved_size(small, "axis.text.x.bottom"))
  expect_equal(
    ggplot2::calc_element("panel.grid.major.y", large)$linewidth,
    2 * ggplot2::calc_element("panel.grid.major.y", small)$linewidth
  )
  for (el in c("axis.ticks.length.x.bottom", "panel.spacing.x", "plot.margin")) {
    expect_equal(
      unit_pt(ggplot2::calc_element(el, large)),
      2 * unit_pt(ggplot2::calc_element(el, small)),
      info = el
    )
  }
  expect_equal(
    unit_pt(ggplot2::calc_element("plot.title", large)$margin),
    2 * unit_pt(ggplot2::calc_element("plot.title", small)$margin)
  )
})

test_that("theme_economist_2017 respects base_family and horizontal", {
  thm <- theme_economist_2017(base_family = "serif")
  expect_equal(ggplot2::calc_element("plot.title", thm)$family, "serif")
  expect_s3_class(ggplot2::calc_element("panel.grid.major.x", theme_economist_2017()), "element_blank")
  vertical <- theme_economist_2017(horizontal = FALSE)
  expect_s3_class(ggplot2::calc_element("panel.grid.major.y", vertical), "element_blank")
  expect_s3_class(ggplot2::calc_element("panel.grid.major.x", vertical), "element_line")
})

# guide_axis_economist_2017() --------------------------------------------------------

guide_test_plot <- function(...) {
  ggplot2::ggplot(data.frame(x = 1:3, y = c(0, 4, 8)), ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_point() +
    ggplot2::scale_y_continuous(position = "right", guide = guide_axis_economist_2017(...), breaks = c(0, 4, 8)) +
    theme_economist_2017()
}

test_that("guide_axis_economist_2017 returns an axis guide", {
  guide <- guide_axis_economist_2017()
  expect_s3_class(guide, "GuideAxisEconomist2017")
  expect_s3_class(guide, "GuideAxis")
  expect_error(guide_axis_economist_2017(gap = 1), "unit")
})

test_that("guide_axis_economist_2017 takes no width beside the panel", {
  gt <- ggplot2::ggplotGrob(guide_test_plot())
  axis <- gt$grobs[[which(gt$layout$name == "axis-r")]]
  expect_equal(unit_pt(grid::grobWidth(axis)), 0)
})

test_that("guide_axis_economist_2017 draws labels above their gridlines, inside the panel", {
  gt <- ggplot2::ggplotGrob(guide_test_plot())
  axis <- gt$grobs[[which(gt$layout$name == "axis-r")]]
  labels <- axis$grobs[[which(axis$layout$name == "labels")]]
  text <- labels$children[[1]]
  expect_equal(text$label, c("0", "4", "8"))
  expect_equal(text$hjust, 1)
  expect_equal(text$vjust, 0)
  # x = 0 is the panel's right edge; the labels are right-aligned to it.
  expect_equal(unit_pt(text$x), 0)
  # 1pt above each break for 7pt labels (p.6)
  expect_true(all(grepl("1points", as.character(text$y))))
})

test_that("guide_axis_economist_2017 draws left axes into the panel too", {
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_point() +
    ggplot2::scale_y_continuous(guide = guide_axis_economist_2017()) +
    theme_economist_2017()
  gt <- ggplot2::ggplotGrob(p)
  axis <- gt$grobs[[which(gt$layout$name == "axis-l")]]
  text <- axis$grobs[[which(axis$layout$name == "labels")]]$children[[1]]
  expect_equal(text$hjust, 0)
  expect_equal(grid::convertX(text$x, "npc", valueOnly = TRUE), 1)
})

test_that("guide_axis_economist_2017 takes a custom gap", {
  gt <- ggplot2::ggplotGrob(guide_test_plot(gap = grid::unit(3, "pt")))
  axis <- gt$grobs[[which(gt$layout$name == "axis-r")]]
  text <- axis$grobs[[which(axis$layout$name == "labels")]]$children[[1]]
  expect_true(all(grepl("3points", as.character(text$y))))
})

test_that("guide_axis_economist_2017 falls back to a standard axis on x", {
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_point() +
    ggplot2::scale_x_continuous(guide = guide_axis_economist_2017()) +
    theme_economist_2017()
  gt <- ggplot2::ggplotGrob(p)
  axis <- gt$grobs[[which(gt$layout$name == "axis-b")]]
  expect_gt(unit_pt(grid::grobHeight(axis)), 0)
})

# economist_2017_chart() ----------------------------------------------------

chart_plot <- function(media = "print", facet = FALSE) {
  df <- data.frame(x = 1:4, y = 1:4, g = c("a", "b"))
  p <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, colour = .data$g)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "Title", subtitle = "Subtitle") +
    theme_economist_2017(media)
  if (facet) {
    p <- p + ggplot2::facet_wrap(ggplot2::vars(.data$g))
  }
  p
}

# The chart is laid out at draw time; build it as makeContent() would.
chart_gtable <- function(p, media = "print") {
  grid::makeContent(economist_2017_chart(p, media))$children[[1]]
}

test_that("economist_2017_chart returns a drawable grob", {
  out <- economist_2017_chart(chart_plot())
  expect_s3_class(out, "ggthemes_economist_chart")
  expect_s3_class(out, "grob")
  expect_error(economist_2017_chart(1), "ggplot")
  expect_error(economist_2017_chart(chart_plot(), "screen"))
})

test_that("economist_2017_chart adds the tab, and the rule for web", {
  print_gt <- chart_gtable(chart_plot("print"), "print")
  web_gt <- chart_gtable(chart_plot("web"), "web")
  expect_true("economist-tab" %in% print_gt$layout$name)
  expect_false("economist-rule" %in% print_gt$layout$name)
  expect_true(all(c("economist-tab", "economist-rule") %in% web_gt$layout$name))
  tab <- print_gt$grobs[[which(print_gt$layout$name == "economist-tab")]]
  # 15pt by 5pt, in the medium's accent red (pp.6-7)
  expect_equal(unit_pt(tab$width), 15)
  expect_equal(unit_pt(tab$height), 5)
  expect_equal(tab$gp$fill, economist_2017_spec("print")$accent)
  # Placed at the print chart's 6pt side margin, on the top edge (p.6)
  expect_equal(unit_pt(tab$x), 6)
  expect_equal(grid::convertY(tab$y, "npc", valueOnly = TRUE), 1)
})

test_that("economist_2017_chart scales with the plot's base size", {
  p <- chart_plot() + theme_economist_2017(base_size = 20)
  tab <- chart_gtable(p)$grobs
  tab <- tab[[length(tab)]]
  expect_equal(unit_pt(tab$width), 30)
})

test_that("economist_2017_chart marks each panel heading", {
  gt <- chart_gtable(chart_plot(facet = TRUE))
  markers <- grep("^economist-marker-", gt$layout$name, value = TRUE)
  expect_length(markers, 2)
  marker <- gt$grobs[[which(gt$layout$name == markers[1])]]
  # 10pt by 1pt (p.10)
  expect_equal(unit_pt(marker$width), 10)
  expect_equal(unit_pt(marker$height), 1)
})

test_that("economist_2017_chart moves a web key beside the title", {
  gt <- chart_gtable(chart_plot("web"), "web")
  key <- gt$layout[gt$layout$name == "guide-box-top", ]
  title <- gt$layout[gt$layout$name == "title", ]
  subtitle <- gt$layout[gt$layout$name == "subtitle", ]
  expect_equal(key$t, title$t)
  expect_equal(key$b, subtitle$b)
  # Print keeps its key under the subtitle
  print_gt <- chart_gtable(chart_plot("print"), "print")
  print_key <- print_gt$layout[print_gt$layout$name == "guide-box-top", ]
  expect_gt(print_key$t, print_gt$layout$b[print_gt$layout$name == "subtitle"])
})

test_that("economist_2017_chart leaves a plot without a key alone", {
  p <- chart_plot("web") + ggplot2::theme(legend.position = "none")
  expect_no_error(chart_gtable(p, "web"))
})

test_that("economist_2017_chart adds a footnote on the source line", {
  p <- chart_plot() + ggplot2::labs(caption = "Source: somewhere")
  gt <- grid::makeContent(economist_2017_chart(p, footnote = "*Estimate"))$children[[1]]
  footnote <- gt$layout[gt$layout$name == "economist-footnote", ]
  caption <- gt$layout[gt$layout$name == "caption", ]
  expect_equal(footnote$t, caption$t)
  text <- gt$grobs[[which(gt$layout$name == "economist-footnote")]]
  expect_match(paste(unlist(lapply(text$children, `[[`, "label")), collapse = ""), "Estimate")
})

test_that("economist_2017_chart ends the footnote on the source line's last line", {
  # pp.6-7, 15: a one-line footnote sits level with the last line of a
  # two-line source, and a two-line footnote under a one-line source fits.
  two_line_source <- chart_plot() + ggplot2::labs(caption = "Sources: one;\ntwo")
  gt <- grid::makeContent(economist_2017_chart(two_line_source, footnote = "*Note"))$children[[1]]
  footnote <- gt$grobs[[which(gt$layout$name == "economist-footnote")]]
  expect_equal(footnote$children[[1]]$vjust, 0)

  one_line_source <- chart_plot() + ggplot2::labs(caption = "Source: one")
  gt <- grid::makeContent(economist_2017_chart(one_line_source, footnote = "*First\nsecond"))$children[[1]]
  row <- gt$layout$t[gt$layout$name == "caption"]
  footnote <- gt$grobs[[which(gt$layout$name == "economist-footnote")]]
  expect_gte(unit_pt(gt$heights[row]), unit_pt(grid::grobHeight(footnote)))
})

test_that("economist_2017_chart gives a plot without a source a line for its footnote", {
  gt <- chart_gtable(chart_plot())
  expect_false("economist-footnote" %in% gt$layout$name)
  gt <- grid::makeContent(economist_2017_chart(chart_plot(), footnote = "*Estimate"))$children[[1]]
  expect_true("economist-footnote" %in% gt$layout$name)
})

test_that("economist_2017_chart draws a number box in the medium's box colour", {
  for (media in c("print", "web")) {
    gt <- grid::makeContent(economist_2017_chart(chart_plot(media), media, number = 2))$children[[1]]
    box <- gt$grobs[[which(gt$layout$name == "economist-number")]]
    rect <- box$children[[1]]
    expect_equal(unit_pt(rect$width), 10, info = media)
    expected <- economist_2017_spec(media)[[if (media == "print") "number_box" else "box"]]
    expect_equal(rect$gp$fill, expected, info = media)
    expect_equal(box$children[[2]]$label, "2", info = media)
    # A white numeral on the box (p.25)
    expect_equal(box$children[[2]]$gp$col, "white", info = media)
  }
})

test_that("economist_2017_chart takes a tab size", {
  gt <- grid::makeContent(economist_2017_chart(chart_plot(), tab = c(15, 4)))$children[[1]]
  tab <- gt$grobs[[which(gt$layout$name == "economist-tab")]]
  expect_equal(unit_pt(tab$height), 4)
  expect_error(economist_2017_chart(chart_plot(), tab = 5), "tab")
  expect_error(economist_2017_chart(chart_plot(), footnote = c("a", "b")), "footnote")
})

test_that("economist_2017_chart moves y-axis titles above the panels", {
  # p.10: units sit horizontally over their axis, not in a column beside it.
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_point() +
    ggplot2::scale_y_continuous(
      position = "right",
      guide = guide_axis_economist_2017(),
      name = "Right, %",
      sec.axis = ggplot2::dup_axis(name = "Left, %", guide = guide_axis_economist_2017())
    ) +
    theme_economist_2017()
  gt <- chart_gtable(p)
  expect_false(any(c("ylab-l", "ylab-r") %in% gt$layout$name))
  panel <- gt$layout[gt$layout$name == "panel", ]
  for (side in c("left", "right")) {
    title <- gt$layout[gt$layout$name == paste0("economist-ylab-", side), ]
    expect_equal(nrow(title), 1, info = side)
    # In the row directly above the panel, across the panel's width.
    expect_equal(title$t, panel$t - 1, info = side)
    expect_equal(c(title$l, title$r), c(panel$l, panel$r), info = side)
  }
  right <- gt$grobs[[which(gt$layout$name == "economist-ylab-right")]]
  expect_match(economist_2017_grob_label(right), "Right, %")
})

test_that("economist_2017_chart leaves a plot without y-axis titles alone", {
  p <- chart_plot() + ggplot2::labs(y = NULL)
  gt <- chart_gtable(p)
  expect_false(any(grepl("^economist-ylab", gt$layout$name)))
})

# The x-axis labels of a finished chart as they are drawn: draw it, then
# grid.force() runs every makeContent() in its viewport, as drawing does.
drawn_axis_labels <- function(p, width = 160 / 72, height = 120 / 72) {
  path <- withr::local_tempfile(fileext = ".png")
  grDevices::png(path, width = width, height = height, units = "in", res = 72)
  on.exit(grDevices::dev.off(), add = TRUE)
  grid::grid.newpage()
  grid::grid.draw(economist_2017_chart(p))
  grid::grid.force()
  labels <- grid::grid.get("economist-axis-labels", global = TRUE)
  if (inherits(labels, "grob")) {
    labels <- list(labels)
  }
  labels[[1]]$children[[1]]
}

test_that("economist_2017_chart keeps end-of-axis labels within the panel", {
  # An area chart reaches the panel's edges, so its first and last labels are
  # centred on them; centred, "1991" hangs past a 6pt margin and is cut off.
  d <- data.frame(x = 1991:2016, y = seq_len(26))
  p <- ggplot2::ggplot(d, ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_area() +
    ggplot2::scale_x_continuous(expand = c(0, 0), breaks = c(1991, 2000, 2016)) +
    theme_economist_2017()
  text <- drawn_axis_labels(p)
  expect_equal(text$label, c("1991", "2000", "2016"))
  expect_equal(text$hjust, c(0, 0.5, 1))
})

test_that("economist_2017_chart leaves axis labels that fit centred", {
  p <- ggplot2::ggplot(data.frame(x = 1:10, y = 1:10), ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_point() +
    ggplot2::scale_x_continuous(breaks = c(2, 5, 8)) +
    theme_economist_2017()
  expect_equal(drawn_axis_labels(p)$hjust, c(0.5, 0.5, 0.5))
})

# Sizes, typefaces and footnotes -----------------------------------------------------

test_that("economist_2017_size returns the guide's widths", {
  # p.4
  widths <- c(
    one_column = 160, two_column = 332, three_column = 504, leader = 117, free_exchange = 245,
    espresso = 160, special_half_column = 117, special_two_thirds_column = 160,
    special_one_column = 245, special_two_and_half_column = 332
  )
  for (nm in names(widths)) {
    expect_equal(economist_2017_size(nm, height = 100, units = "pt")[["width"]], widths[[nm]], info = nm)
  }
  expect_equal(economist_2017_size("one_column", height = 165), c(width = 160, height = 165) / 72)
})

test_that("economist_2017_size fixes the leader and Espresso heights", {
  expect_equal(economist_2017_size("leader", units = "pt"), c(width = 117, height = 83.5))
  expect_equal(economist_2017_size("espresso", units = "pt"), c(width = 160, height = 160))
  expect_equal(economist_2017_size("leader", height = 90, units = "pt")[["height"]], 90)
})

test_that("economist_2017_size needs a height where the guide gives none", {
  expect_error(economist_2017_size("one_column"), "height")
  expect_error(economist_2017_size("one_column", height = -1), "height")
  expect_error(economist_2017_size("tabloid", height = 100))
})

test_that("economist_2017_footnote follows the guide's order", {
  # p.5
  expect_equal(
    economist_2017_footnote(1:8),
    c("*", "\u2020", "\u2021", "\u00a7", "**", "\u2020\u2020", "\u2021\u2021", "\u00a7\u00a7")
  )
  expect_equal(economist_2017_footnote(1:8), ggthemes_data$economist_2017$footnotes)
  expect_equal(economist_2017_footnote(c(9, 12)), c("***", "\u00a7\u00a7\u00a7"))
  expect_error(economist_2017_footnote(0), "positive")
  expect_error(economist_2017_footnote(1.5), "whole")
})

test_that("economist_2017 typefaces map each weight to the theme", {
  typefaces <- ggthemes_data$economist_2017$typefaces
  expect_equal(typefaces$weight, c("bold", "bold", "medium", "regular", "light"))
  thm <- theme_economist_2017()
  for (i in seq_len(nrow(typefaces))) {
    for (el in strsplit(typefaces$elements[i], ", ")[[1]]) {
      expect_equal(ggplot2::calc_element(el, thm)$face, typefaces$face[i], info = el)
    }
  }
})

test_that("economist_2017_font picks the first installed family", {
  skip_if_not_installed("systemfonts")
  installed <- systemfonts::system_fonts()[["family"]][1]
  expect_equal(economist_2017_font(c("No Such Font 2017", installed)), installed)
  expect_equal(economist_2017_font("No Such Font 2017"), "sans")
  expect_equal(economist_2017_font("No Such Font 2017", fallback = "serif"), "serif")
  expect_equal(economist_2017_font(character()), "sans")
  expect_error(economist_2017_font(1), "families")
  expect_error(economist_2017_font(fallback = c("a", "b")), "fallback")
  expect_true(rlang::is_string(economist_2017_font()))
})

test_that("theme_economist_2017 defaults to economist_2017_font()", {
  expect_equal(theme_economist_2017()$text$family, economist_2017_font())
})

# Visual regression --------------------------------------------------------------

test_that("theme_economist_2017 draws correctly", {
  for (media in c("print", "web")) {
    p <- theme_test_plot() +
      ggplot2::scale_y_continuous(position = "right", guide = guide_axis_economist_2017()) +
      scale_colour_economist_2017(media) +
      # Pinned, so the snapshot does not depend on which fonts are installed.
      theme_economist_2017(media, base_family = "sans")
    expect_doppelganger(paste0("theme_economist_2017-", media), p)
    expect_doppelganger(
      paste0("economist_2017_chart-", media),
      economist_2017_chart(p, media)
    )
  }
})

test_that("economist_2017 palettes draw correctly", {
  print_orders <- lapply(
    c(bar_side = "bar_side", stacked = "stacked", line_side = "line_side", dot = "dot", pie = "pie"),
    function(type) economist_2017_pal("print", type = type)(6)
  )
  expect_doppelganger(
    "economist_2017_pal",
    swatch_plot(
      c(
        print_orders,
        list(
          bright = economist_2017_pal(set = "bright")(4),
          dark = economist_2017_pal(set = "dark")(3)
        )
      ),
      "economist_2017_pal()"
    )
  )
  expect_doppelganger(
    "economist_2017_gradient_pal",
    swatch_plot(ggthemes_data$economist_2017$web$sequential, "economist_2017_gradient_pal() stops")
  )
})
