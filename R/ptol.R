#' Color Palettes from Paul Tol's "Colour Schemes"
#'
#' Qualitative color palettes from Paul Tol,
#' \href{https://personal.sron.nl/~pault/colourschemes.pdf}{"Colour Schemes"}.
#'
#' Incorporation of the palette into an R package was originally inspired by
#' Peter Carl's [Paul Tol 21 Gun Salute](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)
#'
#' @export
#' @family colour ptol
#' @references
#' Paul Tol. 2012. "Colour Schemes." SRON Technical Note, SRON/EPS/TN/09-002.
#'  \url{https://personal.sron.nl/~pault/colourschemes.pdf}
#' @examples
#' library("scales")
#' show_col(ptol_pal()(6))
#' show_col(ptol_pal()(4))
#' show_col(ptol_pal()(12))
ptol_pal <- function() {
  function(n) {
    if (n > 12) {
      stop(sprintf("%s is greater than the max number of colors", n))
    } else if (n < 1) {
      stop("the number of colors cannot be zero")
    }
    ggthemes_data$ptol$qualitative[[n]]
  }
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
scale_colour_ptol <- function(...) {
  discrete_scale("colour", "ptol", ptol_pal(), ...)
}

#' @export
#' @rdname scale_ptol
scale_color_ptol <- scale_colour_ptol

#' @export
#' @rdname scale_ptol
scale_fill_ptol <- function(...) {
  discrete_scale("fill", "ptol", ptol_pal(), ...)
}
