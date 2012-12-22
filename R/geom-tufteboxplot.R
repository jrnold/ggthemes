##' Tufte's Box Blot
##'
##' Edward Tufte's revision of the box plot erases the box and
##' replaces it with a single point and the whiskers.
##'
##' @section Aesthetics:
##' \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics("geom_tufteboxplot", ggthemes:::GeomTufteboxplot)}
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' McGill, R., Tukey, J. W. and Larsen, W. A. (1978) Variations of
##'     box plots. The American Statistician 32, 12-16.
##'
##' @seealso \code{\link{geom_boxplot}}
##' @inheritParams ggplot2::geom_point
##' @param outlier.colour colour for outlying points
##' @param outlier.shape shape of outlying points
##' @param outlier.size size of outlying points
##' @param fatten a multiplicative factor to fatten the middle point
##' (or line) by
##' @param usebox use a box to represent the standard error of the median;
##' the same thing as the notch does in a standard boxplot.
##' @param boxwidth a number between 0 and 1 which represents the
##' relative width of the box to the middle line.
##' @family geom tufte
##' @export
##'
##' @examples
##' p <- ggplot(mtcars, aes(factor(cyl), mpg))
##' ## with only a point
##' p + geom_tufteboxplot()
##' ## with a middle box
##' p + geom_tufteboxplot(usebox=TRUE, fatten=1)
##'
geom_tufteboxplot <- function (mapping = NULL, data = NULL, stat = "boxplot",
                               position = "dodge",
                               outlier.colour = "black", outlier.shape = 16,
                               outlier.size = 2, fatten=4,
                               usebox=FALSE, boxwidth=0.25, ...) {
    GeomTufteboxplot$new(mapping = mapping, data = data, stat = stat,
                         position = position, outlier.colour = outlier.colour,
                         outlier.shape = outlier.shape,
                         outlier.size = outlier.size, fatten=fatten,
                         usebox=usebox, boxwidth=boxwidth,
                         ...)
}

GeomTufteboxplot <- proto(ggplot2:::Geom, {
  objname <- "tufteboxplot"

  reparameterise <- function(., df, params) {
    df$width <- (df$width %||%
                 params$width %||%
                 (resolution(df$x, FALSE) * 0.1))
    if (!is.null(df$outliers)) {
      suppressWarnings({
        out_min <- vapply(df$outliers, min, numeric(1))
        out_max <- vapply(df$outliers, max, numeric(1))
      })
      df$ymin_final <- pmin(out_min, df$ymin)
      df$ymax_final <- pmax(out_max, df$ymax)
    }
    df <- transform(df,
              xmin = x - width / 2,
              xmax = x + width / 2,
              width = NULL
    )
    df
  }

  draw <- function(., data, ..., outlier.colour = NULL,
                   outlier.shape = NULL, outlier.size = 2, fatten=4, usebox=FALSE, boxwidth=0.05) {
    common <- data.frame(
        colour = data$colour,
        size = data$size,
        linetype = data$linetype,
        fill = alpha(data$fill, data$alpha),
        group = NA,
        stringsAsFactors = FALSE
    )

    whiskers <- data.frame(
      x = data$x,
      xend = data$x,
      y = c(data$upper, data$lower),
      yend = c(data$ymax, data$ymin),
      alpha = NA,
      common)

    if (usebox) {
        convexcomb <- function(a, x1, x2) {a * x1 + (1 - a) * x2}

        boxdata <-
            data.frame(
                xmin = convexcomb(boxwidth, data$xmin, data$x),
                xmax = convexcomb(boxwidth, data$xmax, data$x),
                ymin = data$notchlower,
                ymax = data$notchupper,
                alpha = data$alpha,
                common)
        box_grob <- GeomRect$draw(boxdata, ...)
        middle_grob <- GeomSegment$draw(transform(data,
                                                  x=xmin, xend=xmax,
                                                  y=middle, yend=middle,
                                                  size=size * fatten), ...)
    } else {
        box_grob <- NULL
        middle_grob <- GeomPoint$draw(transform(data, y=middle,
                                                size=size * fatten), ...)
    }

    if (!is.null(data$outliers) && length(data$outliers[[1]] >= 1)) {
      outliers <- data.frame(
          y = data$outliers[[1]],
          x = data$x[1],
          colour = outlier.colour %||% data$colour[1],
          shape = outlier.shape %||% data$shape[1],
          size = outlier.size %||% data$size[1],
          fill = NA,
          alpha = NA,
          stringsAsFactors = FALSE)
      outliers_grob <- GeomPoint$draw(outliers, ...)
    } else {
      outliers_grob <- NULL
    }

    ggname(.$my_name(), grobTree(
        outliers_grob,
        box_grob,
        GeomSegment$draw(whiskers, ...),
        middle_grob
        ))
  }

  guide_geom <- function(.) "pointrange"
  default_stat <- function(.) StatBoxplot
  default_pos <- function(.) PositionDodge
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill="gray20", alpha = NA)
  required_aes <- c("x", "lower", "upper", "middle", "ymin", "ymax")

})

