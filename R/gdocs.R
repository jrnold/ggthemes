#' Theme with Google Docs Chart defaults
#'
#' Theme similar to the default look of charts in Google Docs.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes gdocs
#' @example inst/examples/ex-theme_gdocs.R
theme_gdocs <- function(base_size = 12, base_family="sans") {

  ltgray <- "#cccccc"
  dkgray <- "#757575"
  dkgray2 <- "#666666"

  theme_foundation(base_size = base_size,
                   base_family = base_family) +
    theme(rect = element_rect(colour = "black", fill = "white"),
          line = element_line(colour = "black"),
          text = element_text(colour = dkgray),
          # title is aligned left, 20 point Roboto Font, plain
          plot.title = element_text(face = "plain",
                                    size = rel(20 / 12),
                                    hjust = 0, colour = dkgray),
          # No subtitle or captions, so treat like other text
          plot.subtitle = element_text(hjust = 0, size = rel(1),
                                       face = "plain", colour = dkgray),
          plot.caption = element_text(hjust = 0, size = rel(1),
                                      face = "plain", colour = dkgray),
          panel.background = element_rect(fill = NA, colour = NA),
          panel.border = element_rect(fill = NA, colour = NA),
          # no strips in gdocs, so make similar to axis titles
          strip.text = element_text(hjust = 0, size = rel(1), colour = dkgray2,
                                    face = "plain"),
          strip.background = element_rect(colour = NA, fill = NA),
          # axis titles: Roboto 12pt, plain.
          axis.title = element_text(face = "plain", colour = dkgray2,
                                    size = rel(1)),
          # axis text: Roboto 12pt, plain
          axis.text = element_text(face = "plain", colour = dkgray,
                                   size = rel(1)),
          # only axis line on the x-axis. black.
          axis.line = element_line(colour = "black"),
          axis.line.y = element_blank(),
          # no axis ticks
          axis.ticks = element_blank(),
          # grid lines on both x and y axes. light gray. no minor gridlines
          panel.grid.major = element_line(colour = ltgray),
          panel.grid.minor = element_blank(),
          # legend has no border
          legend.background = element_rect(colour = NA),
          # legend labels: Roboto 12, dark gray
          legend.text = element_text(size = rel(1),
                                     colour = dkgray),
          # no legend title - use same as legend text
          legend.title = element_text(size = rel(1),
                                      colour = dkgray2, face = "plain"),
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
  discrete_scale("fill", "gdocs", gdocs_pal(), ...)
}

#' @export
#' @rdname scale_gdocs
scale_colour_gdocs <- function(...) {
  discrete_scale("colour", "gdocs", gdocs_pal(), ...)
}

#' @export
#' @rdname scale_gdocs
scale_color_gdocs <- scale_colour_gdocs
