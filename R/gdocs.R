#' Theme with Google Docs Chart defaults
#'
#' Theme similar to the default look of charts in Google Docs.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes gdocs
#' @example inst/examples/ex-theme_gdocs.R
theme_gdocs <- function(base_size = 12, base_family = "sans") {
  # Colours sampled from a Google Sheets chart. Sheets uses a graded text
  # hierarchy rather than a single grey: tick labels are the darkest, then
  # legend labels, then axis titles, with the chart title lightest of all.
  gridline <- "#cccccc"
  tick_colour <- "#000000"
  legend_colour <- "#1a1a1a"
  axis_colour <- "#333333"
  title_colour <- "#757575"

  theme_foundation(
    base_size = base_size,
    base_family = base_family
  ) +
    theme(
      rect = element_rect(colour = "black", fill = "white"),
      line = element_line(colour = "black"),
      text = element_text(colour = legend_colour),
      # title is aligned left, plain, and lighter than the rest of the chart
      plot.title = element_text(
        face = "plain",
        size = rel(20 / 12),
        hjust = 0,
        colour = title_colour
      ),
      # No subtitle or captions in gdocs, so treat like the title
      plot.subtitle = element_text(
        hjust = 0,
        size = rel(1),
        face = "plain",
        colour = title_colour
      ),
      plot.caption = element_text(
        hjust = 0,
        size = rel(1),
        face = "plain",
        colour = title_colour
      ),
      panel.background = element_rect(fill = NA, colour = NA),
      panel.border = element_rect(fill = NA, colour = NA),
      # no strips in gdocs, so make similar to axis titles
      strip.text = element_text(
        hjust = 0,
        size = rel(1),
        colour = axis_colour,
        face = "plain"
      ),
      strip.background = element_rect(colour = NA, fill = NA),
      # axis titles: base size, plain, lighter than the tick labels
      axis.title = element_text(
        face = "plain",
        colour = axis_colour,
        size = rel(1)
      ),
      # axis text: base size, plain, the darkest text in the chart
      axis.text = element_text(
        face = "plain",
        colour = tick_colour,
        size = rel(1)
      ),
      # only axis line on the x-axis, matching the axis titles
      axis.line = element_line(colour = axis_colour),
      axis.line.y = element_blank(),
      # no axis ticks
      axis.ticks = element_blank(),
      # grid lines on both x and y axes. light gray. no minor gridlines
      panel.grid.major = element_line(colour = gridline),
      panel.grid.minor = element_blank(),
      # legend has no border
      legend.background = element_rect(colour = NA),
      # legend labels: base size, near-black
      legend.text = element_text(
        size = rel(1),
        colour = legend_colour
      ),
      # no legend title in gdocs - use same as legend text
      legend.title = element_text(
        size = rel(1),
        colour = legend_colour,
        face = "plain"
      ),
      legend.key = element_rect(colour = NA),
      legend.position = "right",
      legend.direction = "vertical"
    )
}

#' Google Docs color palette (discrete)
#'
#' Color palettes from Google Docs.
#' This palette includes 20 colors.
#'
#' @family colour gdocs
#' @export
#' @example inst/examples/ex-gdocs_pal.R
gdocs_pal <- function() {
  values <- ggthemes::ggthemes_data$gdocs$colors$value
  f <- manual_pal(values)
  attr(f, "max_n") <- length(values)
  f
}

#' Google Docs color scales
#'
#' Color scales from Google Docs.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour gdocs
#' @rdname scale_gdocs
#' @export
#' @seealso See \code{\link{theme_gdocs}()} for examples.
scale_fill_gdocs <- function(...) {
  discrete_scale("fill", palette = gdocs_pal(), ...)
}

#' @export
#' @rdname scale_gdocs
scale_colour_gdocs <- function(...) {
  discrete_scale("colour", palette = gdocs_pal(), ...)
}

#' @export
#' @rdname scale_gdocs
scale_color_gdocs <- scale_colour_gdocs
