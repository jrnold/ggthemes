#' Colorblind color palette (discrete) and scales
#'
#' An eight-color colorblind safe qualitative discrete palette.
#'
#' @rdname colorblind
#' @param black If `FALSE`, drop black from the palette. Black is often
#'   used elsewhere in a figure (e.g. text, axes), so including it as a data
#'   color can wrongly suggest that group is a default or baseline.
#' @references
#' Chang, W. "[Cookbook for R](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette)"
#'
#' <https://jfly.iam.u-tokyo.ac.jp/color/>
#'
#' @return `colorblind_pal()` and `colourblind_pal()` return a palette function that takes the number of
#'   colors `n` and returns a character vector of `n` hex colors. The `scale_*()` functions
#'   return a ggplot2 scale object.
#' @export
#' @inheritParams ggplot2::scale_colour_hue
#' @family color colorblind
#' @seealso The dichromat package, [scales::dichromat_pal()],
#'   and [scale_color_tableau()] for other colorblind palettes.
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
#' @description
#' `r lifecycle::badge("deprecated")` `scale_colour_colorblind()` mixes British
#' and American spelling; use `scale_colour_colourblind()` or
#' `scale_color_colorblind()` instead.
#'
#' @export
#' @importFrom lifecycle deprecate_soft
scale_colour_colorblind <- function(black = TRUE, ...) {
  deprecate_soft("5.2.0", "scale_colour_colorblind()", "scale_colour_colourblind()")
  scale_colour_colourblind(black = black, ...)
}

#' @rdname colorblind
#' @export
scale_color_colorblind <- scale_colour_colourblind

#' @rdname colorblind
#' @export
scale_fill_colourblind <- function(black = TRUE, ...) {
  discrete_scale("fill", palette = colorblind_pal(black = black), ...)
}

#' @rdname colorblind
#' @export
scale_fill_colorblind <- scale_fill_colourblind
