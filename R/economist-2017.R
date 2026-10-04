#' Economist 2017 colour palette
#'
#' The categorical palettes of \emph{The Economist visual styleguide}
#' (v1.2, 4 May 2017), the design \emph{The Economist} introduced in 2017
#' and used until its 2024 redesign. Print and web use different hues, not
#' just different backgrounds, so pick the medium the chart is for.
#'
#' The print palette is not one fixed order. Each chart-type page of the
#' guide (pp.13-20) carries its own numbered colour order. They are
#' reorderings of the same six hues, and come in five distinct sequences,
#' chosen with `type`. The guide gives the web palette (p.12) as a single
#' row of nine colours, so `type` has no effect when `media = "web"`.
#'
#' @param media Either `"print"` or `"web"`.
#' @param set For `media = "print"` only. `"primary"` is the six-colour
#'   palette, in the order given by `type`. `"bright"` (four colours) and
#'   `"dark"` (three colours) are the guide's supporting sets "for
#'   multi-category charts where high contrast is needed" (p.11); they have
#'   no per-chart-type order, so `type` is ignored for them.
#' @param type For `media = "print"` and `set = "primary"` only: which chart
#'   type's colour order to use. `"bar_side"` is bar or column, side by side
#'   (p.13), and is the guide's default reading order; `"stacked"` is
#'   bar, column or line, stacked (pp.14, 16); `"line_side"` is line, side by
#'   side (p.15); `"dot"` is thermometer or scatter (pp.17-18); and `"pie"` is
#'   pie or doughnut (p.20).
#'
#' @return A palette function. It takes the number of colours `n` and
#'   returns a character vector of `n` hex colours, and can be used as the
#'   `palette` argument of [ggplot2::discrete_scale()].
#'
#' @references
#' \emph{The Economist visual styleguide}, v1.2, 4 May 2017 (internal;
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
  if (media == "web" && set != "primary") {
    cli::cli_abort(
      '{.arg set} {.val {set}} is only defined for {.code media = "print"}.'
    )
  }
  key <- if (media == "web") {
    "primary"
  } else if (set == "primary") {
    type
  } else {
    set
  }
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

