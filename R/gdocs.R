#' Theme with Google Docs Chart defaults
#'
#' Theme similar to the default look of charts in Google Docs.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes gdocs
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'   geom_point(aes(x = wt, y = mpg, colour = factor(gear))) +
#'   facet_wrap(~am)
#' p + theme_gdocs() + scale_color_gdocs()
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
          axis.line = element_line(colour="black"),
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
#'
#' @family colour gdocs
#' @export
#' @examples
#' library("scales")
#' show_col(gdocs_pal()(20))
gdocs_pal <- function() {
  manual_pal(unname(ggthemes_data$gdocs))
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
