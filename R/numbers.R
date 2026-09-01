#' Apple Numbers color palettes (discrete)
#'
#' Color palettes used by charts in Apple Numbers. Each palette provides
#' the six series colors that Numbers assigns to a chart's data series,
#' in order.
#'
#' @param palette Palette name. One of
#'   \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$numbers))}.
#'   The default, \code{"Classic"}, is the palette Numbers itself uses by
#'   default.
#' @family colour numbers
#' @export
#' @example inst/examples/ex-numbers_pal.R
numbers_pal <- function(palette = "Classic") {
  palettes <- ggthemes::ggthemes_data[["numbers"]]
  if (!palette %in% names(palettes)) {
    cli::cli_abort("{.arg palette} must be one of {.val {names(palettes)}}, not {.val {palette}}.")
  }
  values <- palettes[[palette]][["value"]]
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    values[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Apple Numbers color scales
#'
#' Discrete color scales using the chart palettes from Apple Numbers.
#'
#' @inheritParams numbers_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour numbers
#' @rdname scale_numbers
#' @export
#' @seealso See \code{\link{theme_numbers}()} for examples.
#' @example inst/examples/ex-scale_numbers.R
scale_fill_numbers <- function(palette = "Classic", ...) {
  discrete_scale("fill", palette = numbers_pal(palette), ...)
}

#' @export
#' @rdname scale_numbers
scale_colour_numbers <- function(palette = "Classic", ...) {
  discrete_scale("colour", palette = numbers_pal(palette), ...)
}

#' @export
#' @rdname scale_numbers
scale_color_numbers <- scale_colour_numbers

#' Theme with Apple Numbers chart defaults
#'
#' Theme similar to the default look of charts in Apple Numbers.
#'
#' The values used here are those in the \code{chart-style-default} style of
#' the theme stylesheet that ships inside Numbers: no chart background fill,
#' gridlines in the value direction only, a border along the bottom of the
#' chart but not the other three sides, and no tick marks.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes numbers
#' @example inst/examples/ex-theme_numbers.R
theme_numbers <- function(base_size = 12, base_family = "sans") {
  gridline <- "#AAAAAA"

  theme_foundation(
    base_size = base_size,
    base_family = base_family
  ) +
    theme(
      rect = element_rect(colour = NA, fill = "white"),
      line = element_line(colour = "black"),
      text = element_text(colour = "black"),
      plot.title = element_text(face = "plain", size = rel(4 / 3), hjust = 0),
      plot.subtitle = element_text(face = "plain", size = rel(1), hjust = 0),
      plot.caption = element_text(face = "plain", size = rel(1), hjust = 0),
      # charts have no background fill of their own
      panel.background = element_blank(),
      panel.border = element_blank(),
      # gridlines run in the value direction only, solid gray
      panel.grid.major.y = element_line(colour = gridline, linewidth = rel(1)),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      # only the bottom border of the chart is drawn
      axis.line = element_line(colour = "black"),
      axis.line.y = element_blank(),
      # tick marks are off for both axes
      axis.ticks = element_blank(),
      axis.title = element_text(face = "plain", size = rel(1)),
      axis.text = element_text(face = "plain", size = rel(1)),
      # no strips in Numbers, so treat like axis titles
      strip.background = element_blank(),
      strip.text = element_text(face = "plain", size = rel(1), hjust = 0),
      # the legend has neither a fill nor a border
      legend.background = element_rect(fill = NA, colour = NA),
      legend.key = element_rect(fill = NA, colour = NA),
      legend.title = element_text(face = "plain", size = rel(1)),
      legend.text = element_text(size = rel(1)),
      legend.position = "right",
      legend.direction = "vertical"
    )
}
