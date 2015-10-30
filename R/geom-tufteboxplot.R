#' Tufte's Box Blot
#'
#' Edward Tufte's revision of the box plot erases the box and
#' replaces it with a single point and the whiskers.
#'
#' @section Aesthetics:
#' \itemize{
#' \item x [required]
#' \item y [required]
#' \item colour
#' \item size
#' \item linetype
#' \item shape
#' \item fill
#' \item alpha
#' }
#'
#' @references Tufte, Edward R. (2001) The Visual Display of
#' Quantitative Information, Chapter 6.
#'
#' McGill, R., Tukey, J. W. and Larsen, W. A. (1978) Variations of
#'     box plots. The American Statistician 32, 12-16.
#'
#' @seealso \code{\link{geom_boxplot}}
#' @inheritParams ggplot2::geom_point
#' @param outlier.colour colour for outlying points
#' @param outlier.shape shape of outlying points
#' @param outlier.size size of outlying points
#' @param fatten a multiplicative factor to fatten the middle point or line) by
#' @param median.type One of \code{'box'}, \code{'line'}, or \code{'box'}. If \code{median.type='point'},
#' then use whitespace to represent the central quartiles and a point at the median.
#' If \code{median.type='box'}, then use a box to represent the standard error of the median. This
#' is similar to what the \code{notch} option does in a standard boxplot.
#' the same thing as the notch does in a standard boxplot.
#' If \code{median.type='line'}, the use offset lines to represent the central quartile and whitespace at the median
#' @family geom tufte
#' @export
#'
#' @examples
#' p <- ggplot(mtcars, aes(factor(cyl), mpg))
#' ## with only a point
#' p + geom_tufteboxplot()
#' ## with a middle box
#' p + geom_tufteboxplot(median.type='box', fatten=1)
#' ## using lines
#' p + geom_tufteboxplot(median.type='line')
#'
geom_tufteboxplot <-
  function(mapping = NULL, data = NULL, stat = "boxplot",
           position = "dodge", outlier.colour = "black",
           outlier.shape = 19, outlier.size = 1.5,
           outlier.stroke = 0.5,
           varwidth = FALSE, na.rm = FALSE,
           show.legend = NA, inherit.aes = TRUE,
           median.type = c("point", "box", "line"),
           ...) {
    layer(
      data = data,
      mapping = mapping,
      stat = stat,
      geom = GeomTufteboxplot,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(
        outlier.colour = outlier.colour,
        outlier.shape = outlier.shape,
        outlier.size = outlier.size,
        outlier.stroke = outlier.stroke,
        varwidth = varwidth,
        na.rm = na.rm,
        median.type = median.type,
        ...
      )
    )
  }

#' @rdname geom_tufteboxplot
#' @usage NULL
#' @format NULL
#' @export
GeomTufteboxplot <-
  ggproto("GeomTufteboxplot",
          GeomBoxplot,
          draw_group = function(data, panel_scales, coord, fatten = 2,
                                outlier.colour = "black", outlier.shape = 19,
                                outlier.size = 1.5, outlier.stroke = 0.5,
                                varwidth = FALSE,
                                median.type = c("point", "line", "crossbar")
          ) {
            median.type <- match.arg(median.type)
            common <- data.frame(
              colour = data$colour,
              linetype = data$linetype,
              fill = alpha(data$fill, data$alpha),
              stroke = data$stroke,
              shape = data$shape,
              group = data$group,
              stringsAsFactors = FALSE
            )

            whiskers <- data.frame(
              x = data$x,
              xend = data$x,
              y = c(data$upper, data$lower),
              yend = c(data$ymax, data$ymin),
              size = data$size,
              alpha = data$alpha,
              common,
              stringsAsFactors = FALSE
            )
            whiskers_grob <- GeomSegment$draw_panel(whiskers, panel_scales, coord)

            if (median.type == "point") {
              middata <- data.frame(
                x = data$x,
                y = data$middle,
                size = data$size,
                alpha = data$alpha,
                common,
                stringsAsFactors = FALSE
              )

              middle_grob <- GeomPoint$draw_panel(middata, panel_scales, coord)
            } else if (median.type == "line") {
              middata <- data.frame(
                y = c(data$upper, data$middle),
                yend = c(data$middle, data$lower),
                x = data$x,
                xend = data$x,
                size = data$size,
                alpha = data$alpha,
                common,
                stringsAsFactors = FALSE
              )

              middle_grob <- GeomSegment$draw_panel(middata, panel_scales, coord)

              # this offset seems to work nicely for a variety of sizes
              # but it's totally a magic number
              offset <- 0.004
              voffset <- 1

              # TODO: Could this be done with PositionDodge?
              # scale the offset by the size parameter
              middle_grob$x0 <- middle_grob$x0 + unit(rep(offset, 2), "npc")
              middle_grob$x1 <- middle_grob$x1 + unit(rep(offset, 2), "npc")

            } else if (median.type == "crossbar") {
                middle_grob <- NULL
            }

            if (!is.null(data$outliers) && length(data$outliers[[1]] >= 1)) {
              outliers <- data.frame(
                y = data$outliers[[1]],
                x = data$x[1],
                colour = outlier.colour %||% data$colour[1],
                shape = outlier.shape %||% data$shape[1],
                size = outlier.size %||% data$size[1],
                stroke = outlier.stroke %||% data$stroke[1],
                fill = NA,
                alpha = NA,
                stringsAsFactors = FALSE
              )
              outliers_grob <- GeomPoint$draw_panel(outliers, panel_scales, coord)
            } else {
              outliers_grob <- NULL
            }

            ggname("geom_tufteboxplot",
                   grobTree(
                     outliers_grob,
                     whiskers_grob,
                     middle_grob
                   ))
          },
          draw_legend = draw_key_pointrange,
          default_aes = aes(weight = 1,
                            colour = "black",
                            fill = "grey20",
                            size = 0.5,
                            alpha = NA,
                            shape = 19,
                            stroke = 0.5,
                            linetype = "solid",
                            outlier.colour = "black",
                            outlier.shape = 19,
                            outlier.size = 1.5,
                            outlier.stroke = 0.5)
  )
