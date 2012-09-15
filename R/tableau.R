##' Tabaleau Color Palettes (discrete)
##'
##' Color palettes used by
##' \href{http://www.tableausoftware.com/}{Trableau}.
##'
##' @export
##' @param palette Palette name
##' @references
##' \url{http://vis.stanford.edu/color-names/analyzer/}
##'
##' Maureen Stone, "Designing Colors for Data" (slides), at the
##' International Symposium on Computational Aesthetics in Graphics,
##' Visualization, and Imaging, Banff, AB, Canada, June 22, 2007
##' \url{http://www.stonesc.com/slides/CompAe\%202007.pdf}.
##'
##' Heer, Jeffrey and Maureen Stone, 2012 "Color Naming Models for
##' Color Selection, Image Editing and Palette Design", ACM Human
##' Factors in Computing Systems (CHI)
##' \url{http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf}.
##'
##' @examples
##' show_col(tableau_color_pal("tableau20")(20))
##' show_col(tableau_color_pal("tableau10")(10))
##' show_col(tableau_color_pal("tableau10medium")(10))
##' show_col(tableau_color_pal("tableau10light")(10))
##' show_col(tableau_color_pal("purplegray12")(12))
##' show_col(tableau_color_pal("bluered12")(12))
##' show_col(tableau_color_pal("greenorange12")(12))
##'
tableau_color_pal <- function(palette = "tableau10dark") {
    palettelist <- ggplotJrnoldPalettes$tableau$colors
    if (! palette %in%
        c(names(palettelist), "tableau10", "tableau10light",
          "purplegray6", "bluered6", "greenorange6")) {
        stop(sprintf("%s is not a valid palette name", palette))
    }
    if (palette == "tableau10") {
        types <- palettelist[["tableau20"]][seq(1, 20, by=2)]
    } else if (palette == "tableau10light") {
        types <- palettelist[["tableau20"]][seq(2, 20, by=2)]
    } else if (palette == "purplegray6") {
        types <- palettelist[["purplegray12"]][seq(1, 12, by=2)]
    } else if (palette == "bluered6") {
        types <- palettelist[["bluered12"]][seq(1, 12, by=2)]
    } else if (palette == "greenorange6") {
        types <- palettelist[["greenorange12"]][seq(1, 12, by=2)]
    } else {
        types <- palettelist[[palette]]
    }
    function(n) {
        unname(types)[seq_len(n)]
    }
}

##' Tableau color scales.
##'
##' Color scales used by
##' \href{http://www.tableausoftware.com/}{Trableau}.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @inheritParams tableau_color_pal
##' @family colour scales
##' @rdname scale_color_tableau
##' @export
##' @seealso \code{\link{tableau_color_pal}} for references.
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' p <- qplot(carat, price, data=dsamp, colour=clarity) + theme_bw()
##' p + scale_colour_tableau()
##' p + scale_colour_tableau("tableau20")
##' p + scale_colour_tableau("tableau10medium")
##' p + scale_colour_tableau("purplegray12")
scale_colour_tableau <- function (..., palette = "tableau10") {
    discrete_scale("colour", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_fill_tableau <- function (..., palette = "tableau10") {
    discrete_scale("fill", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_color_tableau <- scale_colour_tableau

##' Tabaleau Shape Palettes (discrete)
##'
##' Shape palettes used by
##' \href{http://www.tableausoftware.com/}{Trableau}.
##'
##' @export
##' @param palette Palette name
##' @examples
##' show_shapes(tableau_shape_pal()(5))
tableau_shape_pal <- function(palette="default") {
    manual_pal(unname(ggplotJrnoldPalettes$tableau$shapes[[palette]]))
}

##' Tableau color scales
##'
##' Shape scales used by
##' \href{http://www.tableausoftware.com/}{Trableau}.
##'
##' @export
##' @inheritParams tableau_shape_pal
##' @inheritParams ggplot2::scale_x_discrete
##'
scale_shape_tableau <- function (..., palette = "default") {
    discrete_scale("shape", "tableau", tableau_shape_pal(palette), ...)
}


