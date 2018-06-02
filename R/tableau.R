# see mstone_Palettes at https://github.com/mcstone/mstone/tree/5acd4ad14246feb07f759053c0e53dc2e023302e/Palettes
#


#' Color Palettes based on Tableau (discrete)
#'
#' Color palettes used in \href{http://www.tableausoftware.com/}{Tableau}.
#'
#'
#' @export
#' @param palette Palette name.
#'
#' @references
#' \url{http://vis.stanford.edu/color-names/analyzer/}
#'
#' Maureen Stone, 'Designing Colors for Data' (slides), at the
#' International Symposium on Computational Aesthetics in Graphics,
#' Visualization, and Imaging, Banff, AB, Canada, June 22, 2007
#' \url{http://www.stonesc.com/slides/CompAe\%202007.pdf}.
#'
#' Heer, Jeffrey and Maureen Stone, 2012 'Color Naming Models for
#' Color Selection, Image Editing and Palette Design', ACM Human
#' Factors in Computing Systems (CHI)
#' \url{http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf}.
#'
#' @family colour tableau
#' @example inst/examples/ex-tableau_color_pal.R
tableau_color_pal <- function(palette = "Tableau 10",
                              type = "regular",
                              direction = 1) {
  palettes <- ggthemes::GGTHEMES[["tableau"]][["color-palettes"]][[type]]
  if (!palette %in% names(palettes)) {
    stop("`palette` must be one of ", paste(names(palettes), collapse = ", "),
         ".")
  }
  values <- palettes[[palette]][["value"]]
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    if (type == "regular") {
      pal <- unname(values)[seq_len(n)]
    }
    if (direction < 0) {
      pal <- rev(pal)
    }
    pal
  }
  attr(f, "max_n") <- length(values)
  f
}


#' Tableau color scales.
#'
#' See \code{\link{tableau_color_pal}} for details.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams tableau_color_pal
#' @family colour tableau
#' @rdname scale_color_tableau
#' @export
#' @seealso \code{\link{tableau_color_pal}} for references.
#' @example inst/examples/ex-scale_color_tableau.R
scale_colour_tableau <- function(palette = "Tableau 10", ...) {
  discrete_scale("colour", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_fill_tableau <- function(palette = "Tableau 10", ...) {
  discrete_scale("fill", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_color_tableau <- scale_colour_tableau

#' Tableau Shape Palettes (discrete)
#'
#' Shape palettes used by
#' \href{http://www.tableausoftware.com/}{Tableau}.
#'
#' @export
#' @param palette Palette name. See \code{ggthemes_data$tableau$shapes}.
#' @family shape tableau
#' @example inst/examples/ex-tableau_shape_pal.R
tableau_shape_pal <- function(palette = "default") {
  manual_pal(unname(ggthemes_data$tableau$shapes[[palette]]))
}

#' Tableau shape scales
#'
#' See \code{\link{tableau_shape_pal}} for details.
#'
#' @export
#' @inheritParams tableau_shape_pal
#' @inheritParams ggplot2::scale_x_discrete
#' @family shape tableau
#' @example inst/examples/ex-scale_shape_tableau.R
scale_shape_tableau <- function(palette = "default", ...) {
  discrete_scale("shape", "tableau", tableau_shape_pal(palette), ...)
}

#' Tableau colour gradient palettes (continuous)
#'
#' @param palette Palette name.
#'  \itemize{
#'  \item{\code{"ordered-sequential"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::GGTHEMES$tableau[["color-palettes"]][["ordered-sequential"]]))}}
#'  \item{\code{"ordered-diverging"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::GGTHEMES$tableau[["color-palettes"]][["ordered-diverging"]]))}}
#'  }
#' @param type Palette type, either \code{"ordered-sequential"} or
#'   \code{"ordered-diverging"}.
#' @param values if colours should not be evenly positioned along the gradient
#'   this vector gives the position (between 0 and 1) for each colour in the
#'   colours vector. See \link[scales]{rescale} for a convenience function to
#'   map an arbitrary range to between 0 and 1.
#' @param direction Sets the order of colors in the scale.
#'    If 1, the default, colors are as the original order.
#'    If -1, the order of colors is reversed.
#' @param ... Arguments passed to \code{tableau_gradient_pal}.
#' @family colour tableau
#'
#' @export
#' @example inst/examples/ex-tableau_seq_gradient_pal.R
tableau_gradient_pal <- function(palette = "Blue", type = "ordered-sequential",
                                 values = NULL, direction = 1) {
  type <- match.arg(type, c("ordered-sequential", "ordered-diverging"))
  pal <- ggthemes::GGTHEMES[["tableau"]][["color-palettes"]][[type]][[palette]]
  colours <- pal[["value"]]
  if (direction < 0) {
    colours <- rev(colours)
  }
  scales::gradient_n_pal(colours, values = values, space = "Lab")
}

#' @export
#' @rdname tableau_gradient_pal
tableau_seq_gradient_pal <- function(palette = "Blue", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-sequential", ...)
}

#' @export
#' @rdname tableau_gradient_pal
tableau_div_gradient_pal <- function(palette = "Orange-Blue Diverging", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-diverging", ...)
}

#' Tableau sequential colour scale (continuous)
#'
#' @export
#' @inheritParams tableau_seq_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @rdname scale_colour_gradient_tableau
#' @example inst/examples/ex-scale_colour_gradient_tableau.R
scale_colour_gradient_tableau <- function(palette = "Blue",
                                          ...,
                                          na.value = "grey50",
                                          guide = "colourbar") {
  continuous_scale("colour", "tableau",
                   tableau_seq_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_gradient_tableau <- function(palette = "Blue",
                                        ...,
                                        na.value = "grey50",
                                        guide = "colourbar") {
  continuous_scale("fill", "tableau",
                   tableau_seq_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_gradient_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_continuous_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_continuous_tableau <- scale_fill_gradient_tableau

#' Tableau diverging colour scales (continuous)
#'
#' @inheritParams tableau_div_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @export
#' @rdname scale_colour_gradient2_tableau
#' @example inst/examples/ex-scale_colour_gradient2_tableau.R
scale_colour_gradient2_tableau <- function(palette = "Orange-Blue Diverging",
                                           ...,
                                           na.value = "grey50",
                                           guide = "colourbar") {
  continuous_scale("colour", "tableau2",
                   tableau_div_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_fill_gradient2_tableau <- function(palette = "Orange-Blue Diverging",
                                         ...,
                                         na.value = "grey50",
                                         guide = "colourbar") {
  continuous_scale("fill", "tableau2",
                   tableau_div_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_color_gradient2_tableau <- scale_colour_gradient2_tableau
