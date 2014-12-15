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
##' @param median.type One of \code{"box"}, \code{"line"}, or \code{"box"}. If \code{median.type="point"},
##' then use whitespace to represent the central quartiles and a point at the median.
##' If \code{median.type="box"}, then use a box to represent the standard error of the median. This
##' is similar to what the \code{notch} option does in a standard boxplot.
##' the same thing as the notch does in a standard boxplot.
##' If \code{median.type="line"}, the use offset lines to represent the central quartile and whitespace at the median
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
##' p + geom_tufteboxplot(median.type="box", fatten=1)
##' ## using lines
##' p + geom_tufteboxplot(median.type="line")
##'
geom_tufteboxplot <- function (mapping = NULL, data = NULL, stat = "boxplot",
                               position = "dodge",
                               outlier.colour = "black", outlier.shape = 16,
                               outlier.size = 2, fatten=4,
                               median.type = "point",
                               boxwidth = 0.25, ...) {
    GeomTufteboxplot$new(mapping = mapping, data = data, stat = stat,
                         position = position, outlier.colour = outlier.colour,
                         outlier.shape = outlier.shape,
                         outlier.size = outlier.size, fatten = fatten,
                         median.type = median.type, boxwidth = boxwidth,
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
                   outlier.shape = NULL, outlier.size = 2, fatten=4,
                   median.type=c("point", "box", "line"), boxwidth=0.05) {
    median.type <- match.arg(median.type)
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

    if (median.type == "box") {
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
    } else if (median.type == "line") {
      # draw two vertical lines for the central quartiles and two short
      # horizontal lines to connect them back to the whiskers
      boxdata <- data.frame(
        x = data$x,
        xend = data$x,
        y = c(data$upper, data$lower, data$upper, data$lower),
        yend = c(data$middle, data$middle, data$upper, data$lower),
        alpha = NA,
        common)
      box_grob <- GeomSegment$draw(boxdata, ...)

      # this offset seems to work nicely for a variety of sizes,
      # but it's totally a magic number
      offset <- 0.004

      # scale the offset by the size parameter
      x0_offset <- c(rep(offset * common$size, 2),
                     rep(offset * common$size * 1.2, 2))
      x1_offset <- c(rep(offset * common$size, 2),
                     rep(offset * common$size / -5, 2))

      # shift the points at the median so there will be whitespace
      y_offset <- c(1.5 * offset, -1.5 * offset, 0, 0)
      box_grob$x0 <- box_grob$x0 + unit(x0_offset, "npc")
      box_grob$x1 <- box_grob$x1 + unit(x1_offset, "npc")
      box_grob$y1 <- box_grob$y1 + unit(y_offset, "npc")

      # no point at the median
      middle_grob <- NULL
    } else if (median.type == "point") {
        box_grob <- NULL
        middle_grob <- GeomPoint$draw(transform(data, y=middle,
                                                size=size * fatten), ...)
    } else {
      stop("`median.type` must be one of \"point\", \"line\", or \"box\".")
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

