#' Economist 2017 color palette
#'
#' The categorical palettes of *The Economist visual styleguide*
#' (v1.2, 4 May 2017), the design *The Economist* introduced in 2017
#' and used until its 2024 redesign. Print and web charts use the same
#' palettes: the guide's own web charts (pp.3, 7, 9, 24) are drawn in the
#' print colors and follow the print color orders.
#'
#' The palette is not one fixed order. Each chart-type page of the guide
#' (pp.13-20) carries its own numbered color order. They are reorderings of
#' the same six hues, and come in five distinct sequences, chosen with
#' `type`.
#'
#' @param media Either `"print"` or `"web"`. Both media have the same
#'   palettes; each reads its own complete spec in [ggthemes_data].
#' @param set `"primary"` is the six-color palette, in the order given by
#'   `type`. `"bright"` (four colors) and
#'   `"dark"` (three colors) are the guide's supporting sets "for
#'   multi-category charts where high contrast is needed" (p.11); they have
#'   no per-chart-type order, so `type` is ignored for them.
#' @param type For `set = "primary"` only: which chart
#'   type's color order to use. `"bar_side"` is bar or column, side by side
#'   (p.13), and is the guide's default reading order; `"stacked"` is
#'   bar, column or line, stacked (pp.14, 16); `"line_side"` is line, side by
#'   side (p.15); `"dot"` is thermometer or scatter (pp.17-18); and `"pie"` is
#'   pie or doughnut (p.20).
#'
#' @return A palette function. It takes the number of colors `n` and
#'   returns a character vector of `n` hex colors, and can be used as the
#'   `palette` argument of [ggplot2::discrete_scale()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.11-20.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_pal.R
economist_2017_pal <- function(
  media = c("print", "web"),
  set = c("primary", "bright", "dark"),
  type = c("bar_side", "stacked", "line_side", "dot", "pie")
) {
  media <- rlang::arg_match(media)
  set <- rlang::arg_match(set)
  type <- rlang::arg_match(type)
  key <- if (set == "primary") type else set
  spec <- ggthemes::ggthemes_data[["economist_2017"]][[media]]
  colors <- spec[["qualitative"]][[key]][["value"]]
  max_n <- length(colors)
  f <- function(n) {
    check_pal_n(n, max_n)
    colors[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Economist 2017 continuous color palette
#'
#' Interpolates one of the "equal lightness colour scales" of *The
#' Economist visual styleguide* (v1.2, 4 May 2017, p.12): six steps of one
#' hue, of even perceived lightness, for ordered and continuous data. Low
#' values get the lightest step. The guide gives them on its web palette page;
#' print and web use the same ramps.
#'
#' @inheritParams economist_2017_pal
#' @param hue One of `"red"`, `"blue"`, `"cyan"`, `"green"`, `"yellow"`,
#'   `"olive"`, `"purple"`, `"gold"` or `"grey"`.
#' @param direction `1` maps low values to the lightest step; `-1` reverses
#'   the ramp.
#'
#' @return A palette function. It takes a numeric vector of values between
#'   0 and 1 and returns hex colors, and can be used as the `palette`
#'   argument of [ggplot2::continuous_scale()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), p.12.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_gradient_pal.R
economist_2017_gradient_pal <- function(hue = "blue", direction = 1, media = c("print", "web")) {
  media <- rlang::arg_match(media)
  ramps <- ggthemes::ggthemes_data[["economist_2017"]][[media]][["sequential"]]
  hue <- rlang::arg_match(hue, names(ramps))
  if (!direction %in% c(-1, 1)) {
    cli::cli_abort("{.arg direction} must be 1 or -1, not {.val {direction}}.")
  }
  colors <- ramps[[hue]]
  if (direction == -1) {
    colors <- rev(colors)
  }
  scales::pal_gradient_n(colors)
}

#' Economist 2017 color scales
#'
#' Color and fill scales for *The Economist visual styleguide*
#' (v1.2, 4 May 2017). The discrete scales use [economist_2017_pal()]; the
#' `_c` scales are continuous and use [economist_2017_gradient_pal()].
#'
#' @inheritParams economist_2017_pal
#' @inheritParams economist_2017_gradient_pal
#' @param guide Type of legend. Use `"colourbar"` for a continuous color
#'   bar, or `"legend"` for a discrete legend.
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()].
#'
#' @return A ggplot2 scale object.
#'
#' @family economist 2017
#' @rdname scale_economist_2017
#' @export
#' @example inst/examples/ex-scale_economist_2017.R
scale_colour_economist_2017 <- function(
  media = c("print", "web"),
  set = c("primary", "bright", "dark"),
  type = c("bar_side", "stacked", "line_side", "dot", "pie"),
  ...
) {
  discrete_scale(
    "colour",
    palette = economist_2017_pal(media = media, set = set, type = type),
    ...
  )
}

#' @rdname scale_economist_2017
#' @export
scale_color_economist_2017 <- scale_colour_economist_2017

#' @rdname scale_economist_2017
#' @export
scale_fill_economist_2017 <- function(
  media = c("print", "web"),
  set = c("primary", "bright", "dark"),
  type = c("bar_side", "stacked", "line_side", "dot", "pie"),
  ...
) {
  discrete_scale(
    "fill",
    palette = economist_2017_pal(media = media, set = set, type = type),
    ...
  )
}

#' @rdname scale_economist_2017
#' @export
scale_colour_economist_2017_c <- function(
  hue = "blue",
  direction = 1,
  media = c("print", "web"),
  guide = "colourbar",
  ...
) {
  continuous_scale(
    "colour",
    palette = economist_2017_gradient_pal(hue = hue, direction = direction, media = media),
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_2017
#' @export
scale_color_economist_2017_c <- scale_colour_economist_2017_c

#' @rdname scale_economist_2017
#' @export
scale_fill_economist_2017_c <- function(
  hue = "blue",
  direction = 1,
  media = c("print", "web"),
  guide = "colourbar",
  ...
) {
  continuous_scale(
    "fill",
    palette = economist_2017_gradient_pal(hue = hue, direction = direction, media = media),
    guide = guide,
    ...
  )
}

#' Economist 2017 theme
#'
#' A theme for *The Economist visual styleguide* (v1.2, 4 May 2017),
#' the chart design *The Economist* introduced in 2017 and used until
#' its 2024 redesign. It has print and web variants: print charts sit on a
#' pale blue ground with a 6pt margin, web charts on white with none.
#'
#' The guide specifies a standard chart in points (pp.6-7): a 9.5pt bold
#' title, 8pt subtitle, 7.5pt legend and panel headings, 7pt axis labels and
#' a 6.5pt source line in 75% black; 0.5pt gridlines and baseline; and 0.4pt
#' tick marks, 5pt long, hanging below the baseline. Every size here,
#' including rule weights, margins and spacing, is expressed relative to
#' `base_size`, so these are the guide's sizes at the default
#' `base_size = 10` and keep their proportions at any other.
#'
#' At `base_size = 10` the type is the size the guide sets it, which suits a
#' chart drawn at the guide's own widths -- 160pt (2.2in) for one print
#' column, 332pt (4.6in) for two. On a larger figure, raise `base_size` in
#' proportion.
#'
#' Several conventions of the guide are not theme elements:
#'
#' * The value axis is on the right, with its labels sitting on their
#'   gridlines inside the panel. Use
#'   `scale_y_continuous(position = "right", guide = guide_axis_economist())`.
#' * The red tab above the title, the red rule across the top of a web
#'   chart, and the red marker above each panel heading are added by
#'   [economist_2017_chart()], which also moves a web chart's key up
#'   beside the title, and the y-axis titles from beside the panel to above
#'   it, where the guide sets them (p.10).
#' * The guide sets charts in Econ Sans, which is not publicly available.
#'   By default the theme uses the closest installed substitute, chosen by
#'   [economist_2017_font()]. Econ Sans's medium weight, used for panel and
#'   legend headings, is drawn plain.
#'
#' @param media Either `"print"` or `"web"`.
#' @param base_size Base font size, in points. Every size in the theme is
#'   relative to it.
#' @param base_family Base font family. The default, [economist_2017_font()],
#'   is Fira Sans Condensed or Roboto Condensed if either is installed, and
#'   otherwise `"sans"`. Base R's `pdf()` and `postscript()` devices know only
#'   their own font database; with them, use [grDevices::cairo_pdf()] or a
#'   'ragg' device, or pass `base_family = "sans"`.
#' @param horizontal Draw horizontal gridlines, the guide's convention?
#'   Use `FALSE` for vertical gridlines on a horizontal bar chart.
#'
#' @return An object of class [ggplot2::theme()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.3-12.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-theme_economist_2017.R
theme_economist_2017 <- function(
  media = c("print", "web"),
  base_size = 10,
  base_family = economist_2017_font(),
  horizontal = TRUE
) {
  media <- rlang::arg_match(media)
  spec <- ggthemes::ggthemes_data[["economist_2017"]][[media]]
  # Lengths are given in the guide's points at a 10pt base and scale with
  # base_size, like the type.
  pt <- function(x) unit(x * base_size / 10, "pt")
  m <- function(t = 0, r = 0, b = 0, l = 0) {
    k <- base_size / 10
    margin(t * k, r * k, b * k, l * k, "pt")
  }
  rule <- economist_2017_linewidth(0.5, base_size)
  # Outer margin: 6pt at the sides and bottom for print (p.6); none at the
  # sides for web, with 5pt below the source line (p.7). Neither has one at
  # the top: the red tab sits on the chart's top edge, and the title's own
  # top margin leaves room for it.
  plot_margin <- switch(
    media,
    print = m(0, 6, 6, 6),
    web = m(0, 0, 3.5, 0)
  )
  ret <- theme(
    line = element_line(colour = spec[["text"]], linewidth = rule, linetype = 1, lineend = "butt"),
    rect = element_rect(fill = spec[["ground"]], colour = NA, linewidth = rule, linetype = 0),
    text = element_text(
      family = base_family,
      face = "plain",
      colour = spec[["text"]],
      size = base_size,
      lineheight = 1,
      hjust = 0.5,
      vjust = 0.5,
      angle = 0,
      margin = m()
    ),
    ## Axes (p.6). Only the x axis is ruled, in black, which the guide keeps
    ## for the baseline (p.18). Ticks hang below it: 0.4pt, 5pt major and 3pt
    ## minor. The value axis has neither line nor ticks.
    ## (Set on the parents and blanked on y: in a complete theme a blank
    ## parent would blank the x elements too.)
    axis.line = element_line(colour = spec[["baseline"]], linewidth = rel(1)),
    axis.line.y = element_blank(),
    axis.ticks = element_line(colour = spec[["baseline"]], linewidth = rel(0.8)),
    axis.ticks.y = element_blank(),
    axis.ticks.length = pt(5),
    axis.ticks.length.y = unit(0, "pt"),
    axis.minor.ticks.length = rel(0.6),
    ## A value axis along the top, as on a horizontal bar chart, is numbers
    ## over gridlines only: no rule and no ticks (p.13).
    axis.line.x.top = element_blank(),
    axis.ticks.x.top = element_blank(),
    axis.ticks.length.x.top = unit(0, "pt"),
    axis.minor.ticks.length.x.top = unit(0, "pt"),
    ## Axis numbers: Econ Sans Cnd light 7pt. Axis label: Cnd regular 7/7.5,
    ## centred under the axis.
    axis.text = element_text(size = rel(0.7)),
    axis.text.x = element_text(vjust = 1, margin = m(t = 1.5)),
    axis.text.x.top = element_text(vjust = 0, margin = m(b = 2)),
    ## Category labels on a left axis are ranged left, flush with the chart's
    ## edge (p.13).
    axis.text.y = element_text(hjust = 0, margin = m(r = 2)),
    axis.text.y.right = element_text(hjust = 0, margin = m(l = 2)),
    axis.title = element_text(size = rel(0.7), lineheight = 7.5 / 7),
    axis.title.x = element_text(margin = m(t = 0.5)),
    axis.title.x.top = element_text(margin = m(b = 0.5)),
    ## The guide never rotates a value-axis title; units sit horizontally at
    ## the top of the axis (p.10).
    axis.title.y = element_text(angle = 0, vjust = 1, margin = m(r = 3)),
    axis.title.y.right = element_text(angle = 0, vjust = 1, margin = m(l = 3)),
    ## Legend (p.6): Cnd medium 7.5/9 heading over Cnd light 7.5/9 keys, in a
    ## row under the subtitle, flush left for print. Web puts the key at the
    ## top right (p.7).
    legend.background = element_blank(),
    legend.key = element_blank(),
    ## Print keys are short strokes (p.6); web keys are wide bars (p.7).
    legend.key.height = pt(4.5),
    legend.key.width = pt(switch(media, print = 4.5, web = 10)),
    legend.key.spacing = pt(8),
    legend.key.spacing.y = pt(1.5),
    legend.text = element_text(size = rel(0.75), lineheight = 9 / 7.5, margin = m(l = 2.5)),
    legend.title = element_text(size = rel(0.75), lineheight = 9 / 7.5, hjust = 0, margin = m(b = 2.5)),
    legend.title.position = "top",
    legend.position = "top",
    legend.direction = "horizontal",
    legend.byrow = TRUE,
    legend.justification = switch(media, print = "left", web = "right"),
    legend.location = "plot",
    legend.margin = m(0, 0, 0, 0),
    legend.box.spacing = pt(7.5),
    legend.ticks.length = rel(0.2),
    ## Panel. The ground runs under the whole chart; there is no separate
    ## panel colour and no border (p.3).
    panel.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_line(colour = spec[["grid"]], linewidth = rel(1)),
    panel.grid.minor = element_blank(),
    panel.ontop = FALSE,
    ## 24pt between panels side by side, 15pt between stacked panels (p.10).
    panel.spacing.x = pt(24),
    panel.spacing.y = pt(15),
    ## Panel headings (p.10): Cnd medium 7.5/9, flush left. The 3.5pt above
    ## leaves room for the red marker economist_2017_chart() draws.
    strip.background = element_blank(),
    strip.clip = "off",
    strip.placement = "outside",
    strip.text = element_text(
      size = rel(0.75),
      lineheight = 9 / 7.5,
      hjust = 0,
      margin = m(t = 3.5, b = 3)
    ),
    strip.text.y = element_text(angle = -90, hjust = 0.5),
    strip.text.y.left = element_text(angle = 90, hjust = 0.5),
    strip.switch.pad.grid = pt(3),
    strip.switch.pad.wrap = pt(3),
    ## Title block (p.6): bold 9.5/11 title, Cnd regular 8/9.5 subtitle,
    ## Cnd light 6.5pt source in 75% black, all flush with the chart's left
    ## edge. The title starts 10pt down, below the 5pt tab.
    plot.background = element_rect(fill = spec[["ground"]], colour = NA),
    plot.title = element_text(
      size = rel(0.95),
      face = "bold",
      lineheight = 11 / 9.5,
      hjust = 0,
      vjust = 1,
      margin = m(t = 10, b = 3.5)
    ),
    plot.subtitle = element_text(
      size = rel(0.8),
      lineheight = 9.5 / 8,
      hjust = 0,
      vjust = 1,
      ## Print keys sit under the subtitle, with legend.box.spacing below
      ## them; web keys sit beside the title (p.7), so the subtitle makes
      ## the whole 15pt gap down to the plot itself.
      margin = m(b = switch(media, print = 7.5, web = 13))
    ),
    plot.caption = element_text(
      size = rel(0.65),
      colour = spec[["source"]],
      hjust = 0,
      vjust = 1,
      margin = m(t = 5.5)
    ),
    plot.tag = element_text(size = rel(0.95), face = "bold", hjust = 0, vjust = 1),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.tag.position = "topleft",
    plot.margin = plot_margin,
    complete = TRUE
  )
  if (horizontal) {
    ret <- ret + theme(panel.grid.major.x = element_blank())
  } else {
    ret <- ret + theme(panel.grid.major.y = element_blank())
  }
  ret
}

# The guide gives rule weights in points; ggplot2's `linewidth` is in
# millimetres, drawn as `lwd = linewidth * .pt`, and grid draws `lwd = 1` as
# 1/96in, which is 0.75pt. Weights scale with base_size like everything else.
economist_2017_linewidth <- function(pt, base_size) {
  pt * (base_size / 10) / (ggplot2::.pt * 0.75)
}

#' Finish an Economist 2017 chart
#'
#' Finishes a plot styled with [theme_economist_2017()] as a chart of
#' *The Economist visual styleguide* (v1.2, 4 May 2017). It draws what
#' sits outside anything [ggplot2::theme()] can set, and lays the plot out as
#' the guide does:
#'
#' * the red tab, 15pt by 5pt, above the title (pp.6-7);
#' * for web, the red rule across the top of the chart (p.7);
#' * a red marker, 10pt by 1pt, above each panel heading (p.10);
#' * for web, the key moved up to the right of the title and subtitle
#'   (p.7), instead of taking a row of its own above the panel;
#' * the y-axis titles moved from beside the panels to above them, set
#'   horizontally over their own axis: a left-hand title ranged left and a
#'   right-hand one ranged right (p.10);
#' * an x-axis label that would hang past the panel's edge ranged in flush
#'   with it, as when the data run to the edge of an area chart;
#' * optionally, a footnote set right on the source line (pp.6-7), and a
#'   number box at the top right, for charts referred to by number in the
#'   text (p.25).
#'
#' Sizes scale with the plot's base font size, as the theme's do, and the
#' tab is placed at the plot's own outer margin.
#'
#' @param plot A ggplot styled with [theme_economist_2017()].
#' @param media Either `"print"` or `"web"`. Use the same medium as the
#'   theme.
#' @param footnote Text for the footnote, or `NULL` for none. It is set in
#'   the style of the source line (the theme's `plot.caption`), ranged right.
#'   Start it with the symbol from [economist_2017_footnote()] that marks the
#'   annotated text. A long source and footnote can overprint; break one of
#'   them over two lines.
#' @param number The chart's number, or `NULL` for none, drawn bold in a
#'   10pt box at the top right of the chart, white on the box colour (p.25).
#' @param tab Width and height of the red tab, in points. The standard chart
#'   uses `c(15, 5)` (p.6); a leader block uses a 4pt tab (p.8).
#'
#' @return A grob of class `ggthemes_economist_chart`. Print it to draw it, or pass
#'   it to [ggplot2::ggsave()]. Like a ggplot, it is laid out when drawn, so
#'   text is measured on the device it is drawn on. It is no longer a ggplot,
#'   though: add layers, scales and themes before calling this function.
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.6-7, 10.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_chart.R
economist_2017_chart <- function(
  plot,
  media = c("print", "web"),
  footnote = NULL,
  number = NULL,
  tab = c(15, 5)
) {
  if (!ggplot2::is_ggplot(plot)) {
    cli::cli_abort("{.arg plot} must be a ggplot, not {.obj_type_friendly {plot}}.")
  }
  media <- rlang::arg_match(media)
  if (!is.null(footnote) && !rlang::is_string(footnote)) {
    cli::cli_abort("{.arg footnote} must be a single string or {.code NULL}.")
  }
  if (!is.null(number) && length(number) != 1) {
    cli::cli_abort("{.arg number} must be a single value or {.code NULL}.")
  }
  if (!is.numeric(tab) || length(tab) != 2 || any(tab < 0)) {
    cli::cli_abort("{.arg tab} must be two non-negative numbers: a width and a height in points.")
  }
  # The footnote shares the source line, so the plot needs one to share.
  if (!is.null(footnote) && is.null(plot$labels$caption)) {
    plot <- plot + ggplot2::labs(caption = " ")
  }
  # Built at draw time, in makeContent(), like a ggplot itself: the plot's
  # text is measured on the device it is drawn on, not on whichever device
  # happens to be open when this function is called.
  grid::gTree(
    plot = plot,
    media = media,
    footnote = footnote,
    number = number,
    tab = tab,
    cl = "ggthemes_economist_chart"
  )
}

#' @exportS3Method grid::makeContent
makeContent.ggthemes_economist_chart <- function(x) {
  gt <- economist_2017_layout(x$plot, x$media, x$footnote, x$number, x$tab)
  gt <- economist_2017_edge_labels(gt)
  grid::setChildren(x, grid::gList(gt))
}

# A label at the end of an x axis is centred on its break, so when the data
# reach the panel's edge -- an area chart, say -- half of it hangs past the
# panel. The outer margin is narrower than half a year label, so it is cut
# off at the chart's edge; and the guide never lets labels hang past the
# panel anyway. Wrap the labels of every top and bottom axis so that, when
# drawn, a label that would cross the panel's edge is ranged in flush with it
# instead: the first ranged left, the last ranged right. Labels that fit are
# untouched.
economist_2017_edge_labels <- function(gt) {
  wrap <- function(grob) {
    if (inherits(grob, "text")) {
      return(grid::gTree(text = grob, name = "economist-axis-labels", cl = "ggthemes_edge_text"))
    }
    if (inherits(grob, "gtable")) {
      grob$grobs <- lapply(grob$grobs, wrap)
    } else if (inherits(grob, "gTree")) {
      grob$children <- do.call(grid::gList, lapply(grob$children, wrap))
    }
    grob
  }
  axes <- which(grepl("^axis-[bt]", gt$layout$name))
  gt$grobs[axes] <- lapply(gt$grobs[axes], wrap)
  gt
}

#' @exportS3Method grid::makeContent
makeContent.ggthemes_edge_text <- function(x) {
  text <- x$text
  n <- length(text$label)
  rotated <- !is.null(text$rot) && any(text$rot %% 360 != 0)
  if (n == 0 || rotated) {
    return(grid::setChildren(x, grid::gList(text)))
  }
  inches <- function(u) grid::convertX(u, "in", valueOnly = TRUE)
  # The axis is drawn in the panel's column, so 0 and 1 npc are the panel's
  # edges.
  at <- inches(text$x)
  panel <- inches(grid::unit(c(0, 1), "npc"))
  width <- vapply(
    seq_len(n),
    function(i) {
      label <- grid::textGrob(text$label[i], gp = text$gp)
      grid::convertWidth(grid::grobWidth(label), "in", valueOnly = TRUE)
    },
    numeric(1)
  )
  hjust <- rep_len(text$hjust %||% 0.5, n)
  left <- at - width * hjust < panel[1]
  hjust[left] <- pmax(0, pmin(hjust[left], (at[left] - panel[1]) / width[left]))
  right <- at + width * (1 - hjust) > panel[2]
  hjust[right] <- pmin(1, pmax(hjust[right], 1 - (panel[2] - at[right]) / width[right]))
  text$hjust <- hjust
  grid::setChildren(x, grid::gList(text))
}

economist_2017_layout <- function(plot, media, footnote = NULL, number = NULL, tab = c(15, 5)) {
  spec <- ggthemes::ggthemes_data[["economist_2017"]][[media]]
  accent <- spec[["accent"]]
  theme <- ggplot2::complete_theme(plot$theme)
  k <- ggplot2::calc_element("text", theme)$size / 10
  plot_margin <- ggplot2::calc_element("plot.margin", theme)
  pt <- function(x) grid::unit(x * k, "pt")
  red <- grid::gpar(fill = accent, col = NA)

  gt <- ggplot2::ggplotGrob(plot)
  if (media == "web") {
    gt <- economist_2017_key_up(gt)
  }
  gt <- economist_2017_titles_up(gt, theme, k)
  everywhere <- function(gt, grob, name) {
    gtable::gtable_add_grob(
      gt,
      grob,
      t = 1,
      l = 1,
      b = nrow(gt),
      r = ncol(gt),
      clip = "off",
      z = Inf,
      name = name
    )
  }
  if (media == "web") {
    rule <- grid::rectGrob(
      x = 0,
      y = 1,
      width = grid::unit(1, "npc"),
      height = pt(0.5),
      just = c("left", "top"),
      gp = red
    )
    gt <- everywhere(gt, rule, "economist-rule")
  }
  tab_grob <- grid::rectGrob(
    x = plot_margin[4],
    # On the chart's top edge, whatever the top margin (pp.6-7).
    y = grid::unit(1, "npc"),
    width = pt(tab[1]),
    height = pt(tab[2]),
    just = c("left", "top"),
    gp = red
  )
  gt <- everywhere(gt, tab_grob, "economist-tab")

  if (!is.null(footnote)) {
    caption <- which(gt$layout$name == "caption")
    if (length(caption) == 1) {
      cell <- gt$layout[caption, ]
      # The source starts on the first line of its row and the footnote ends
      # on the last (pp.6-7, 15): a one-line footnote sits level with the last
      # line of a two-line source. The row grows to the taller of the two.
      grob <- ggplot2::element_grob(
        ggplot2::calc_element("plot.caption", theme),
        label = footnote,
        x = grid::unit(1, "npc"),
        hjust = 1,
        vjust = 0,
        margin_y = TRUE
      )
      gt$heights[cell$t] <- grid::unit.pmax(gt$heights[cell$t], grid::grobHeight(grob))
      gt <- gtable::gtable_add_grob(
        gt,
        grob,
        t = cell$t,
        l = cell$l,
        b = cell$b,
        r = cell$r,
        clip = "off",
        name = "economist-footnote"
      )
    }
  }

  if (!is.null(number)) {
    box_fill <- spec[[if (media == "print") "number_box" else "box"]]
    box_x <- grid::unit(1, "npc") - plot_margin[2]
    box_y <- grid::unit(1, "npc") - plot_margin[1] - pt(10)
    box <- grid::gTree(
      children = grid::gList(
        grid::rectGrob(
          x = box_x,
          y = box_y,
          width = pt(10),
          height = pt(10),
          just = c("right", "top"),
          gp = grid::gpar(fill = box_fill, col = NA)
        ),
        grid::textGrob(
          as.character(number),
          x = box_x - pt(5),
          y = box_y - pt(5),
          # A white numeral on the box, as on p.25.
          gp = grid::gpar(
            col = "white",
            fontsize = 7.5 * k,
            fontface = "bold",
            fontfamily = ggplot2::calc_element("text", theme)$family
          )
        )
      )
    )
    gt <- everywhere(gt, box, "economist-number")
  }

  for (i in which(grepl("^strip-t", gt$layout$name))) {
    marker <- grid::rectGrob(
      x = 0,
      y = 1,
      width = pt(10),
      height = pt(1),
      just = c("left", "top"),
      gp = red
    )
    cell <- gt$layout[i, ]
    gt <- gtable::gtable_add_grob(
      gt,
      marker,
      t = cell$t,
      l = cell$l,
      b = cell$t,
      r = cell$r,
      clip = "off",
      z = Inf,
      name = paste0("economist-marker-", cell$name)
    )
  }
  gt
}

# Move the y-axis titles from columns beside the panels into a row above them,
# set horizontally over their own axis: a left title ranged left, a right one
# ranged right (p.10). The row leaves room for the top value label, which
# guide_axis_economist() draws above the top gridline, and the emptied
# columns close up so the panels take their width.
economist_2017_titles_up <- function(gt, theme, k) {
  sides <- c(l = "left", r = "right")
  found <- lapply(names(sides), function(side) {
    i <- which(gt$layout$name == paste0("ylab-", side))
    if (length(i) != 1 || inherits(gt$grobs[[i]], "zeroGrob")) {
      return(NULL)
    }
    label <- economist_2017_grob_label(gt$grobs[[i]])
    if (is.null(label) || !nzchar(paste(label, collapse = ""))) {
      return(NULL)
    }
    list(index = i, side = sides[[side]], label = label)
  })
  found <- Filter(Negate(is.null), found)
  if (!length(found)) {
    return(gt)
  }
  panels <- gt$layout[grepl("^panel", gt$layout$name), ]
  top <- min(panels$t)
  left <- min(panels$l)
  right <- max(panels$r)

  titles <- lapply(found, function(f) {
    element <- ggplot2::calc_element(paste0("axis.title.y.", f$side), theme)
    ggplot2::element_grob(
      element,
      label = f$label,
      x = grid::unit(if (f$side == "left") 0 else 1, "npc"),
      y = grid::unit(9 * k, "pt"),
      hjust = if (f$side == "left") 0 else 1,
      vjust = 0,
      angle = 0,
      margin_x = FALSE,
      margin_y = FALSE
    )
  })
  # 9pt clears the top value label: 7pt type set 1pt above the gridline.
  heights <- do.call(grid::unit.c, lapply(titles, grid::grobHeight))
  gt <- gtable::gtable_add_rows(gt, max(heights) + grid::unit(9 * k, "pt"), pos = top - 1)

  # Close the side columns and drop the old titles.
  old <- vapply(found, `[[`, integer(1), "index")
  gt$widths[gt$layout$l[old]] <- grid::unit(0, "pt")
  gt$grobs <- gt$grobs[-old]
  gt$layout <- gt$layout[-old, ]

  for (j in seq_along(found)) {
    gt <- gtable::gtable_add_grob(
      gt,
      titles[[j]],
      t = top,
      l = left,
      b = top,
      r = right,
      clip = "off",
      name = paste0("economist-ylab-", found[[j]]$side)
    )
  }
  gt
}

# The text of an axis title grob, wherever ggplot2 nests it.
economist_2017_grob_label <- function(grob) {
  if (!is.null(grob$label)) {
    return(grob$label)
  }
  for (child in grob$children) {
    label <- economist_2017_grob_label(child)
    if (!is.null(label)) {
      return(label)
    }
  }
  NULL
}

# Move a top key from its own row into the rows of the title and subtitle,
# and close the row it leaves behind. The theme already justifies the key
# to the right, so it lands beside the title.
economist_2017_key_up <- function(gt) {
  layout <- gt$layout
  key <- which(layout$name == "guide-box-top")
  heading <- which(layout$name %in% c("title", "subtitle"))
  if (length(key) != 1 || length(heading) == 0 || inherits(gt$grobs[[key]], "zeroGrob")) {
    return(gt)
  }
  old_row <- layout$t[key]
  gt$layout$t[key] <- min(layout$t[heading])
  gt$layout$b[key] <- max(layout$b[heading])
  gt$layout$l[key] <- min(layout$l[heading])
  gt$layout$r[key] <- max(layout$r[heading])
  # The key's row and the legend.box.spacing row below it.
  gt$heights[old_row] <- grid::unit(0, "pt")
  if (old_row < nrow(gt)) {
    gt$heights[old_row + 1] <- grid::unit(0, "pt")
  }
  gt
}

#' @export
print.ggthemes_economist_chart <- function(x, newpage = TRUE, ...) {
  if (newpage) {
    grid::grid.newpage()
  }
  grid::grid.draw(x)
  invisible(x)
}

#' Choose a font for the Economist 2017 theme
#'
#' The guide sets charts in Econ Sans Condensed, which is not publicly
#' available. `economist_2017_font()` returns the first of `families` that
#' is installed, and `fallback` if none is. The defaults are the closest
#' openly licensed substitutes: Fira Sans Condensed, a humanist sans of the
#' same width class, then Roboto Condensed.
#'
#' A font counts as installed if 'systemfonts', which the 'ragg' and
#' 'svglite' devices use to find fonts, lists it among the system fonts or
#' the fonts registered with [systemfonts::register_font()]. Without
#' 'systemfonts', the result is always `fallback`.
#'
#' @param families Font families to try, in order of preference.
#' @param fallback The family to use if none of `families` is installed.
#'
#' @return A single font family name, for `base_family` of
#'   [theme_economist_2017()] or the `family` of a text geom.
#'
#' @family economist 2017
#' @export
#' @examples
#' economist_2017_font()
#' # Prefer another font, falling back to the defaults
#' economist_2017_font(c("Source Sans 3", "Fira Sans Condensed", "Roboto Condensed"))
economist_2017_font <- function(
  families = c("Fira Sans Condensed", "Roboto Condensed"),
  fallback = "sans"
) {
  if (!is.character(families)) {
    cli::cli_abort("{.arg families} must be a character vector.")
  }
  if (!rlang::is_string(fallback)) {
    cli::cli_abort("{.arg fallback} must be a single string.")
  }
  if (!length(families) || !rlang::is_installed("systemfonts")) {
    return(fallback)
  }
  installed <- c(systemfonts::system_fonts()[["family"]], systemfonts::registry_fonts()[["family"]])
  found <- families[families %in% installed]
  if (length(found)) found[[1]] else fallback
}

#' Economist 2017 chart sizes
#'
#' The chart sizes of *The Economist visual styleguide* (v1.2, 4 May
#' 2017, p.4), for drawing a chart at the size the guide specifies: pass the
#' result to [ggplot2::ggsave()], or use it for a knitr figure's `fig.width`
#' and `fig.height`.
#'
#' The guide fixes the width of every size, and the height of only two: the
#' leader block (83.5pt, p.4) and the Espresso lead image (160pt, p.9). For
#' the others, give the height. All the sizes, with the web widths the guide
#' gives for some of them, are in `ggthemes_data$economist_2017$sizes`.
#'
#' | `size` | Width (pt) | Height (pt) |
#' |---|---|---|
#' | `"one_column"` | 160 | |
#' | `"two_column"` | 332 | |
#' | `"three_column"` | 504 | |
#' | `"leader"` | 117 | 83.5 |
#' | `"free_exchange"` | 245 | |
#' | `"espresso"` | 160 | 160 |
#' | `"special_half_column"` | 117 | |
#' | `"special_two_thirds_column"` | 160 | |
#' | `"special_one_column"` | 245 | |
#' | `"special_two_and_half_column"` | 332 | |
#'
#' The `special_` sizes are for special reports, Technology Quarterly and
#' essays, which are set on a different grid.
#'
#' @param size The chart size; see the table.
#' @param height The chart's height, in points. Required unless `size` has a
#'   fixed height, which it then overrides.
#' @param units The units of the result: `"in"` (inches, as
#'   [ggplot2::ggsave()] and knitr expect) or `"pt"` (points).
#'
#' @return A named numeric vector, `c(width = , height = )`, in `units`.
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.4, 8-9.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_size.R
economist_2017_size <- function(size = "one_column", height = NULL, units = c("in", "pt")) {
  sizes <- ggthemes::ggthemes_data[["economist_2017"]][["sizes"]]
  size <- rlang::arg_match(size, sizes[["size"]])
  units <- rlang::arg_match(units)
  spec <- sizes[sizes[["size"]] == size, ]
  if (is.null(height)) {
    height <- spec[["height"]]
    if (is.na(height)) {
      cli::cli_abort(c(
        "{.arg height} is required for {.val {size}}.",
        i = "The guide fixes the height only of {.val leader} and {.val espresso} charts."
      ))
    }
  } else if (!is.numeric(height) || length(height) != 1 || height <= 0) {
    cli::cli_abort("{.arg height} must be a single positive number of points.")
  }
  out <- c(width = spec[["width"]], height = height)
  if (units == "in") {
    out <- out / 72
  }
  out
}

#' Economist 2017 footnote symbols
#'
#' The footnote symbols of *The Economist visual styleguide* (v1.2, 4 May
#' 2017, p.5), in their order of use: `*`, `†`, `‡`, `§`, then the same four
#' doubled. The guide stops at eight; beyond that the pattern continues,
#' tripling the symbols and so on. The symbols are also in
#' `ggthemes_data$economist_2017$footnotes`.
#'
#' @param n Which footnotes, counting from 1.
#'
#' @return A character vector of symbols, one for each element of `n`.
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), p.5.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_footnote.R
economist_2017_footnote <- function(n) {
  if (!is.numeric(n) || anyNA(n) || any(n < 1) || any(n != trunc(n))) {
    cli::cli_abort("{.arg n} must be positive whole numbers.")
  }
  symbols <- ggthemes::ggthemes_data[["economist_2017"]][["footnotes"]][1:4]
  strrep(symbols[(n - 1) %% 4 + 1], (n - 1) %/% 4 + 1)
}
