#' Colorblind Color Palette (Discrete) and Scales
#'
#' An eight-color colorblind safe qualitative discrete palette.
#'
#' @rdname colorblind
#' @references
#' Chang, W. "\href{http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette}{Cookbook for R}"
#'
#' \verb{https://jfly.iam.u-tokyo.ac.jp/color}
#'
#' @export
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour
#' @seealso The \pkg{dichromat} package, \code{\link[scales]{dichromat_pal}()},
#'   and \code{\link{scale_color_tableau}()} for other colorblind palettes.
#' @example inst/examples/ex-colorblind.R
colorblind_pal <- function() {
  values <- unname(ggthemes::ggthemes_data[["colorblind"]][["value"]])
  f <- manual_pal(values)
  attr(f, "max_n") <- length(values)
  f
}

#' @rdname colorblind
#' @export
scale_colour_colorblind <- function(...) {
  discrete_scale("colour", "colorblind", colorblind_pal(), ...)
}

#' @rdname colorblind
#' @export
scale_color_colorblind <- scale_colour_colorblind

#' @rdname colorblind
#' @export
scale_fill_colorblind <- function(...) {
  discrete_scale("fill", "colorblind", colorblind_pal(), ...)
}
