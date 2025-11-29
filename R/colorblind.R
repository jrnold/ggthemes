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
colourblind_pal <- colorblind_pal

#' @rdname colorblind
#' @export
scale_colour_colourblind <- function(...) {
  discrete_scale("colour", palette = colorblind_pal(), ...)
}

#' @rdname colorblind
#' @export
#' @importFrom lifecycle deprecate_soft
scale_colour_colorblind <- function(...) {
  deprecate_soft("5.2.0", "scale_color_colorblind()")
  scale_colour_colourblind(...)
}

#' @rdname colorblind
#' @export
scale_color_colorblind <- scale_colour_colourblind

#' @rdname colorblind
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @export
#' @importFrom lifecycle deprecate_soft
scale_fill_colorblind <- function(...) {
  deprecate_soft("5.2.0", "scale_fill_colorblind()")
  discrete_scale("fill", palette = colorblind_pal(), ...)
}

#' @rdname colorblind
#' @export
scale_fill_colourblind <- scale_fill_colorblind
