#' Theme inspired by FiveThirtyEight plots
#'
#' Theme inspired by the plots from FiveThirtyEight.com.
#'
#' @inheritParams ggplot2::theme_grey
#' @family themes fivethirtyeight
#' @export
#' @example inst/examples/ex-theme_fivethirtyeight.R
#' @importFrom grid unit
theme_fivethirtyeight <- function(base_size = 12, base_family = "sans") {
  colors <- deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
  (theme_foundation(base_size = base_size, base_family = base_family)
   + theme(
     line = element_line(colour = "black"),
     rect = element_rect(fill = colors["Light Gray"],
                         linetype = 0, colour = NA),
     text = element_text(colour = colors["Dark Gray"]),
     axis.title = element_blank(),
     axis.text = element_text(),
     axis.ticks = element_blank(),
     axis.line = element_blank(),
     legend.background = element_rect(),
     legend.position = "bottom",
     legend.direction = "horizontal",
     legend.box = "vertical",
     panel.grid = element_line(colour = NULL),
     panel.grid.major =
       element_line(colour = colors["Medium Gray"]),
     panel.grid.minor = element_blank(),
     # unfortunately, can't mimic subtitles TODO!
     plot.title = element_text(hjust = 0, size = rel(1.5), face = "bold"),
     plot.margin = unit(c(1, 1, 1, 1), "lines"),
     strip.background = element_rect()))
}

#' FiveThirtyEight color palette
#'
#' The standard three-color FiveThirtyEight palette for line plots comprises
#' blue, red, and green.
#'
#' @family colour fivethirtyeight
#' @export
#' @example inst/examples/ex-fivethirtyeight_pal.R
fivethirtyeight_pal <- function() {
  colors <- deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
  values <- unname(colors[c("Blue", "Red", "Green")])
  max_n <- length(values)
  f <- manual_pal(values)
  attr(f, "max_n") <- max_n
  f
}

#' FiveThirtyEight color scales
#'
#' Color scales using the colors in the FiveThirtyEight graphics.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour fivethirtyeight
#' @rdname scale_fivethirtyeight
#' @seealso \code{\link{theme_fivethirtyeight}()} for examples.
#' @export
scale_colour_fivethirtyeight <- function(...) {
  discrete_scale("colour", "economist", fivethirtyeight_pal(), ...)
}

#' @rdname scale_fivethirtyeight
#' @export
scale_color_fivethirtyeight <- scale_colour_fivethirtyeight

#' @rdname scale_fivethirtyeight
#' @export
scale_fill_fivethirtyeight <- function(...) {
  discrete_scale("fill", "economist", fivethirtyeight_pal(), ...)
}
