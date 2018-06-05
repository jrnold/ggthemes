#' Theme Calc
#'
#' Theme similar to the default settings of LibreOffice Calc charts.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes calc
#' @example inst/examples/ex-theme_calc.R
theme_calc <- function(base_size = 10, base_family = "sans") {
  (theme_foundation(base_family = base_family, base_size = base_size)
   + theme(rect = element_rect(colour = "black", fill = "white"),
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
           legend.key = element_rect(colour = NA)))

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
#' @seealso See \code{\link{theme_calc}} for examples.
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

#' Calc shape palette (discrete)
#'
#' Shape palette based on the shapes used in LibreOffice Calc.
#'
#' @export
#' @family shapes calc
#' @example inst/examples/ex-calc_shape_pal.R
calc_shape_pal <- function() {
    values <- ggthemes::ggthemes_data$calc$shapes[["pch"]]
    f <- manual_pal(unname(values))
    attr(f, "max_n") <- length(values)
    f
}

#' Calc shape scale
#'
#' See \code{\link{calc_shape_pal}} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shapes calc
#' @export
#' @seealso \code{\link{theme_calc}} for examples.
scale_shape_calc <- function (...) {
    discrete_scale("shape", "calc", calc_shape_pal(), ...)
}
