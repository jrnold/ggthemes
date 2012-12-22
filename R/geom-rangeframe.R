##' Range Frames
##'
##' Axis lines which extend to the maximum and minimum of the plotted data.
##'
##' @section Aesthetics:
##' \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics("geom_tufteboxplot", ggthemes:::GeomRangeFrame)}
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
##' @family geom tufte
##' @examples
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_rangeframe()
##'  + theme_tufte())
geom_rangeframe <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", sides = "bl",fun_min = min, fun_max = max, ...) {
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
                rugs$x_t <- segmentsGrob(
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

