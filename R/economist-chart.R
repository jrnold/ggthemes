#' Finish a classic Economist chart
#'
#' Finishes a plot styled with [theme_economist()] as a classic (pre-2017)
#' print chart of *The Economist*, drawing what no [ggplot2::theme()] setting
#' can:
#'
#' * the red tab, a red rectangle 5pt wide and 15pt tall flush with the
#'   chart's top left corner. It is on 99% of the print charts of 2012 to 2016
#'   and kept the same size throughout;
#' * optionally, a number box at the top right, for a chart the text refers
#'   to by number: the number in bold white on a blue-gray square, 9pt across
#'   and 4.4pt in from the top and right edges;
#' * optionally, the broken-scale mark of a value axis that does not start at
#'   zero: a thin black zigzag, 4pt wide and 4.5pt tall, centred in the column
#'   of axis labels at the foot of the axis. It sits outside the panel, where a
#'   geom cannot draw it.
#'
#' Sizes are those of a one-column chart, 160pt across, drawn at
#' `theme_economist(base_size = 6.5)`, and scale with the plot's base size, so a
#' chart drawn at the default `base_size` of 10 gets a tab 7.7pt by 23pt. The
#' tab and the rules on the charts are in Economist red, `#E3120B`.
#'
#' @param plot A ggplot styled with [theme_economist()].
#' @param number The chart's number, or `NULL` for none.
#' @param tab Width and height of the red tab, in points at a `base_size` of
#'   6.5, or `NULL` for no tab.
#' @param scale_break The value axis to mark as broken: `"none"`, `"right"`
#'   (where classic charts put the value axis) or `"left"`. Truncate the axis
#'   itself with the scale's `limits` or [ggplot2::coord_cartesian()]; the mark
#'   only declares it. Unlike the 2017 mark
#'   ([geom_scale_break_economist_2017()]), classic charts drew it on index
#'   scales too.
#'
#' @return A grob of class `ggthemes_economist_classic_chart`. Print it to draw
#'   it, or pass it to [ggplot2::ggsave()]. It is laid out when drawn, like a
#'   ggplot, but it is no longer a ggplot: add layers, scales and themes before
#'   calling this function.
#'
#' @seealso [economist_2017_chart()] for the 2017 design, whose tab is turned
#'   through a right angle and sits above the title.
#' @family themes economist
#' @export
#' @example inst/examples/ex-economist_chart.R
economist_chart <- function(plot, number = NULL, tab = c(5, 15), scale_break = c("none", "right", "left")) {
  scale_break <- rlang::arg_match(scale_break)
  if (!ggplot2::is_ggplot(plot)) {
    cli::cli_abort("{.arg plot} must be a ggplot, not {.obj_type_friendly {plot}}.")
  }
  if (!is.null(number) && length(number) != 1) {
    cli::cli_abort("{.arg number} must be a single value or {.code NULL}.")
  }
  if (!is.null(tab) && (!is.numeric(tab) || length(tab) != 2 || any(tab < 0))) {
    cli::cli_abort("{.arg tab} must be two non-negative numbers, a width and a height in points, or {.code NULL}.")
  }
  # Built at draw time, in makeContent(), as economist_2017_chart() is.
  grid::gTree(
    plot = plot,
    number = number,
    tab = tab,
    scale_break = scale_break,
    cl = "ggthemes_economist_classic_chart"
  )
}

# The base size the classic sizes are measured at: a one-column chart.
economist_classic_base <- 6.5

#' @exportS3Method grid::makeContent
makeContent.ggthemes_economist_classic_chart <- function(x) {
  grid::setChildren(x, grid::gList(economist_classic_layout(x$plot, x$number, x$tab, x$scale_break)))
}

#' @export
print.ggthemes_economist_classic_chart <- function(x, newpage = TRUE, ...) {
  if (newpage) {
    grid::grid.newpage()
  }
  grid::grid.draw(x)
  invisible(x)
}

economist_classic_layout <- function(plot, number = NULL, tab = c(5, 15), scale_break = "none") {
  theme <- ggplot2::complete_theme(plot$theme)
  k <- ggplot2::calc_element("text", theme)$size / economist_classic_base
  pt <- function(v) grid::unit(v * k, "pt")
  bg <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
  gt <- ggplot2::ggplotGrob(plot)
  everywhere <- function(gt, grob, name) {
    gtable::gtable_add_grob(gt, grob, t = 1, l = 1, b = nrow(gt), r = ncol(gt), clip = "off", z = Inf, name = name)
  }
  if (!is.null(tab)) {
    gt <- everywhere(
      gt,
      grid::rectGrob(
        x = 0,
        y = 1,
        width = pt(tab[[1]]),
        height = pt(tab[[2]]),
        just = c("left", "top"),
        gp = grid::gpar(fill = unname(bg["economist red"]), col = NA)
      ),
      "economist-tab"
    )
  }
  if (!is.null(number)) {
    side <- 9
    inset <- 4.4
    family <- ggplot2::calc_element("text", theme)$family
    box <- grid::gTree(
      children = grid::gList(
        grid::rectGrob(
          x = grid::unit(1, "npc") - pt(inset),
          y = grid::unit(1, "npc") - pt(inset),
          width = pt(side),
          height = pt(side),
          just = c("right", "top"),
          gp = grid::gpar(fill = unname(bg["number box"]), col = NA)
        ),
        grid::textGrob(
          as.character(number),
          x = grid::unit(1, "npc") - pt(inset + side / 2),
          y = grid::unit(1, "npc") - pt(inset + side / 2),
          gp = grid::gpar(col = "white", fontface = "bold", fontsize = 7 * k, fontfamily = family)
        )
      )
    )
    gt <- everywhere(gt, box, "economist-number")
  }
  if (scale_break != "none") {
    gt <- economist_classic_scale_break(gt, theme, scale_break, pt)
  }
  gt
}

