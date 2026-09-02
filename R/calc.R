#' Theme Calc
#'
#' Theme similar to the default settings of LibreOffice Calc charts.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes calc
#' @example inst/examples/ex-theme_calc.R
theme_calc <- function(base_size = 10, base_family = "sans") {
  (theme_foundation(base_family = base_family, base_size = base_size) +
    theme(
      rect = element_rect(colour = "black", fill = "white"),
      text = element_text(colour = "black"),
      line = element_line(colour = "gray70"),
      # 13 pt
      plot.title = element_text(size = rel(1.3)),
      legend.title = element_text(size = rel(1)),
      legend.text = element_text(size = rel(1)),
      axis.title = element_text(size = rel(1)),
      axis.line = element_blank(),
      panel.border = element_rect(fill = NA, colour = "gray70"),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      legend.position = "right",
      legend.direction = "vertical",
      legend.background = element_rect(colour = NA),
      legend.key = element_rect(colour = NA)
    ))
}

#' Calc color palette (discrete)
#'
#' Color palettes from LibreOffice Calc.
#' This palette has 12 values.
#'
#' @family colour calc
#' @export
#' @example inst/examples/ex-calc_pal.R
calc_pal <- function() {
  values <- unname(ggthemes::ggthemes_data$calc$colors[["value"]])
  max_n <- length(values)
  f <- manual_pal(values)
  attr(f, "max_n") <- max_n
  f
}

#' LibreOffice Calc color scales
#'
#' Color scales from LibreOffice Calc.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour calc
#' @rdname scale_calc
#' @export
#' @seealso See \code{\link{theme_calc}()} for examples.
scale_fill_calc <- function(...) {
  discrete_scale("fill", palette = calc_pal(), ...)
}

#' @export
#' @rdname scale_calc
scale_colour_calc <- function(...) {
  discrete_scale("colour", palette = calc_pal(), ...)
}

#' @export
#' @rdname scale_calc
scale_color_calc <- scale_colour_calc

#' Calc shape palette (discrete)
#'
#' Shape palette based on the shapes used in LibreOffice Calc.
#'
#' @inheritParams cleveland_shape_pal
#'
#' @note
#'
#' This palette supports seven values by default and thirteen with
#' \code{unicode = TRUE}. Six of Calc's thirteen symbols -- the solid down,
#' left and right triangles, the bowtie, the hourglass and the four-pointed
#' star -- have no base pch equivalent and are dropped rather than
#' approximated by a different shape. Restoring them with \code{unicode = TRUE}
#' needs a font covering Geometric Shapes, Dingbats and Miscellaneous
#' Mathematical Symbols-B; Noto Sans Symbols 2 is effectively the only free
#' font with the last of these.
#'
#' @export
#' @family shapes calc
#' @example inst/examples/ex-calc_shape_pal.R
calc_shape_pal <- function(unicode = FALSE) {
  new_shape_pal(ggthemes::ggthemes_data$calc$shapes, unicode = unicode)
}

#' Calc shape scale
#'
#' See \code{\link{calc_shape_pal}()} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams calc_shape_pal
#' @family shapes calc
#' @export
#' @seealso \code{\link{theme_calc}()} for examples.
scale_shape_calc <- function(..., unicode = FALSE) {
  discrete_scale("shape", palette = calc_shape_pal(unicode = unicode), ...)
}

# PT_TO_MM <- 0.352778
#
# # Default font is Liberation Sans
# theme_libre <- function(base_size = 10,
#                         base_family = "sans") {
#   colorlist <- list(gray = "#B3B3B3")
#   theme_bw(base_family = base_family,
#            base_size = base_size) +
#     theme(
#       text = element_text(colour = "black"),
#       line = element_line(
#         linetype = "solid",
#         colour = colorlist$gray,
#         size = 0.5 * PT_TO_MM
#       ),
#       rect = element_rect(
#         fill = "white",
#         linetype = "solid",
#         colour = colorlist$gray,
#         size = 0.5 * PT_TO_MM
#       ),
#       panel.grid.major = element_line(
#         linetype = "solid",
#         colour = colorlist$gray,
#         size = 0.5 * PT_TO_MM
#       ),
#       axis.title = element_text(
#         size = 9
#       ),
#       axis.text = element_text(
#         size = 10
#       ),
#       axis.ticks = element_line(
#         colour = colorlist$gray
#       ),
#       panel.background = element_rect(
#         colour = colorlist$gray,
#         size = 0.5 * PT_TO_MM
#       ),
#       title = element_text(
#         face = "plain",
#         hjust = 0.5
#       ),
#       plot.title = element_text(
#         size = 13,
#         hjust = 0.5
#       ),
#       plot.subtitle = element_text(
#         size = 11,
#         hjust = 0.5
#       ),
#       panel.grid.major.x = element_blank(),
#       panel.grid.minor = element_blank(),
#       legend.position = "right",
#       strip.background = element_blank(),
#       strip.text = element_text(size = 9),
#       legend.title = element_text(
#         size = 9
#       )
#     )
# }
