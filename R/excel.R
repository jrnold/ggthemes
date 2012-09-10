##' Excel 2003 color palette (discrete)
##'
##' Color palettes from Excel 2003. For ironical purposes only.
##'
##' @param fill \code{logical} Use the fill palette?
##' @export
##' @examples
##' show_col(excel2003_pal()(8))
##' show_col(excel2003_pal(fill=TRUE)(8))
excel2003_pal <- function(fill=FALSE) {
    if (!fill) {
        manual_pal(c("#FF00FF", "#FFFF00", "#00FFFF", "#800080",
                     "#800000", "#008080", "#0000FF"))
    } else {
        manual_pal(c("#993366", "#FFFFCC", "#CCFFFF", "#660066",
                     "#FF8080", "#0066CC", "#CCCCFF"))
    }
}

##' Excel 2003 color scales
##'
##' Color scales from Excel 2003. For ironical purposes only. Supports
##' both the fill and line palettes.
##'
##' @inheritParams excel2003_pal
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour scales
##' @rdname scale_excel2003
##' @export
##' @seealso See \code{\link{theme_excel2003}} for examples.
scale_fill_excel2003 <- function(fill=TRUE, ...) {
    discrete_scale("fill", "excel2003", excel2003_pal(fill), ...)
}

#' @export
#' @rdname scale_excel2003
scale_colour_excel2003 <- function(fill=FALSE, ...) {
    discrete_scale("colour", "excel2003", excel2003_pal(fill), ...)
}

#' @export
#' @rdname scale_excel2003
scale_color_excel2003 <- scale_colour_excel2003

##' ggplot color theme based on Excel 2003 plots
##'
##' Theme to replicate the ugly monstrosity that was the Excel 2003
##' chart. Please never use this for anything other than irony.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @param horizontal \code{logical}. Horizontal axis lines?
##' @export
##' @family themes
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'  + theme_excel2003()
##'  + scale_colour_excel2003() )
##' (ggplot(diamonds, aes(clarity, fill=cut))
##' + geom_bar()
##' + scale_fill_excel2003()
##' + theme_excel2003())
theme_excel2003 <- function(horizontal=TRUE, base_size=12, base_family="") {
    gray <- "#C0C0C0"
    ret <- (theme_bw()
            + theme(
                panel.background = element_rect(fill=gray),
                panel.border = element_rect(colour="black", linetype=1),
                panel.grid.major = element_line(colour="black"),
                panel.grid.minor = element_blank(),
                legend.key = element_rect(colour=NA),
                legend.background = element_rect(colour="black", linetype=1),
                strip.background = element_rect(fill="white", colour=NA, linetype=0)
                ))
    if (horizontal) {
        ret <- ret + theme(panel.grid.major.x = element_blank())
    } else {
        ret <- ret + theme(panel.grid.major.y = element_blank())
    }
    ret
}

