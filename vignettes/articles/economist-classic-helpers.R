# Helpers shared by the classic-vs-2017 articles. Sourced from the articles as
# `source("economist-classic-helpers.R")`; nothing here is exported.

# The red of the classic charts' tab and rules: Economist red, looked up by name among the ground colors. The archived
# images show it anywhere from #ED111A to #E11B17, depending on the export.
classic_tab_colour <- function() {
  bg <- ggthemes_data$economist$bg
  bg$value[bg$name == "economist red"]
}

# The classic chart (pre-2017) has a red tab too, but a vertical one flush with
# the left edge, at the top of the chart; the 2017 guide calls the change a
# "rotated tag" (p.3). `theme_economist()` cannot draw it, so this draws it
# around a finished plot, as `economist_2017_chart()` does for the 2017 tab. The
# tab is 5pt wide by 15pt tall, the 2017 tab turned through a right angle. In
# the chart corpus (2012 to 2018) it is on nearly every classic chart, flush
# left and flush with the top edge, at a constant size in points.
classic_chart <- function(plot, tab = c(5, 15), colour = classic_tab_colour(), axis_titles = NULL) {
  # Not scaled with the theme's base size: `classic_size` shrinks the type to fit
  # a 160pt chart, but the chart, and so its tab, is the size it is.
  tab_grob <- grid::rectGrob(
    x = grid::unit(0, "npc"),
    y = grid::unit(1, "npc"),
    width = grid::unit(tab[[1]], "pt"),
    height = grid::unit(tab[[2]], "pt"),
    just = c("left", "top"),
    gp = grid::gpar(fill = colour, col = NA)
  )
  # The tab goes into the plot's own layout, spanning all of it, so that it
  # sits at the plot's top left corner even when a fixed aspect ratio (a pie,
  # say) leaves the plot smaller than the space it is drawn in.
  gt <- ggplot2::ggplotGrob(plot)
  if (!is.null(axis_titles)) {
    gt <- classic_add_axis_titles(gt, plot, axis_titles)
  }
  gtable::gtable_add_grob(
    gt,
    tab_grob,
    t = 1,
    l = 1,
    b = nrow(gt),
    r = ncol(gt),
    z = Inf,
    clip = "off",
    name = "classic-tab"
  )
}

# The colour a plot's scale gives a value of `aesthetic`, to match an axis title to its series.
classic_series_colour <- function(plot, value, aesthetic = "colour") {
  unname(ggplot2::ggplot_build(plot)$plot$scales$get_scales(aesthetic)$map(value))
}