# The broken-scale mark: an "N" leaning to the right, measured from print charts of 2012 to 2015 (as 20131116_FNC698,
# 20120317_WBC761), centred on the panel's foot in the column of axis labels, one per panel row.
economist_classic_scale_break <- function(gt, theme, side, pt) {
  # A plot keeps an empty cell for an axis it does not draw.
  drawn <- grepl(paste0("^axis-", substr(side, 1, 1), "(-|$)"), gt$layout$name) &
    !vapply(gt$grobs, inherits, logical(1), "zeroGrob")
  cells <- gt$layout[drawn, , drop = FALSE]
  if (!nrow(cells)) {
    cli::cli_warn("The plot has no {side} axis to mark as broken.")
    return(gt)
  }
  # The labels' centre, from the cell's: the cell also holds the ticks (when drawn) and the labels' margins.
  text <- ggplot2::calc_element(paste0("axis.text.y.", side), theme)
  ticks <- ggplot2::calc_element(paste0("axis.ticks.y.", side), theme)
  tick_length <- if (inherits(ticks, "element_blank")) {
    0
  } else {
    max(
      0,
      grid::convertUnit(ggplot2::calc_element(paste0("axis.ticks.length.y.", side), theme), "pt", valueOnly = TRUE)
    )
  }
  margin <- grid::convertUnit(text$margin %||% ggplot2::margin(), "pt", valueOnly = TRUE)
  inner <- tick_length + if (side == "right") margin[[4]] else margin[[2]]
  outer <- if (side == "right") margin[[2]] else margin[[4]]
  centre <- grid::unit(0.5, "npc") + grid::unit((inner - outer) / 2 * if (side == "right") 1 else -1, "pt")
  # Corners of the N in a 4pt by 4.5pt box, from its centre.
  dx <- c(-0.5, 0.2, -0.2, 0.5) * 4
  dy <- c(-0.15, 0.5, -0.5, 0.15) * 4.5
  for (i in seq_len(nrow(cells))) {
    mark <- grid::polylineGrob(
      x = centre + pt(dx),
      y = grid::unit(0, "npc") + pt(dy),
      gp = grid::gpar(
        col = "black",
        lwd = grid::convertUnit(pt(0.5), "pt", valueOnly = TRUE) / 0.75,
        linejoin = "mitre"
      )
    )
    gt <- gtable::gtable_add_grob(
      gt,
      mark,
      t = cells$t[[i]],
      l = cells$l[[i]],
      b = cells$b[[i]],
      r = cells$r[[i]],
      clip = "off",
      z = Inf,
      name = paste0("economist-scale-break-", i)
    )
  }
  gt
}

#' Label a value axis with the classic Economist plus/minus convention
#'
#' Classic *The Economist* charts label the negative side of a value axis
#' without minus signs, and mark the sides of zero with a plus and a minus
#' sign instead: on a vertical axis a "+" above the zero and a "–" below it,
#' and on a horizontal axis "– 0 +". The print charts of 2012 to 2015 do this
#' on about 90% of panels with negative values, of every chart type. Draw the
#' zero line in red, as the charts do, with
#' `geom_hline(yintercept = 0, colour = "#E3120B")`.
#'
#' @param x A numeric vector of axis breaks.
#' @param direction The direction of the axis: `"vertical"`, for a y axis, or
#'   `"horizontal"`, for an x axis such as the value axis of a horizontal bar
#'   chart.
#' @param ... Passed to [format()].
#'
#' @return `economist_plus_minus()` returns a character vector, with `NA`
#'   wherever `x` is `NA`. `economist_plus_minus_format()` returns a function
#'   of a single argument `x` that returns a character vector, for use as a
#'   scale's `labels`.
#'
#' @family themes economist
#' @export
#' @examples
#' economist_plus_minus(c(-10, -5, 0, 5, 10))
#' economist_plus_minus(c(-5, 0, 5, 10), direction = "horizontal")
#'
#' library("ggplot2")
#' df <- data.frame(year = 2003:2012, balance = c(3.5, 0.6, 0.1, 3, 2.4, 0, 2, 0.7, 0.2, -2.7))
#' ggplot(df, aes(year, balance)) +
#'   geom_col(fill = economist_pal()(1)) +
#'   geom_hline(yintercept = 0, colour = "#E3120B") +
#'   scale_y_continuous(position = "right", labels = economist_plus_minus_format()) +
#'   theme_economist()
economist_plus_minus <- function(x, direction = c("vertical", "horizontal"), ...) {
  direction <- rlang::arg_match(direction)
  if (!is.numeric(x)) {
    cli::cli_abort("{.arg x} must be a numeric vector, not {.obj_type_friendly {x}}.")
  }
  out <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  out[ok] <- format(abs(x[ok]), trim = TRUE, ...)
  zero <- ok & x == 0
  out[zero] <- if (direction == "vertical") {
    paste0("+\n", out[zero], "\n\u2013")
  } else {
    paste0("\u2013 ", out[zero], " +")
  }
  out
}

#' @rdname economist_plus_minus
#' @export
economist_plus_minus_format <- function(direction = c("vertical", "horizontal"), ...) {
  direction <- rlang::arg_match(direction)
  function(x) economist_plus_minus(x, direction = direction, ...)
}
