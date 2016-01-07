#' Color Palettes based on Tableau (discrete)
#'
#' Color palettes used in
#' \href{http://www.tableausoftware.com/}{Tableau}.
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
#' @examples
#' library("scales")
#' show_col(tableau_color_pal('tableau20')(20))
#' show_col(tableau_color_pal('tableau10')(10))
#' show_col(tableau_color_pal('tableau10medium')(10))
#' show_col(tableau_color_pal('tableau10light')(10))
#' show_col(tableau_color_pal('colorblind10')(10))
#' show_col(tableau_color_pal('trafficlight')(10))
#' show_col(tableau_color_pal('purplegray12')(12))
#' show_col(tableau_color_pal('bluered12')(12))
#' show_col(tableau_color_pal('greenorange12')(12))
#' show_col(tableau_color_pal('cyclic')(20))
tableau_color_pal <- function(palette = "tableau10") {
  palettelist <- ggthemes_data$tableau$colors
  if (!palette %in% c(names(palettelist), "tableau10", "tableau10light", "purplegray6", "bluered6", "greenorange6")) {
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
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am)
#' p + scale_colour_tableau()
#' p + scale_colour_tableau('tableau20')
#' p + scale_colour_tableau('tableau10medium')
#' p + scale_colour_tableau('tableau10light')
#' p + scale_colour_tableau('colorblind10')
#' p + scale_colour_tableau('trafficlight')
#' p + scale_colour_tableau('purplegray12')
#' p + scale_colour_tableau('bluered12')
#' p + scale_colour_tableau('greenorange12')
#' p + scale_colour_tableau('cyclic')
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
#' @examples
#' show_shapes(tableau_shape_pal()(5))
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
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
#'      facet_wrap(~am)
#' p + scale_shape_tableau()
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
#' @examples
#' library("scales")
#' x <- seq(0, 1, length = 25)
#' show_col(tableau_seq_gradient_pal('Red')(x))
#' show_col(tableau_seq_gradient_pal('Blue')(x))
#' show_col(tableau_seq_gradient_pal('Purple Sequential')(x))
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
#' @examples
#' #'
#' library("ggplot2")
#' library("ggplot2")
#'
#' df <- data.frame(
#'   x = runif(100),
#'   y = runif(100),
#'   z1 = rnorm(100),
#'   z2 = abs(rnorm(100))
#' )
#'
#'
#' p <- ggplot(df, aes(x, y)) +
#'      geom_point(aes(colour = z2)) +
#'      theme_igray()
#'
#' p + scale_colour_gradient_tableau("Red")
#' p + scale_colour_gradient_tableau("Blue")
#' p + scale_colour_gradient_tableau("Green")
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
#' @examples
#' x <- seq(-1, 1, length = 100)
#' r <- sqrt(outer(x^2, x^2, '+'))
#' image(r,
#'       col = tableau_div_gradient_pal()(seq(0, 1, length = 12)))
#' image(r,
#'       col = tableau_div_gradient_pal('Orange-Blue')(seq(0, 1, length = 12)))
#' image(r,
#'       col = tableau_div_gradient_pal('Temperature')(seq(0, 1, length = 12)))
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
#' @examples
#' library("ggplot2")
#' df <- data.frame(
#' x = runif(100),
#' y = runif(100),
#' z1 = rnorm(100),
#' z2 = abs(rnorm(100))
#' )
#' p <- ggplot(df, aes(x, y)) + geom_point(aes(colour = z2))
#'
#' p + scale_colour_gradient2_tableau()
#' p + scale_colour_gradient2_tableau('Orange-Blue')
#' p + scale_colour_gradient2_tableau('Temperature')
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
