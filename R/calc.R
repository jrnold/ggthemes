#' LibreOffice Calc theme
#'
#' Theme similar to the default settings of LibreOffice Calc charts.
#'
#' @inheritParams ggplot2::theme_grey
#' @returns A ggplot2 theme object (class `theme`).
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
#' @family color calc
#' @returns A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-calc_pal.R
calc_pal <- function() {
  values <- unname(ggthemes::ggthemes_data$calc$colors[["value"]])
  max_n <- length(values)
  f <- manual_pal_checked(values)
  attr(f, "max_n") <- max_n
  f
}

#' LibreOffice Calc color scales
#'
#' Color scales from LibreOffice Calc.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @family color calc
#' @rdname scale_calc
#' @returns A ggplot2 scale object.
#' @export
#' @seealso See [theme_calc()] for examples.
#' @example inst/examples/ex-scale_calc.R
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
#' `unicode = TRUE`. Six of Calc's thirteen symbols -- the solid down,
#' left and right triangles, the bowtie, the hourglass and the four-pointed
#' star -- have no base pch equivalent and are dropped rather than
#' approximated by a different shape. Restoring them with `unicode = TRUE`
#' needs a font covering Geometric Shapes, Dingbats and Miscellaneous
#' Mathematical Symbols-B; Noto Sans Symbols 2 is effectively the only free
#' font with the last of these.
#'
#' @returns A palette function. It takes the number of shapes `n` and returns an integer vector of `n`
#'   shape (`pch`) codes, and can be used as the `palette` argument of
#'   [ggplot2::discrete_scale()].
#' @export
#' @family shapes calc
#' @example inst/examples/ex-calc_shape_pal.R
calc_shape_pal <- function(unicode = FALSE) {
  new_shape_pal(ggthemes::ggthemes_data$calc$shapes, unicode = unicode)
}

#' Calc shape scale
#'
#' See [calc_shape_pal()] for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams calc_shape_pal
#' @family shapes calc
#' @returns A ggplot2 scale object.
#' @export
#' @seealso [theme_calc()] for examples.
#' @example inst/examples/ex-scale_shape_calc.R
scale_shape_calc <- function(..., unicode = FALSE) {
  discrete_scale("shape", palette = calc_shape_pal(unicode = unicode), ...)
}
