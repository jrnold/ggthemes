##' Theme Calc
##'
##' Theme similar to the default settings of LibreOffice Calc charts.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes calc
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'   + theme_calc()
##'   + scale_color_calc())
##' (d <- qplot(carat, price, data=dsamp, shape=cut)
##'  + theme_calc()
##'  + scale_shape_calc())
theme_calc <- function(base_size = 10, base_family = "sans") {
  (theme_foundation(base_family = base_family, base_size = base_size)
   + theme(rect = element_rect(colour = NA),
           line = element_line(colour = "gray70"),
           plot.title = element_text(size = rel(1.3)), # 13 pt
           legend.title = element_text(size = rel(1)),
           legend.text = element_text(size = rel(1)),
           axis.title = element_text(size = rel(1)),
           axis.line = element_blank(),
           panel.border = element_rect(colour = "gray70"),
           panel.grid.minor = element_blank(),
           panel.grid.major.x = element_blank(),
           legend.position = "right",
           legend.direction = "vertical"))
           
}

##' Calc color palette (discrete)
##'
##' Color palettes from LibreOffice Calc.
##'
##' @family colour calc
##' @export
##' @examples
##' library(scales)
##' show_col(calc_pal()(12))
calc_pal <- function() {
    manual_pal(unname(ggthemes_data$calc$colors))
}

##' LibreOffice Calc color scales
##'
##' Color scales from LibreOffice Calc.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour calc
##' @rdname scale_calc
##' @export
##' @seealso See \code{\link{theme_calc}} for examples.
scale_fill_calc <- function(...) {
    discrete_scale("fill", "calc", calc_pal(), ...)
}

#' @export
#' @rdname scale_calc
scale_colour_calc <- function(...) {
    discrete_scale("colour", "calc", calc_pal(), ...)
}

#' @export
#' @rdname scale_calc
scale_color_calc <- scale_colour_calc

##' Calc shape palette (discrete)
##'
##' Shape palette based on the shapes used in LibreOffice Calc.
##'
##' @export
##' @family shapes calc
##' @examples
##' show_shapes(calc_shape_pal()(15))
calc_shape_pal <- function() {
    values <- ggthemes_data$calc$shapes
    manual_pal(unname(values))
}

##' Calc shape scale
##'
##' See \code{\link{calc_shape_pal}} for details.
##'
##' @inheritParams ggplot2::scale_x_discrete
##' @family shapes calc
##' @export
##' @seealso \code{\link{theme_calc}} for examples.
scale_shape_calc <- function (...) {
    discrete_scale("shape", "calc", calc_shape_pal(), ...)
}
