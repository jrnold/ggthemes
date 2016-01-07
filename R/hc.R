#' Highcharts JS theme
#'
#' Theme based on the plots in \emph{Highcharts JS}.
#'
#' @references
#'
#' \url{http://www.highcharts.com/demo/line-basic}
#'
#' \url{https://github.com/highslide-software/highcharts.com/tree/master/js/themes}
#'
#' @inheritParams ggplot2::theme_bw
#' @param bgcolor The background color of plot. One of \code{'default',
#' 'darkunica'}, the names of values in
#' \code{ggthemes_data$hc$bg}.
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
#'      colour=factor(gear))) + facet_wrap(~am)
#' p + theme_hc() + scale_colour_hc()
#' p + theme_hc(bgcolor = 'darkunica') + scale_colour_hc('darkunica')
#' @export
theme_hc <- function(base_size = 12,
                     base_family = "sans",
                     bgcolor = "default") {
  bgcol <- ggthemes_data$hc$bg[bgcolor]

  ret <- theme(rect = element_rect(fill = bgcol, linetype = 0, colour = NA),
               text = element_text(size = base_size, family = base_family),
               title = element_text(hjust = 0.5),
               axis.title.x = element_text(hjust = 0.5),
               axis.title.y = element_text(hjust = 0.5),
               panel.grid.major.y = element_line(color = "gray"),
               panel.grid.minor.y = element_blank(),
               panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank(),
               panel.border = element_blank(),
               panel.background = element_blank(),
               legend.position = "bottom",
               legend.key = element_rect(fill = "#FFFFFF00"))

  if (bgcolor == "darkunica") {
    ret <- (ret + theme(rect = element_rect(fill = bgcol),
                        text = element_text(colour = "#A0A0A3"),
                        title = element_text(colour = "#FFFFFF"),
                        axis.title.x = element_text(colour = "#A0A0A3"),
                        axis.title.y = element_text(colour = "#A0A0A3"),
                        panel.grid.major.y = element_line(color = "gray"),
                        legend.title = element_text(colour = "#A0A0A3")))
  }
  ret
}


#' Highcharts JS color palette (discrete)
#'
#' The Highcharts JS uses many different color palettes in its
#' plots. This collects a few of them.
#'
#' @section Palettes:
#'
#' The following palettes are defined,
#'
#' \describe{
#' \item{default}{#7cb5ec, #434348, #90ed7d, #f7a35c, #8085e9, #f15c80',
#' #e4d354, #8085e8, #8d4653, #91e8e1 theme.
#' Examples: \url{http://www.highcharts.com/demo}.}
#' \item{darkunica}{#2b908f, #90ee7e, #f45b5b, #7798BF, #aaeeee,
#' #ff0066, #eeaaee, #55BF3B, #DF5353, #7798BF, #aaeeee'. Examples:
#' \url{http://www.highcharts.com/demo/line-basic/dark-unica}.}
#' }
#'
#' @param palette \code{character} The color palette to use. This
#' must be a name in
#' \code{\link[=ggthemes_data]{ggthemes_data$hc$palettes}}.
#'
#' @family colour hc
#' @export
hc_pal <- function(palette = "default") {
  if (palette %in% names(ggthemes_data$hc$palettes)) {
    manual_pal(unname(ggthemes_data$hc$palettes[[palette]]))
  } else {
    stop(sprintf("palette %s not a valid palette.", palette))
  }
}

#' Highcharts color and fill scales
#'
#' Colour and fill scales which use the palettes in
#' \code{\link{hc_pal}} and are meant for use with
#' \code{\link{theme_hc}}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams hc_pal
#' @family colour_hc
#' @rdname scale_hc
#' @export
scale_colour_hc <- function(palette = "default", ...) {
  discrete_scale("colour", "hc", hc_pal(palette), ...)
}

#' @rdname scale_hc
#' @export
scale_color_hc <- scale_colour_hc

#' @rdname scale_hc
#' @export
scale_fill_hc <- function(palette = "default", ...) {
  discrete_scale("fill", "hc", hc_pal(palette), ...)
}