# Two-axis charts of the classic style set titles above the axes, in italics and in the colour of the series each axis
# belongs to, in place of a legend: the left ones flush with the chart's left edge and the right ones flush with its
# right. `axis_titles` is `list(left = , right = )`; each side is an entry, `list(label, colour, sub = NULL, key = FALSE)`,
# or a list of entries stacked one above the next. `sub` is a smaller second line (the units) and `key` draws a short
# line of the series' colour before the title, as the paper does when an axis carries several series. The titles go
# into a row of the plot's layout above the panel.
classic_add_axis_titles <- function(gt, plot, axis_titles, size = classic_size) {
  family <- ggplot2::calc_element("text", plot$theme)$family
  line <- size * 1.2
  n_lines <- function(x) length(strsplit(x, "\n", fixed = TRUE)[[1]])
  text <- function(label, side, y, colour, fontsize) {
    grid::textGrob(
      label,
      x = grid::unit(if (side == "left") 0 else 1, "npc"),
      y = grid::unit(y, "pt"),
      just = c(side, "bottom"),
      gp = grid::gpar(col = colour, fontsize = fontsize, fontface = "italic", fontfamily = family, lineheight = 1.0)
    )
  }
  side_grobs <- function(entries, side) {
    if (!is.null(entries$label)) {
      entries <- list(entries)
    }
    key_width <- size * 1.6
    gap <- size * 0.3
    y <- size * 0.75
    grobs <- list()
    for (e in rev(entries)) {
      if (!is.null(e$sub)) {
        grobs <- c(grobs, list(text(e$sub, side, y, e$colour, size * 0.9)))
        y <- y + n_lines(e$sub) * size * 0.9 * 1.2
      }
      label <- text(e$label, side, y, e$colour, size)
      top <- y + n_lines(e$label) * line
      if (isTRUE(e$key)) {
        first <- strsplit(e$label, "\n", fixed = TRUE)[[1]][1]
        mid <- top - line / 2
        if (side == "left") {
          x0 <- grid::unit(0, "npc")
          label$x <- grid::unit(key_width + gap, "pt")
        } else {
          x0 <- grid::unit(1, "npc") -
            grid::grobWidth(text(first, side, 0, e$colour, size)) -
            grid::unit(key_width + gap, "pt")
          label$x <- grid::unit(1, "npc")
        }
        grobs <- c(
          grobs,
          list(grid::segmentsGrob(
            x0,
            grid::unit(mid, "pt"),
            x0 + grid::unit(key_width, "pt"),
            grid::unit(mid, "pt"),
            gp = grid::gpar(col = e$colour, lwd = 2.2, lineend = "butt")
          ))
        )
        if (side == "left") label$just <- c("left", "bottom")
        # The label's own line is drawn from the left edge of its key's end on the left, as it is.
      }
      grobs <- c(grobs, list(label))
      y <- top + size * 0.15
    }
    list(grob = do.call(grid::gList, grobs), height = y)
  }
  left <- side_grobs(axis_titles$left, "left")
  right <- side_grobs(axis_titles$right, "right")
  # The row reaches up into the subtitle's bottom margin, so that the titles sit about 6pt under the subtitle, as on
  # the paper's charts, not the subtitle's margin and a gap of the row's own.
  height <- grid::unit(max(left$height, right$height) - size * 0.45, "pt")
  panel <- gt$layout[grepl("^panel", gt$layout$name), ]
  top <- min(panel$t)
  l_col <- gt$layout$l[gt$layout$name == "axis-l"][1]
  r_col <- gt$layout$l[gt$layout$name == "axis-r"][1]
  gt <- gtable::gtable_add_rows(gt, height, pos = top - 1)
  gt <- gtable::gtable_add_grob(
    gt,
    grid::gTree(children = left$grob),
    t = top,
    l = l_col,
    clip = "off",
    name = "axis-title-left"
  )
  gtable::gtable_add_grob(
    gt,
    grid::gTree(children = right$grob),
    t = top,
    l = r_col,
    clip = "off",
    name = "axis-title-right"
  )
}

# `base_size` of `theme_economist()` is the size of the axis labels. The charts
# of the chart corpus (2012 to 2018) that are one column wide, 160pt, set them
# at about 6.5pt, which is the base size the classic charts here use, and the
# size at which `theme_economist()`'s title, subtitle and source line come out
# at the corpus's. The 2017 charts at the same width use `base_size = 7`, the
# guide's axis labels (see `?theme_economist_2017`).
classic_size <- 6.5

# Bar and column charts have no ticks. The charts of the chart corpus (2012 to
# 2018) have neither a baseline nor ticks under their bars, where the line
# charts' ticks point into the panel; `theme_economist()` draws ticks on every
# chart, so the classic bar and column charts take them off.
classic_no_ticks <- function() ggplot2::theme(axis.ticks = ggplot2::element_blank())

# Horizontal bar charts, the values along the bottom, have no line under the
# axis either: the gridlines and the bars' own ends mark the scale.
classic_no_axis_line <- function() ggplot2::theme(axis.line.x = ggplot2::element_blank())