#' Economist 2017 continuous colour palette
#'
#' Interpolates one of the "equal lightness colour scales" of \emph{The
#' Economist visual styleguide} (v1.2, 4 May 2017, p.12): six steps of one
#' hue, of even perceived lightness, for ordered and continuous data. Low
#' values get the lightest step. These are the guide's web ramps; it gives
#' none for print.
#'
#' @param hue One of `"red"`, `"blue"`, `"cyan"`, `"green"`, `"yellow"`,
#'   `"olive"`, `"purple"`, `"gold"` or `"grey"`.
#' @param direction `1` maps low values to the lightest step; `-1` reverses
#'   the ramp.
#'
#' @return A palette function. It takes a numeric vector of values between
#'   0 and 1 and returns hex colours, and can be used as the `palette`
#'   argument of [ggplot2::continuous_scale()].
#'
#' @references
#' \emph{The Economist visual styleguide}, v1.2, 4 May 2017 (internal;
#' Matt McLean), p.12.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_gradient_pal.R
economist_2017_gradient_pal <- function(hue = "blue", direction = 1) {
  ramps <- ggthemes::ggthemes_data[["economist_2017"]][["web"]][["sequential"]]
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

#' Economist 2017 colour scales
#'
#' Colour and fill scales for \emph{The Economist visual styleguide}
#' (v1.2, 4 May 2017). The discrete scales use [economist_2017_pal()]; the
#' `_c` scales are continuous and use [economist_2017_gradient_pal()].
#'
#' @inheritParams economist_2017_pal
#' @inheritParams economist_2017_gradient_pal
#' @param guide Type of legend. Use `"colourbar"` for a continuous colour
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
  guide = "colourbar",
  ...
) {
  continuous_scale(
    "colour",
    palette = economist_2017_gradient_pal(hue = hue, direction = direction),
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
  guide = "colourbar",
  ...
) {
  continuous_scale(
    "fill",
    palette = economist_2017_gradient_pal(hue = hue, direction = direction),
    guide = guide,
    ...
  )
}

#' Economist 2017 theme
#'
#' A theme for \emph{The Economist visual styleguide} (v1.2, 4 May 2017),
#' the chart design \emph{The Economist} introduced in 2017 and used until
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
#'   [economist_2017_furniture()], which also moves a web chart's key up
#'   beside the title.
#' * The guide sets charts in Econ Sans, which is not publicly available.
#'   Pass a narrow sans serif as `base_family`. Econ Sans's medium weight,
#'   used for panel and legend headings, is drawn plain.
#'
#' @param media Either `"print"` or `"web"`.
#' @param base_size Base font size, in points. Every size in the theme is
#'   relative to it.
#' @param base_family Base font family.
#' @param horizontal Draw horizontal gridlines, the guide's convention?
#'   Use `FALSE` for vertical gridlines on a horizontal bar chart.
#'
#' @return An object of class [ggplot2::theme()].
#'
#' @references
#' \emph{The Economist visual styleguide}, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.3-12.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-theme_economist_2017.R
theme_economist_2017 <- function(
  media = c("print", "web"),
  base_size = 10,
  base_family = "sans",
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
  # Outer margin: 6pt on every side for print (p.6); none at the sides for
  # web, with 5pt below the source line (p.7).
  plot_margin <- switch(
    media,
    print = m(6, 6, 6, 6),
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
    ## Axis numbers: Econ Sans Cnd light 7pt. Axis label: Cnd regular 7/7.5,
    ## centred under the axis.
    axis.text = element_text(size = rel(0.7)),
    axis.text.x = element_text(vjust = 1, margin = m(t = 1.5)),
    axis.text.x.top = element_text(vjust = 0, margin = m(b = 1.5)),
    axis.text.y = element_text(hjust = 1, margin = m(r = 2)),
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
    ## leaves room for the red marker economist_2017_furniture() draws.
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

#' Add Economist 2017 chart furniture
#'
#' Draws the parts of \emph{The Economist visual styleguide} (v1.2, 4 May
#' 2017) that sit outside anything [ggplot2::theme()] can set, around a plot
#' styled with [theme_economist_2017()]:
#'
#' * the red tab, 15pt by 5pt, above the title (pp.6-7);
#' * for web, the red rule across the top of the chart (p.7);
#' * a red marker, 10pt by 1pt, above each panel heading (p.10);
#' * for web, the key moved up to the right of the title and subtitle
#'   (p.7), instead of taking a row of its own above the panel.
#'
#' Sizes scale with the plot's base font size, as the theme's do, and the
#' tab is placed at the plot's own outer margin.
#'
#' @param plot A ggplot styled with [theme_economist_2017()].
#' @param media Either `"print"` or `"web"`. Use the same medium as the
#'   theme.
#'
#' @return A grob of class `ggthemes_furniture`. Print it to draw it, or pass
#'   it to [ggplot2::ggsave()]. Like a ggplot, it is laid out when drawn, so
#'   text is measured on the device it is drawn on. It is no longer a ggplot,
#'   though: add layers, scales and themes before calling this function.
#'
#' @references
#' \emph{The Economist visual styleguide}, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.6-7, 10.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-economist_2017_furniture.R
economist_2017_furniture <- function(plot, media = c("print", "web")) {
  if (!ggplot2::is_ggplot(plot)) {
    cli::cli_abort("{.arg plot} must be a ggplot, not {.obj_type_friendly {plot}}.")
  }
  media <- rlang::arg_match(media)
  # Built at draw time, in makeContent(), like a ggplot itself: the plot's
  # text is measured on the device it is drawn on, not on whichever device
  # happens to be open when this function is called.
  grid::gTree(plot = plot, media = media, cl = "ggthemes_furniture")
}

#' @exportS3Method grid::makeContent
makeContent.ggthemes_furniture <- function(x) {
  grid::setChildren(x, grid::gList(economist_2017_layout(x$plot, x$media)))
}

economist_2017_layout <- function(plot, media) {
  accent <- ggthemes::ggthemes_data[["economist_2017"]][[media]][["accent"]]
  theme <- ggplot2::complete_theme(plot$theme)
  k <- ggplot2::calc_element("text", theme)$size / 10
  plot_margin <- ggplot2::calc_element("plot.margin", theme)
  pt <- function(x) grid::unit(x * k, "pt")
  red <- grid::gpar(fill = accent, col = NA)

  gt <- ggplot2::ggplotGrob(plot)
  if (media == "web") {
    gt <- economist_2017_key_up(gt)
  }
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
  tab <- grid::rectGrob(
    x = plot_margin[4],
    y = grid::unit(1, "npc") - plot_margin[1],
    width = pt(15),
    height = pt(5),
    just = c("left", "top"),
    gp = red
  )
  gt <- everywhere(gt, tab, "economist-tab")

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
print.ggthemes_furniture <- function(x, newpage = TRUE, ...) {
  if (newpage) {
    grid::grid.newpage()
  }
  grid::grid.draw(x)
  invisible(x)
}
