#' Range Frames
#'
#' Axis lines which extend to the maximum and minimum of the plotted data.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggthemes:::rd_aesthetics('geom_tufteboxplot', ggthemes:::GeomRangeFrame)}
#'
#' @inheritParams ggplot2::geom_point
#' @param sides A string that controls which sides of the plot the frames appear on.
#'   It can be set to a string containing any of \code{'trbl'}, for top, right,
#'   bottom, and left.
#' @param fun_max Function used to calculate the minimum of the range frame line.
#' @param fun_min Function used to calculate the maximum of the range frame line.
#' @export
#'
#' @references Tufte, Edward R. (2001) The Visual Display of
#' Quantitative Information, Chapter 6.
#'
#' @family geom tufte
#' @examples
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point() + geom_rangeframe()
#'  + theme_tufte())
geom_rangeframe <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", sides = "bl", fun_min = min,
  fun_max = max, ..., show.legend = NA, inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomRangeFrame,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    geom_params = list(sides = sides, fun_min = fun_min, fun_max = fun_max),
    params = list(...)
  )
}

GeomRangeFrame <- ggproto("GeomRangeFrame", Geom,
  draw = function(self, data, scales, coord, sides, fun_min, fun_max, ...) {
    rugs <- list()
    data <- coord$transform(data, scales)
    if (!is.null(data$x)) {
      if (grepl("b", sides)) {
        rugs$x_b <- grid::segmentsGrob(x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"), y0 = unit(0,
          "npc"), y1 = unit(0, "npc"), gp = grid::gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size *
          .pt))
      }

      if (grepl("t", sides)) {
        rugs$x_t <- grid::segmentsGrob(x0 = unit(fun_min(data$x), "native"), x1 = unit(fun_max(data$x), "native"), y0 = unit(1,
          "npc"), y1 = unit(1, "npc"), gp = grid::gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size *
          .pt))
      }
    }

    if (!is.null(data$y)) {
      if (grepl("l", sides)) {
        rugs$y_l <- grid::segmentsGrob(y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"), x0 = unit(0,
          "npc"), x1 = unit(0, "npc"), gp = grid::gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size *
          .pt))
      }

      if (grepl("r", sides)) {
        rugs$y_r <- grid::segmentsGrob(y0 = unit(fun_min(data$y), "native"), y1 = unit(fun_max(data$y), "native"), x0 = unit(1,
          "npc"), x1 = unit(1, "npc"), gp = grid::gpar(col = alpha(data$colour, data$alpha), lty = data$linetype, lwd = data$size *
          .pt))
      }
    }
    grid::gTree(children = do.call(grid::gList, rugs))
  },

  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),
  draw_legend = draw_key_path
)

