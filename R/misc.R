##' Palletes from Stephen Few (discrete)
##'
##' Qualitative color palettes from Stephen Few,
##' \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical
##' Rules for Using Color in Charts"}.
##'
##' He suggests the following
##' \itemize{
##' \item For bars, use medium.
##' \item For lines and points use dark if small or thin, and medium otherwise.
##' }
##'
##' @export
##' @param palette One of "medium", "dark", or "light"
##' @examples
##' show_col(few_pal()(7))
##' show_col(few_pal("dark")(7))
##' show_col(few_pal("light")(7))
few_pal <- function(palette="medium") {
    ## The first value, gray, is used for non-data parts.
    values <- ggplotJrnoldPalettes$few[[palette]]
    n <- length(values)
    manual_pal(unname(values[2:n]))
}

##' Few "Practical Rules for Using Color in Charts" color scales
##'
##' Qualitative color scales from Stephen Few,
##' \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical
##' Rules for Using Color in Charts"}.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @inheritParams few_pal
##' @family colour scales
##' @rdname scale_few
##' @export
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (qplot(carat, price, data=dsamp, colour=clarity)
##' + theme_bw()
##' + scale_colour_few())
##' (qplot(carat, price, data=dsamp, colour=clarity)
##' + theme_bw()
##' + scale_colour_few("dark"))
##' (ggplot(diamonds, aes(clarity, fill=cut))
##' + geom_bar()
##' + theme_bw()
##' + scale_fill_few("light"))
scale_colour_few <- function(palette="medium", ...) {
    discrete_scale("colour", "few", few_pal(palette), ...)
}

#' @export
#' @rdname scale_few
scale_color_few <- scale_colour_few

#' @export
#' @rdname scale_few
scale_fill_few <- function(palette="light", ...) {
    discrete_scale("fill", "few", few_pal(palette), ...)
}

