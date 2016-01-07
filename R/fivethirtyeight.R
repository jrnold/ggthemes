#' @include ggthemes-package.R
#' @include ggthemes-data.R
NULL

#' Theme inspired by fivethirtyeight.com plots
#'
#' Theme inspired by the plots on
#' \href{fivethirtyeight.com}{http://fivethirtyeight.com}.
#'
#' @inheritParams ggplot2::theme_grey
#' @family themes fivethirtyeight
#' @export
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am) +
#'      geom_smooth(method = "lm", se = FALSE) +
#'      scale_color_fivethirtyeight() +
#'      theme_fivethirtyeight()
theme_fivethirtyeight <- function(base_size = 12, base_family = "sans") {
  (theme_foundation(base_size = base_size, base_family = base_family)
   + theme(
     line = element_line(colour = "black"),
     rect = element_rect(fill = ggthemes_data$fivethirtyeight["ltgray"],
                         linetype = 0, colour = NA),
     text = element_text(colour = ggthemes_data$fivethirtyeight["dkgray"]),
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
       element_line(colour = ggthemes_data$fivethirtyeight["medgray"]),
     panel.grid.minor = element_blank(),
     # unfortunately, can't mimic subtitles
     plot.title = element_text(hjust = 0, size = rel(1.5), face = "bold"),
     plot.margin = unit(c(1, 1, 1, 1), "lines"),
     strip.background = element_rect()))
}

#' fivethirtyeight.com color palette
#'
#' The standard fivethirtyeight.com palette for line plots is blue, red, green.
#'
#' @family colour fivethirtyeight
#' @export
#' @examples
#' library("scales")
#' show_col(fivethirtyeight_pal()(3))
fivethirtyeight_pal <- function() {
  function(n) {
    colors <- ggthemes_data$fivethirtyeight[c("blue", "red", "green")]
    unname(colors[seq_len(n)])
  }
}

#' fivethirtyeight.com color scales
#'
#' Color scales using the colors in the fivethirtyeight graphics.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour fivethirtyeight
#' @rdname scale_fivethirtyeight
#' @seealso \code{\link{theme_fivethirtyeight}} for examples.
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
