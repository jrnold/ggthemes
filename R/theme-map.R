#' Clean theme for maps
#'
#' A clean theme that is good for displaying maps from \code{\link{geom_map}}.
#'
#' @inheritParams ggplot2::theme_grey
#' @examples
#' library("maps")
#' library("ggplot2")
#' us <- fortify(map_data('state'), region = 'region')
#' gg <-
#'  (ggplot()
#'   + geom_map(data  =  us, map = us,
#'              aes(x = long, y = lat, map_id = region, group = group),
#'              fill = 'white', color = 'black', size = 0.25)
#'   + coord_map('albers', lat0 = 39, lat1 = 45)
#'   + theme_map()
#'   )
#' gg
#'
#' @export
theme_map <- function(base_size = 9, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          panel.grid = element_blank(),
          panel.margin = unit(0, "lines"),
          plot.background = element_blank(),
          legend.justification = c(0, 0),
          legend.position = c(0, 0))
}
