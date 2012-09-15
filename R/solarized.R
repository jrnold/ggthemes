##' Base colors for Solarized light and dark themes
##'
##' @param light \code{logical} Light theme?
##'
##' Creates the base colors for a light or dark solarized theme. See
##' \url{http://ethanschoonover.com/solarized}. The idea for this
##' function comes from the CSS style example.
solarized_rebase <- function(light=TRUE) {
    if (light) {
        rebase <- ggplotJrnoldPalettes$solarized$base[c(paste('base', 3:0, sep=''),
                                                      paste('base0', 0:3, sep=''))]
    } else {
        rebase <- ggplotJrnoldPalettes$solarized$base[c(paste('base0', 3:0, sep=''),
                                                      paste('base', 0:3, sep=''))]
    }
    names(rebase) <- paste('rebase', c(paste('0', 3:0, sep=''), 0:3), sep='')
    rebase
}

##' Solarized color palette (discrete)
##'
##' Solarized accents palette from
##' \url{http://ethanschoonover.com/solarized}. The colors chosen are
##' the combination of colors that maximize the total Euclidean
##' distance between colors in L*a*b space, given a primary accent.
##'
##'
##' @param accent \code{character} Primary accent color.
##' @export
##' @examples
##' show_col(solarized_pal()(2))
##' show_col(solarized_pal()(3))
##' show_col(solarized_pal("red")(4))
solarized_pal <- function(accent="blue") {
    best_colors <- function(color, n=1) {
        allcolors <- names(ggplotJrnoldPalettes$solarized$accents)
        othercolors <- setdiff(allcolors, color)
        solarized <- as(as(hex2RGB(ggplotJrnoldPalettes$solarized$accents), "LAB")@coords, "matrix")
        rownames(solarized) <- names(ggplotJrnoldPalettes$solarized$accents)
        solarized_dist <- as.matrix(dist(solarized, method="euclidean"))
        total_dist <- function(i) {
            sum(solarized_dist[i, i][lower.tri(diag(length(i)))])
        }
        if (n == 1) {
            colorlist <- color
        } else if (n >= length(allcolors)) {
            colorlist <- c(color, othercolors)
        } else {
            othercolors <- setdiff(allcolors, color)
            combinations <- combn(othercolors, n - 1)
            maxdist <- which.max(apply(combinations, 2, function(x) total_dist(c(color, x))))
            colorlist <- c(color, combinations[ , maxdist])
        }
        unname(ggplotJrnoldPalettes$solarized$accents[colorlist])
    }
    function(n) {
        best_colors(accent, n)
    }

}

##' Solarized color scales
##'
##' Accent color theme for Solarized.
##' Primarily for use with
##' \code{\link{theme_solarized}}.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @inheritParams solarized_pal
##' @family colour scales
##' @rdname scale_solarized
##' @export
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_solarized()
##'                + scale_colour_solarized() )
scale_fill_solarized <- function(accent="blue", ...) {
    discrete_scale("fill", "solarized", solarized_pal(accent), ...)
}

#' @export
#' @rdname scale_solarized
scale_colour_solarized <- function(accent="blue", ...) {
    discrete_scale("colour", "solarized", solarized_pal(accent), ...)
}
#' @export
#' @rdname scale_solarized
scale_color_solarized <- scale_colour_solarized

##' ggplot color theme based on the Solarized palette
##'
##' See \url{http://ethanschoonover.com/solarized} for a
##' description of the Solarized palette.
##'
##' Plots made with this theme integrate seamlessly with the Solarized
##' Beamer color theme.
##' \url{https://github.com/jrnold/beamercolorthemesolarized}.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @param light \code{logical}. Light or dark theme?
##' @export
##' @family themes
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'  + theme_solarized()
##'  + scale_colour_solarized("blue"))
##' ## Dark version
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'  + theme_solarized(light=FALSE)
##'  + scale_colour_solarized("blue"))
##' ## With panels
##' (qplot(carat, price, data=dsamp) + facet_wrap(~ clarity)
##'  + theme_solarized()
##'  + scale_colour_solarized("blue"))
theme_solarized <- function(base_size = 12, base_family="", light=TRUE) {
    rebase <- solarized_rebase(light)
    ret <- (theme_bw(base_size=base_size, base_family=base_family) +
            theme(text = element_text(colour=rebase['rebase0']),
                  title = element_text(color=rebase['rebase1']),
                  line = element_line(color=rebase['rebase0']),
                  rect = element_rect(fill=rebase['rebase03'], color=rebase['rebase0']),
                  axis.ticks = element_line(color=rebase['rebase0']),
                  axis.line = element_line(color=rebase['reabase01'], linetype=1),
                  legend.background = element_rect(fill=NULL, color=NA),
                  legend.key = element_rect(fill=NULL, colour=NULL, linetype=0),
                  panel.background = element_rect(fill=rebase['rebase03'], colour=rebase['rebase01']),
                  panel.border = element_blank(),
                  panel.grid = element_line(color=rebase['rebase02']),
                  panel.grid.major = element_line(color=rebase['rebase02']),
                  panel.grid.minor = element_line(color=rebase['rebase02']),
                  plot.background = element_rect(fill=NULL, colour=NA, linetype=0)
                  plot.background = element_rect(colour=NA, linetype=0)
            ))
    ret
}

