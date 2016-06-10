#' Color Palletes from Paul Tol's "Colour Schemes
#'
#' Qualitative color palettes from Paul Tol,
#' \href{https://personal.sron.nl/~pault/colourschemes.pdf}{"Colour Schemes"}.
#' Incorporation of the palette into an R package was originally inspired by
#' Peter Carl's [Paul Tol 21 Gun Salute](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)
#'
#' @export
#' @param n number of colors; integer value between 1 and 12
#' @family colour ptol
#' @examples
#' library("scales")
#' show_col(ptol_pal()(6))
#' show_col(ptol_pal(4)(4))
#' show_col(ptol_pal(4)(12))
ptol_pal <- function(n) {
  if (missing(n)) {
    n <- 6
  }
  else if (n > 12) {
    stop(sprintf("%s is greater than the max number of colors", n))
  }
  else if (n == 0) {
    stop("the number of colors cannot be zero")
  }
    values <- ggthemes_data$ptol[[n]]
    l <- length(values)
    scales::manual_pal(unname(values[1:l]))
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
scale_colour_ptol <- function(n, ...) {
    discrete_scale("colour", "ptol", ptol_pal(n), ...)
}

#' @export
#' @rdname scale_ptol
scale_color_ptol <- scale_colour_ptol

#' @export
#' @rdname scale_ptol
scale_fill_ptol <- function(n, ...) {
    discrete_scale("fill", "ptol", ptol_pal(n), ...)
}
