# Columns are referenced through the `.data` pronoun; the local binding lets
# lintr's object_usage_linter see where the name comes from.
.data <- rlang::.data

#' Confidence ribbon in the 2024 Economist style
#'
#' @description
#' A band of uncertainty drawn as *The Economist* has drawn it since its 2024
#' redesign (for example `20250329_EPC233`, "In poll position"): a translucent
#' ribbon in the series' own color, edged by two hairlines of the same color, so
#' that where two ribbons overlap both still show. The heavy line through the
#' ribbon is a separate [ggplot2::geom_line()] layer.
#'
#' The ribbon is 17% of the series' color over the ground, and the hairline is
#' the same color at 45% opacity, about 0.3pt wide. Neither the ribbon nor its
#' edges are named in a key.
#'
#' @details
#' The function returns three layers: a [ggplot2::geom_ribbon()] with
#' `colour = NA` (an inherited `colour` aesthetic would otherwise outline the
#' whole ribbon at full weight) and a [ggplot2::geom_line()] for each of its
#' two edges. Map the series to `fill`; the edges take the same variable as
#' their `colour`, so add both a fill and a colour scale (for example
#' [scale_fill_economist_2024()] and [scale_colour_economist_2024()]).
#'
#' @param mapping Aesthetic mappings made with [ggplot2::aes()]. It must give
#'   `ymin` and `ymax`, and normally `fill` (and `group`); `x` can come from
#'   the plot.
#' @param data A data frame for the layers, or `NULL` to use the plot's.
#' @param ... Other arguments passed to the ribbon layer, such as a fixed
#'   `fill`. A fixed `fill` also sets the color of the edges; a fixed `colour`
#'   sets the color of the edges only, since the ribbon has no outline.
#' @param alpha Opacity of the ribbon's fill.
#' @param edge_alpha Opacity of the two edge lines.
#' @param edge_linewidth Width of the edge lines, in points.
#'
#' @returns A list of three layers, to add to a plot with `+`.
#' @family economist 2024
#' @export
#' @example inst/examples/ex-geom_ribbon_economist_2024.R
geom_ribbon_economist_2024 <- function(
  mapping = NULL,
  data = NULL,
  ...,
  alpha = 0.17,
  edge_alpha = 0.45,
  edge_linewidth = 0.3
) {
  if (is.null(mapping) || is.null(mapping$ymin) || is.null(mapping$ymax)) {
    cli::cli_abort("{.arg mapping} must map {.field ymin} and {.field ymax}.")
  }
  dots <- list(...)
  # A fixed colour is for the edges: the ribbon itself has no outline.
  edge_colour <- dots[["colour"]] %||% dots[["color"]] %||% dots[["fill"]]
  ribbon_dots <- dots[setdiff(names(dots), c("colour", "color"))]
  # Each edge is the ribbon's own x, with y the ribbon's ymin or ymax, and the
  # series' fill as its colour.
  edge_mapping <- function(limit) {
    m <- mapping
    m$y <- mapping[[limit]]
    m$ymin <- NULL
    m$ymax <- NULL
    if (is.null(m$colour) && !is.null(mapping$fill)) {
      m$colour <- mapping$fill
    }
    m$fill <- NULL
    m
  }
  edge <- function(limit) {
    args <- list(
      mapping = edge_mapping(limit),
      data = data,
      alpha = edge_alpha,
      linewidth = edge_linewidth / 0.75 / ggplot2::.pt
    )
    if (!is.null(edge_colour)) {
      args$colour <- edge_colour
    }
    do.call(ggplot2::geom_line, args)
  }
  list(
    do.call(ggplot2::geom_ribbon, c(list(mapping = mapping, data = data, colour = NA, alpha = alpha), ribbon_dots)),
    edge("ymin"),
    edge("ymax")
  )
}

#' Horizontal gridlines with gaps in the 2024 Economist style
#'
#' @description
#' Gridlines drawn by hand, each in segments that stop short of the names
#' standing on it. *The Economist*'s line charts that name their series on the
#' chart do this (for example `20250329_EPC233` and `20240420_EPC345`): where
#' a name sits on a gridline, the gridline breaks for the name and starts again
#' beyond it.
#'
#' The theme's own gridlines cannot be broken, so switch them off with
#' `theme(panel.grid.major.y = element_blank())` and draw these instead. Their
#' color and width are those of [theme_economist_2024()] at the same `media`
#' and `base_size`.
#'
#' @param breaks The y values of the gridlines.
#' @param xmin,xmax The x range the gridlines run across.
#' @param gaps A data frame of gaps, with columns `y` (the gridline), `from`
#'   and `to` (the x range of the break), or `NULL` for no gaps.
#' @inheritParams theme_economist_2024
#'
#' @returns A [ggplot2::layer()] that takes no data from the plot.
#' @family economist 2024
#' @export
#' @example inst/examples/ex-geom_gridline_economist_2024.R
geom_gridline_economist_2024 <- function(
  breaks,
  xmin,
  xmax,
  gaps = NULL,
  media = c("print", "web"),
  base_size = 10
) {
  media <- rlang::arg_match(media)
  if (!is.numeric(breaks) || !is.numeric(xmin) || !is.numeric(xmax) || length(xmin) != 1 || length(xmax) != 1) {
    cli::cli_abort("{.arg breaks} must be numeric and {.arg xmin} and {.arg xmax} single numbers.")
  }
  if (!is.null(gaps) && !all(c("y", "from", "to") %in% names(gaps))) {
    cli::cli_abort("{.arg gaps} must have columns {.field y}, {.field from} and {.field to}.")
  }
  if (is.null(gaps)) {
    gaps <- data.frame(y = numeric(), from = numeric(), to = numeric())
  }
  segments <- do.call(
    rbind,
    lapply(breaks, function(b) {
      g <- gaps[gaps$y == b, , drop = FALSE]
      # Gaps are clipped to the line and merged where they overlap, so no
      # segment runs backwards across one.
      from <- pmax(pmin(g$from, g$to), xmin)
      to <- pmin(pmax(g$from, g$to), xmax)
      keep <- from < to
      from <- from[keep]
      to <- to[keep]
      o <- order(from)
      from <- from[o]
      to <- cummax(to[o])
      starts <- c(xmin, to)
      ends <- c(from, xmax)
      seg <- data.frame(y = rep(b, length(starts)), x = starts, xend = ends)
      seg[seg$x < seg$xend, , drop = FALSE]
    })
  )
  segments <- segments %||% data.frame(y = numeric(), x = numeric(), xend = numeric())
  spec <- ggthemes::ggthemes_data[["economist_2024"]][[media]]
  ggplot2::geom_segment(
    data = segments,
    mapping = ggplot2::aes(x = .data$x, xend = .data$xend, y = .data$y, yend = .data$y),
    colour = spec[["grid"]],
    linewidth = 0.067 * base_size / ggplot2::.pt,
    inherit.aes = FALSE
  )
}
