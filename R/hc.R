#' Highcharts Theme
#'
#' Theme based on \href{https://www.highcharts.com/}{Highcharts} plots.
#'
#' @references
#'
#' \url{https://www.highcharts.com/demo/highcharts/line-chart}
#'
#' @inheritParams ggplot2::theme_bw
#' @param style The Highcharts theme to use \code{'default'},
#'   \code{'darkunica'}.
#' @param bgcolor Deprecated
#' @example inst/examples/ex-theme_hc.R
#' @family themes hc
#' @export
theme_hc <- function(base_size = 12,
                     base_family = "sans",
                     style = c("default", "darkunica"),
                     bgcolor = NULL) {

  if (!is.null(bgcolor)) {
    warning("`bgcolor` is deprecated. Use `style` instead.")
    style <- bgcolor
  }
  style <- match.arg(style)
  bgcolor <- switch(style,
                    default = "#FFFFFF",
                    "darkunica" = "#2a2a2b")

  ret <- theme(rect = element_rect(fill = bgcolor, linetype = 0, colour = NA),
               text = element_text(size = base_size, family = base_family),
               title = element_text(hjust = 0.5),
               axis.title.x = element_text(hjust = 0.5),
               axis.title.y = element_text(hjust = 0.5),
               panel.grid.major.y = element_line(colour = "#D8D8D8"),
               panel.grid.minor.y = element_blank(),
               panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank(),
               panel.border = element_blank(),
               panel.background = element_blank(),
               legend.position = "bottom",
               legend.key = element_rect(fill = "#FFFFFF00"))

  if (style == "darkunica") {
    ret <- (ret + theme(rect = element_rect(fill = bgcolor),
                        text = element_text(colour = "#A0A0A3"),
                        title = element_text(colour = "#FFFFFF"),
                        axis.title.x = element_text(colour = "#A0A0A3"),
                        axis.title.y = element_text(colour = "#A0A0A3"),
                        panel.grid.major.y = element_line(colour = "#707073"),
                        legend.title = element_text(colour = "#A0A0A3")))
  }
  ret
}


#' Highcharts color palette (discrete)
#'
#' The Highcharts uses many different color palettes in its
#' plots. This collects a few of them.
#'
#' @section Palettes:
#'
#' The following palettes are defined:
#'
#'
#' @param palette \code{character} The name of the Highcharts theme to use. One of
#'  \code{"default"}, or \code{"darkunica"}.
#'
#' @family colour hc
#' @export
hc_pal <- function(palette = "default") {
  if (palette %in% names(ggthemes::ggthemes_data$hc)) {
    manual_pal(unname(ggthemes::ggthemes_data$hc[[palette]]))
  } else {
    stop("Palette `", palette, "` not valid. Must be one of ",
         stringr::str_c("`", names(ggthemes::ggthemes_data$hc),
                        "`", collapse = ", "),
         call. = FALSE)
  }
}

#' Highcharts color and fill scales
#'
#' Colour and fill scales which use the palettes in
#' \code{\link{hc_pal}()} and are meant for use with
#' \code{\link{theme_hc}()}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams hc_pal
#' @family colour hc
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
