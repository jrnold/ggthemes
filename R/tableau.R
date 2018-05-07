# see mstone_Palettes at https://github.com/mcstone/mstone/tree/5acd4ad14246feb07f759053c0e53dc2e023302e/Palettes

#' Color Palettes based on Tableau (discrete)
#'
#' Color palettes used in
#' \href{http://www.tableausoftware.com/}{Tableau}.
#'
#' The number in some palette names indicates the maximum number of
#' values supported, e.g \code{tableau20} supports up to 20 values.
#' \code{"trafficlight"} supports up to nine values, and \code{"cyclic"}
#' supports up to 20 values.
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
tableau_color_pal <- function(palette = "tableau10") {
  palettelist <- ggthemes_data$tableau$colors
  if (!palette %in% c(names(palettelist), "tableau10", "tableau10light",
                      "purplegray6", "bluered6", "greenorange6")) {
    stop(sprintf("%s is not a valid palette name", palette))
  }
  if (palette == "tableau10") {
    types <- palettelist[["tableau20"]][seq(1, 20, by = 2)]
  } else if (palette == "tableau10light") {
    types <- palettelist[["tableau20"]][seq(2, 20, by = 2)]
  } else if (palette == "purplegray6") {
    types <- palettelist[["purplegray12"]][seq(1, 12, by = 2)]
  } else if (palette == "bluered6") {
    types <- palettelist[["bluered12"]][seq(1, 12, by = 2)]
  } else if (palette == "greenorange6") {
    types <- palettelist[["greenorange12"]][seq(1, 12, by = 2)]
  } else {
    types <- palettelist[[palette]]
  }
  function(n) {
    unname(types)[seq_len(n)]
  }
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
scale_colour_tableau <- function(palette = "tableau10", ...) {
  discrete_scale("colour", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_fill_tableau <- function(palette = "tableau10", ...) {
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



#' Tableau sequential colour gradient palettes (continuous)
#'
#' @param palette Palette name. See \code{ggthemes_data$tableau$sequential}.
#' @param space Colour space in which to calculate gradient.
#' @family colour tableau
#'
#' @export
#' @example inst/examples/ex-tableau_seq_gradient_pal.R
tableau_seq_gradient_pal <- function(palette = "Red", space = "Lab") {
  pal <- ggthemes_data[["tableau"]][["sequential"]][[palette]]
  seq_gradient_pal(low = pal["low"], high = pal["high"])
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
scale_colour_gradient_tableau <- function(palette = "Red",
                                          ...,
                                          space = "Lab",
                                          na.value = "grey50",
                                          guide = "colourbar") {
  continuous_scale("colour", "tableau",
                   tableau_seq_gradient_pal(palette, space),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_gradient_tableau <- function(palette = "Red",
                                        ..., space = "Lab",
                                        na.value = "grey50",
                                        guide = "colourbar") {
  continuous_scale("fill", "tableau",
                   tableau_seq_gradient_pal(palette, space),
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


#' Tableau diverging colour gradient palettes (continuous)
#'
#' @param palette Palette name. See \code{ggthemes_data$tableau$divergent}.
#' @param space Colour space in which to calculate gradient.
#' @family colour tableau
#'
#' @export
#' @example inst/examples/ex-tableau_div_gradient_pal.R
tableau_div_gradient_pal <- function(palette = "Red-Blue", space = "Lab") {
  pal <- ggthemes_data[["tableau"]][["diverging"]][[palette]]
  div_gradient_pal(low = pal["low"], mid = pal["mid"], high = pal["high"],
                   space = space)
}

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
scale_colour_gradient2_tableau <- function(palette = "Red-Blue",
                                           ..., space = "rgb",
                                           na.value = "grey50",
                                           guide = "colourbar") {
  continuous_scale("colour", "tableau2",
                   tableau_div_gradient_pal(palette, space),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_fill_gradient2_tableau <- function(palette = "Red-Blue",
                                         ...,
                                         space = "rgb",
                                         na.value = "grey50",
                                         guide = "colourbar") {
  continuous_scale("fill", "tableau2",
                   tableau_div_gradient_pal(palette, space),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_color_gradient2_tableau <- scale_colour_gradient2_tableau

# Tableau 10 has 30 palettes
#
# - tableau 10
# - tableau 20
# - color blind
# - seattle grays
# - traffic light
# - superfishel stone
# - miller stone
# - nuriel stone
# - jewel bright
# - summer
# - winter
# - green-orange-teal
# - blue-red-brown
# - purple-pink-gray
# - tableau classic 10
# - tableau classic medium
# - tableau classic 20
# - blue
# - orange
# - green
# - red
# - purple
# - brown
# - gray
# - gray warm
# - blue-teal
# - orange-gold
# - green-gold
# - red-gold
# - hue circle
