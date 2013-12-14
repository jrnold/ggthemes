##' Theme with Google Docs Chart defaults
##'
##' Theme similar to the default look of charts in Google Docs.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes gdocs
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'  + theme_gdocs()
##'  + ggtitle("Diamonds")
##'  + scale_color_gdocs())
theme_gdocs <- function(base_size=12, base_family="sans") {
  (theme_foundation(base_size=base_size, base_family=base_family)
   + theme(plot.title = element_text(face = "bold",
             size = rel(1.33), hjust = 0), # 16 pt, bold, align left
           panel.background = element_rect(colour = NA),
           panel.border = element_rect(colour = NA),
           axis.title = element_text(face = "italic"), # 12 pt
           axis.text = element_text(), # 12 pt
           axis.line = element_line(colour="black"),
           axis.ticks = element_blank(),
           panel.grid.major = element_line(colour = "#CCCCCC"),
           panel.grid.minor = element_blank(),
           legend.key = element_rect(colour = NA),
           legend.position = "right",
           legend.direction = "vertical"))
}

##' Google Docs color palette (discrete)
##'
##' Color palettes from Google Docs.
##'
##' @family colour gdocs
##' @export
##' @examples
##' library(scales)
##' show_col(gdocs_pal()(20))
gdocs_pal <- function() {
    manual_pal(unname(ggthemes_data$gdocs))
}


##' Google Docs color scales
##'
##' Color scales from Google Docs.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour gdocs
##' @rdname scale_gdocs
##' @export
##' @seealso See \code{\link{theme_gdocs}} for examples.
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
