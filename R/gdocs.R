#' Theme with Google Docs Chart defaults
#'
#' Theme similar to the default look of charts in Google Docs.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes gdocs
#' @example inst/examples/ex-theme_gdocs.R
theme_gdocs <- function(base_size=12, base_family="sans") {
  theme_foundation(base_size = base_size,
                   base_family = base_family) +
    theme(rect = element_rect(colour = "black", fill = "white"),
          line = element_line(colour = "black"),
          text = element_text(colour = "black"),
          plot.title = element_text(face = "bold",
                                    # 16 pt, bold, align left
                                    size = rel(1.33), hjust = 0),
          panel.background = element_rect(fill = NA, colour = NA),
          panel.border = element_rect(fill = NA, colour = NA),
          # 12 pt
          axis.title = element_text(face = "italic"),
          # 12 pt
          axis.text = element_text(),
          axis.line = element_line(colour = "black"),
          axis.ticks = element_blank(),
          panel.grid.major = element_line(colour = "#CCCCCC"),
          panel.grid.minor = element_blank(),
          legend.background = element_rect(colour = NA),
          legend.key = element_rect(colour = NA),
          legend.position = "right",
          legend.direction = "vertical")
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
#' @seealso See \code{\link{theme_gdocs}} for examples.
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

# # Default Font is Roboto
# theme_gdocs <- function(base_size = 12,
#                         base_family = "sans") {
#   colorlist <- list(lt_gray = "#CCCCCC",
#                     dk_gray = "#757575")
#   theme_bw(base_family = base_family,
#            base_size = base_size) +
#     theme(
#       text = element_text(
#         colour = colorlist$dk_gray,
#         size = base_size
#       ),
#       line = element_line(
#         linetype = "solid",
#         colour = colorlist$lt_gray
#       ),
#       rect = element_rect(
#         linetype = 0,
#         fill = "white",
#         colour = NA
#       ),
#       panel.grid.major = element_line(
#         linetype = "solid",
#         colour = colorlist$lt_gray
#       ),
#       panel.grid.minor = element_blank(),
#       axis.title = element_text(
#         size = 12,
#         colour = colorlist$dk_gray,
#         hjust = 0.5
#       ),
#       axis.line.x = element_line(
#         colour = "#000000"
#       ),
#       axis.line.y = element_blank(),
#       axis.text = element_text(
#         colour = colorlist$dk_gray,
#         size = 12
#       ),
#       axis.ticks = element_blank(),
#       strip.background = element_rect(
#         fill = NA,
#         colour = NA
#       ),
#       strip.text = element_text(
#         colour = colorlist$dk_gray,
#         size = 12
#       ),
#       panel.background = element_blank(),
#       panel.border = element_rect(colour = NA),
#       title = element_text(
#         face = "plain",
#         colour = colorlist$dk_gray,
#       ),
#       plot.title = element_text(
#         size = 20,
#         hjust = 0
#       ),
#       plot.subtitle = element_blank(),
#       legend.position = "right",
#       legend.text = element_text(
#         size = 12,
#         colour = colorlist$dk_gray
#       ),
#       legend.title = element_blank()
#     )
# }
