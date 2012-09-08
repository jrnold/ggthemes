##' Tufte Data-Ink Maximized Theme
##'
##' Theme based on Chapter 6 "Data-Ink Maximization and Graphical
##' Design" of Edward Tufte *The Visual Display of Quantitative
##' Information*. No border, no axis lines, no grids. This theme works
##' best in combination with \code{\link{geom_rug}} or
##' \code{\link{geom_range_frame}}.
##'
##' @param ticks \code{logical} Show axis ticks?
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @examples
##' # with ticks and range frames
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_range_frame()
##'  + theme_tufte())
##' # with geom_rug
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_rug()
##'  + theme_tufte(ticks=FALSE))
##' @export
theme_tufte <- function(ticks=TRUE) {
    ret <- theme_bw() +
        theme(panel.border = element_blank(),
              panel.background = element_rect(fill=NA, linetype=0),
              axis.line = element_blank(),
              legend.background = element_rect(fill=NA, linetype=0),
              legend.key = element_rect(fill=NA, linetype=0),
              panel.grid = element_blank(),
              plot.background = element_rect(fill="white", linetype=0))
    if (!ticks) {
        ret <- ret + theme(axis.ticks = element_blank())
    }
    ret
}

##' Range Frames
##'
##' Axis lines which show the  maximum and minimum of the data plotted.
##'
##' @section Aesthetics:
##' \code{geom_RangeFrame} understands the following aesthetics (required aesthetics are in bold):
##'
##' \itemize{
##'   \item \code{alpha}
##'   \item \code{colour}
##'   \item \code{linetype}
##'   \item \code{size}
##' }
##'
##' @inheritParams ggplot2::geom_point
##' @param sides A string that controls which sides of the plot the frames appear on.
##'   It can be set to a string containing any of \code{"trbl"}, for top, right,
##'   bottom, and left.
##' @param fun_max Function used to calculate the minimum of the range frame line.
##' @param fun_min Function used to calculate the maximum of the range frame line.
##' @export
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @examples
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_range_frame()
##'  + theme_tufte())
geom_range_frame <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", sides = "bl",fun_min = min, fun_max = max, ...) {
  GeomRangeFrame$new(mapping = mapping, data = data, stat = stat, position = position,
                     sides = sides,
                     fun_min = match.fun(fun_min), fun_max = match.fun(fun_max),
                     ...)
}

GeomRangeFrame <- proto(ggplot2:::Geom, {
    objname <- "rangeframe"

    draw <- function(., data, scales, coordinates, sides, fun_min, fun_max, ...) {
        rugs <- list()
        data <- coord_transform(coordinates, data, scales)
        if (!is.null(data$x)) {
            if(grepl("b", sides)) {
                rugs$x_b <- segmentsGrob(
                    x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"),
                    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }

            if(grepl("t", sides)) {
                rugs$x_b <- segmentsGrob(
                    x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"),
                    y0 = unit(1, "npc"), y1 = unit(1, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }
        }

        if (!is.null(data$y)) {
            if(grepl("l", sides)) {
                rugs$y_l <- segmentsGrob(
                    y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"),
                    x0 = unit(0, "npc"), x1 = unit(0.0, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }

            if(grepl("r", sides)) {
                rugs$y_r <- segmentsGrob(
                    y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"),
                    x0 = unit(1, "npc"), x1 = unit(1, "npc"),
                    gp = gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size * .pt)
                    )
            }
        }
        gTree(children = do.call("gList", rugs))
    }

    default_stat <- function(.) StatIdentity
    default_aes <- function(.) aes(colour="black", size=0.5, linetype=1, alpha = NA)
    guide_geom <- function(.) "path"
})
