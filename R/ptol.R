#' Color Palletes from Paul Tol's "Colour Schemes
#'
#' Qualitative color palettes from Paul Tol,
#' \href{https://personal.sron.nl/~pault/colourschemes.pdf}{"Colour Schemes"}.
#' Incorporation of the palette into an R package was originally inspired by
#' Peter Carl's [Paul Tol 21 Gun Salute](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)
#'
#' @export
#' @param palette One of "ptol1_qual","ptol2_qual,...,"ptol12_qual"
#' @family colour ptol
#' @examples
#' library("scales")
#' show_col(ptol_pal()(9))
#' show_col(ptol_pal("ptol4_qual")(4))
#' show_col(ptol_pal("ptol12_qual")(12))
ptol_pal <- function(palette) {
  if (missing(palette)) {
    palette <- "ptol6_qual"
  }
  palettelist <- ggthemes_data$ptol
  if (!palette %in% c(names(palettelist))) {
    stop(sprintf("%s is not a valid palette name", palette))
  }
    values <- ggthemes_data$ptol[[palette]]
    n <- length(values)
    scales::manual_pal(unname(values[1:n]))
}

#' Color Scales from Paul Tol's "Colour Schemes
#'
#' See \code{\link{ptol_pal}}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams ptol_pal
#' @family colour ptol
#' @rdname scale_ptol
#' @export
scale_colour_ptol <- function(palette, ...) {
    discrete_scale("colour", "ptol", ptol_pal(palette), ...)
}

#' @export
#' @rdname scale_ptol
scale_color_ptol <- scale_colour_ptol

#' @export
#' @rdname scale_ptol
scale_fill_ptol <- function(palette, ...) {
    discrete_scale("fill", "ptol", ptol_pal(palette), ...)
}
