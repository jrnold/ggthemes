##' Colorblind Color Palette (Discrete) and Scales
##'
##' An 8-color colorblind safe qualitative discrete palette from
##' \url{http://jfly.iam.u-tokyo.ac.jp/color} and the
##' \href{http://wiki.stdout.org/rcookbook/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette}{Cookbook
##' for R}.
##'
##' @rdname colorblind
##' @export
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour
##' @seealso The \pkg{dichromat} package, \code{\link[scales]{dichromat_pal}},
##'  and \code{\link{scale_color_tableau}} for other colorblind palettes.
##' @examples
##' library(scales)
##' show_col(colorblind_pal()(8))
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' p <- qplot(carat, price, data=dsamp, colour=clarity) + theme_igray()
##' p + scale_colour_colorblind()
colorblind_pal <- function() {
    manual_pal(unname(ggthemes_data$colorblind))
}

##' @rdname colorblind
##' @export
scale_colour_colorblind <- function(...) {
    discrete_scale("colour", "colorblind", colorblind_pal(), ...)
}

##' @rdname colorblind
##' @export
scale_color_colorblind <- scale_colour_colorblind

##' @rdname colorblind
##' @export
scale_fill_colorblind <- function(...) {
    discrete_scale("fill", "colorblind", colorblind_pal(), ...)
}
