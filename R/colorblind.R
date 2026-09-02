#' Colorblind Color Palette (Discrete) and Scales
#'
#' An eight-color colorblind safe qualitative discrete palette.
#'
#' @rdname colorblind
#' @param black If \code{FALSE}, drop black from the palette. Black is often
#'   used elsewhere in a figure (e.g. text, axes), so including it as a data
#'   color can wrongly suggest that group is a default or baseline.
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
colorblind_pal <- function(black = TRUE) {
  values <- ggthemes::ggthemes_data[["colorblind"]]
  if (isFALSE(black)) {
    values <- values[values[["name"]] != "Black", ]
  }
  values <- unname(values[["value"]])
  f <- manual_pal_checked(values)
  attr(f, "max_n") <- length(values)
  f
}

#' @rdname colorblind
#' @export
colourblind_pal <- colorblind_pal

#' @rdname colorblind
#' @export
scale_colour_colourblind <- function(black = TRUE, ...) {
  discrete_scale("colour", palette = colorblind_pal(black = black), ...)
}

#' @rdname colorblind
#' @export
#' @importFrom lifecycle deprecate_soft
scale_colour_colorblind <- function(black = TRUE, ...) {
  deprecate_soft("5.2.0", "scale_color_colorblind()")
  scale_colour_colourblind(black = black, ...)
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
scale_fill_colorblind <- function(black = TRUE, ...) {
  deprecate_soft("5.2.0", "scale_fill_colorblind()")
  discrete_scale("fill", palette = colorblind_pal(black = black), ...)
}

#' @rdname colorblind
#' @export
scale_fill_colourblind <- scale_fill_colorblind
