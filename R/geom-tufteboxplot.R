#' Tufte's Box Blot
#'
#' Edward Tufte's revisions of the box plot as described in
#' \emph{The Visual Display of Quantitative Information}.
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
#' @param outlier.stroke stroke for outlying points
#' @param median.type If \code{'point'}, then the median is represented by a point, and the interquartile range by a gap in the line. If \code{median.type='line'}, then the interquartile range is represented by a line, possibly offset, and the median by a gap in the line.
#' @param whisker.type If \code{'line'}, then whiskers are represented by lines. If \code{'point'}, then whiskers are represented by points at \code{ymin} and \code{ymax}.
#' @param voffset controls the size of the gap in the line representing the median when \code{median.type = 'line'}. This is a fraction of the range of \code{y}.
#' @param hoffset controls how much the interquartile line is offset from the whiskers when \code{median.type = 'line'}. This is a fraction of the range of \code{x}.
#' @family geom tufte
#' @export
#'
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars, aes(factor(cyl), mpg))
#' ## with a point for the median and lines for whiskers
#' p + geom_tufteboxplot()
#' ## with a line for the interquartile range and points for whiskers
#' p + geom_tufteboxplot(median.type = "line", whisker.type = "point", hoffset = 0)
#' ## with a wide line for the interquartile range and lines for whiskers
#' p + geom_tufteboxplot(median.type = "line", hoffset = 0, width = 3)
#' ## with an offset line for the interquartile range and lines for whiskers
#' p + geom_tufteboxplot(median.type='line')
#'
geom_tufteboxplot <-
  function(mapping = NULL,
           data = NULL,
           stat = "fivenumber",
           position = "identity",
           outlier.colour = "black",
           outlier.shape = 19,
           outlier.size = 1.5,
           outlier.stroke = 0.5,
           voffset = 0.01,
           hoffset = 0.005,
           na.rm = FALSE,
           show.legend = NA,
           inherit.aes = TRUE,
           median.type = "point",
           whisker.type = "line",
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
        voffset = voffset,
        hoffset = hoffset,
        median.type = median.type,
        whisker.type = whisker.type,
        na.rm = na.rm,
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
          setup_data = function(self, data, params) {
            data <- ggproto_parent(GeomBoxplot, self)$setup_data(data, params)
            x_range <- diff(range(data$x))
            y_range <- max(data$ymax) - min(data$ymin)
            data$hoffset <- params$hoffset * x_range
            data$voffset <- params$voffset * y_range
            data
          },
          draw_group = function(data, panel_scales, coord, fatten = 2,
                                outlier.colour = "black", outlier.shape = 19,
                                outlier.size = 1.5, outlier.stroke = 0.5,
                                varwidth = FALSE,
                                median.type = c("point", "line"),
                                whisker.type = c("line", "point"),
                                hoffset = 0.01,
                                voffset = 0.01
          ) {
            median.type <- match.arg(median.type)
            whisker.type <- match.arg(whisker.type)

            common <- data.frame(
              colour = data$colour,
              linetype = data$linetype,
              fill = alpha(data$fill, data$alpha),
              stroke = data$stroke,
              shape = data$shape,
              group = data$group,
              stringsAsFactors = FALSE
            )

            if (whisker.type == "line") {
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
              whiskers_grob <-
                GeomSegment$draw_panel(whiskers, panel_scales, coord)
            } else if (whisker.type == "point") {
              whiskers <- data.frame(
                x = data$x,
                y = c(data$ymin, data$ymax),
                size = data$size,
                alpha = data$alpha,
                common,
                stringsAsFactors = FALSE
              )
              whiskers_grob <-
                GeomPoint$draw_panel(whiskers, panel_scales, coord)
            }

            if (median.type == "point") {
              middata <- data.frame(
                x = data$x,
                y = data$middle,
                size = data$size * data$width,
                alpha = data$alpha,
                common,
                stringsAsFactors = FALSE
              )
              middle_grob <- GeomPoint$draw_panel(middata, panel_scales, coord)
            } else if (median.type == "line") {
              middata <- data.frame(
                y = c(data$upper, data$middle) + c(0, - data$voffset / 2),
                yend = c(data$middle, data$lower) +  c(data$voffset / 2, 0),
                x = data$x + data$hoffset,
                xend = data$x + data$hoffset,
                size = data$size * data$width,
                alpha = data$alpha,
                common,
                stringsAsFactors = FALSE
              )
              middle_grob <- GeomSegment$draw_panel(middata, panel_scales, coord)

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
                            width = 1,
                            linetype = "solid",
                            outlier.colour = "black",
                            outlier.shape = 19,
                            outlier.size = 1.5,
                            outlier.stroke = 0.5)
  )