# The classic dot, as the paper's dot and thermometer charts draw it: a filled circle with a dark outline, about 5.6pt
# across on a chart 160pt wide, in four looks, in the order the paper uses them:
#   1. white, with a dark red outline;
#   2. light blue, with a dark blue outline;
#   3. white, with a dark blue outline;
#   4. salmon, with a dark red outline, for the highlighted point.
# The colours are the classic palette's own: dark red, light blue, dark blue and pink.
classic_dot_looks <- function() {
  fg <- stats::setNames(ggthemes_data$economist$fg$value, ggthemes_data$economist$fg$name)
  list(
    fill = c("white", fg[["light blue"]], "white", fg[["pink"]]),
    outline = c(fg[["dark red"]], fg[["dark blue"]], fg[["dark blue"]], fg[["dark red"]])
  )
}
classic_dot_size <- 2.25
classic_dot <- function(mapping = NULL, data = NULL, size = classic_dot_size, stroke = 0.5, ...) {
  ggplot2::geom_point(mapping = mapping, data = data, shape = 21, size = size, stroke = stroke, ...)
}
# The same dot for the categories of a scatter, in pairs of a lighter interior and a darker outline from the classic
# palette: light blue with dark blue, pink with dark red, light green with dark green, and white with blue-gray.
classic_scatter_looks <- function() {
  fg <- stats::setNames(ggthemes_data$economist$fg$value, ggthemes_data$economist$fg$name)
  list(
    fill = c(fg[["light blue"]], fg[["pink"]], fg[["light green"]], "white"),
    outline = c(fg[["dark blue"]], fg[["dark red"]], fg[["dark green"]], fg[["blue-gray"]])
  )
}
classic_scatter_scales <- function(n, ...) {
  looks <- classic_scatter_looks()
  list(
    ggplot2::scale_fill_manual(values = looks$fill[seq_len(n)], ...),
    ggplot2::scale_colour_manual(values = looks$outline[seq_len(n)], ...)
  )
}
# Scales for dots mapped to `fill` and `colour` together: the fill and the outline of each series.
classic_dot_scales <- function(n, ...) {
  looks <- classic_dot_looks()
  list(
    ggplot2::scale_fill_manual(values = looks$fill[seq_len(n)], ...),
    ggplot2::scale_colour_manual(values = looks$outline[seq_len(n)], ...)
  )
}
# The thermometer's track: a hollow rounded bar, white inside a dark blue outline, under the dots.
classic_tube <- function(data, mapping, outer = 3, inner = 1.5) {
  lw <- function(pt) pt / (ggplot2::.pt * 0.75)
  dark <- classic_dot_looks()$outline[2]
  list(
    ggplot2::geom_segment(data = data, mapping = mapping, colour = dark, linewidth = lw(outer), lineend = "round"),
    ggplot2::geom_segment(data = data, mapping = mapping, colour = "white", linewidth = lw(inner), lineend = "round")
  )
}

# The thin black line along the top of a stacked area, over the total of the bands. The bands are separated by white
# rules (`geom_area()` with a white upper outline); this goes over the white one on the top band.
classic_stack_top <- function(x, y) {
  ggplot2::stat_summary(
    ggplot2::aes(x = .data[[x]], y = .data[[y]], group = 1),
    inherit.aes = FALSE,
    fun = sum,
    geom = "line",
    colour = "black",
    linewidth = 0.2
  )
}

# Draw a classic chart and its 2017 counterpart side by side on one device,
# each in its own half under a heading. Both arguments are grobs: the result of
# `classic_chart()` and of `economist_2017_chart()`.
chart_pair <- function(classic, modern, headings = c("Classic", "2017")) {
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(
    layout = grid::grid.layout(2, 2, heights = grid::unit(c(1.2, 1), c("lines", "null")))
  ))
  cell <- function(row, col) grid::viewport(layout.pos.row = row, layout.pos.col = col)
  for (j in 1:2) {
    grid::pushViewport(cell(1, j))
    grid::grid.text(headings[[j]], gp = grid::gpar(fontface = "bold", fontsize = 9, col = "#404040"))
    grid::popViewport()
  }
  grid::pushViewport(cell(2, 1))
  grid::grid.draw(classic)
  grid::popViewport()
  grid::pushViewport(cell(2, 2))
  grid::grid.draw(modern)
  grid::popViewport(2)
  invisible(NULL)
}

# The chunk options of the 2017 article: `econ_size` names one of the guide's
# chart sizes and `econ_height` its height in points. A pair is drawn at twice
# the width, one chart in each half, plus a row for the headings.
knitr::opts_chunk$set(econ_size = "one_column", econ_pair = TRUE)
knitr::opts_hooks$set(econ_size = function(options) {
  size <- tryCatch(economist_2017_size(options$econ_size, options$econ_height), error = function(e) NULL)
  if (is.null(size)) {
    return(options)
  }
  w <- size[["width"]] * if (isTRUE(options$econ_pair)) 2 else 1
  options$fig.width <- w
  options$fig.height <- size[["height"]] + if (isTRUE(options$econ_pair)) 0.2 else 0
  options$out.width <- paste0(round(w * 96), "px")
  options
})
