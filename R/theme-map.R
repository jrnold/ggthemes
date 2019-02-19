#' Clean theme for maps
#'
#' A clean theme that is good for displaying maps from
#' \code{\link[ggplot2]{geom_map}()}.
#'
#' @inheritParams ggplot2::theme_grey
#' @example inst/examples/ex-theme_map.R
#' @export
#' @importFrom ggplot2 %+replace%
theme_map <- function(base_size = 9, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          panel.grid = element_blank(),
          panel.spacing = unit(0, "lines"),
          plot.background = element_blank(),
          legend.justification = c(0, 0),
          legend.position = c(0, 0))
}
