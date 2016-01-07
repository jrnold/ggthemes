#' Colorblind Color Palette (Discrete) and Scales
#'
#' An 8-color colorblind safe qualitative discrete palette.
#'
#' @rdname colorblind
#' @references
#' Chang, W. "\href{http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette}{Cookbook for R}"
#'
#' \url{http://jfly.iam.u-tokyo.ac.jp/color}
#'
#' @export
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour
#' @seealso The \pkg{dichromat} package, \code{\link[scales]{dichromat_pal}},
#'  and \code{\link{scale_color_tableau}} for other colorblind palettes.
#' @examples
#' library("ggplot2")
#' library(scales)
#' show_col(colorblind_pal()(8))
#' p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
#'      colour=factor(gear))) + facet_wrap(~am)
#' p + theme_igray() + scale_colour_colorblind()
colorblind_pal <- function() {
  manual_pal(unname(ggthemes_data$colorblind))
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
