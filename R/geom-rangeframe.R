#' Range Frames
#'
#' Axis lines which extend to the maximum and minimum of the plotted data.
#'
#' @section Aesthetics:
#' \itemize{
#' \item colour
#' \item size
#' \item linetype
#' \item alpha
#' }
#'
#' @inheritParams ggplot2::geom_point
#' @param sides A string that controls which sides of the plot the frames appear on.
#'   It can be set to a string containing any of \code{'trbl'}, for top, right,
#'   bottom, and left.
#' @export
#'
#' @references Tufte, Edward R. (2001) The Visual Display of
#' Quantitative Information, Chapter 6.
#'
#' @family geom tufte
#' @examples
#' library("ggplot2")
#' ggplot(mtcars, aes(wt, mpg)) +
#'  geom_point() +
#'  geom_rangeframe() +
#'  theme_tufte()
geom_rangeframe <- function(mapping = NULL, data = NULL, stat = "identity",
                            position = "identity", sides = "bl",
                            na.rm = FALSE, show.legend = NA,
                            inherit.aes = TRUE, ...) {

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomRangeFrame,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(sides = sides,
                  na.rm = na.rm,
                  ...)
  )
}

#' @rdname geom_rangeframe
#' @usage NULL
#' @format NULL
#' @export
GeomRangeFrame <-
  ggproto("GeomRangeFrame", Geom,
          draw_panel = function(data, panel_scales, coord, sides = "bl") {
            rugs <- list()
            data <- coord$transform(data, panel_scales)

            gp <- gpar(col = alpha(data$colour, data$alpha),
                       lty = data$linetype,
                       lwd = data$size * .pt)
            if (!is.null(data$x)) {
              if (grepl("b", sides)) {
                rugs$x_b <-
                  segmentsGrob(x0 = unit(min(data$x), "native"),
                               x1 = unit(max(data$x), "native"),
                               y0 = unit(0, "npc"),
                               y1 = unit(0, "npc"),
                               gp = gp)
              }

              if (grepl("t", sides)) {
                rugs$x_t <-
                  segmentsGrob(x0 = unit(min(data$x), "native"),
                               x1 = unit(max(data$x), "native"),
                               y0 = unit(1, "npc"),
                               y1 = unit(1, "npc"),
                               gp = gp)
              }
            }

            if (!is.null(data$y)) {
              if (grepl("l", sides)) {
                rugs$y_l <-
                  segmentsGrob(y0 = unit(min(data$y), "native"),
                               y1 = unit(max(data$y), "native"),
                               x0 = unit(0, "npc"),
                               x1 = unit(0, "npc"),
                               gp = gp)
              }

              if (grepl("r", sides)) {
                rugs$y_r <-
                  segmentsGrob(y0 = unit(min(data$y), "native"),
                               y1 = unit(max(data$y), "native"),
                               x0 = unit(1, "npc"),
                               x1 = unit(1, "npc"),
                               gp = gp)
              }
            }
            gTree(children = do.call("gList", rugs))
          },

          default_aes = aes(colour = "black", size = 0.5,
                            linetype = 1, alpha = NA),
          draw_legend = draw_key_path
  )
