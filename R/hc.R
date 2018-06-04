#' Highcharts Themes
#'
#' Themes inspired by \href{Highcharts JS}{https://www.highcharts.com/} themes.
#' \itemize{
#'   \item{\href{http://www.highcharts.com/demo}{default}}
#'   \item{\href{http://www.highcharts.com/demo/line-basic/dark-unica}{darkunica}}
#' }
#'
#' This theme should be used with the \code{\link{scale_color_hc}} color
#' palette.
#'
#' @references
#'
#' \url{http://www.highcharts.com/demo/line-basic}
#'
#' \url{https://github.com/highslide-software/highcharts.com/tree/master/js/themes}
#'
#' @inheritParams ggplot2::theme_bw
#' @param hc_theme The name of Highcharts theme the theme is based on.
#' @param bgcolor Deprecated. Use \code{hc_theme}.
#' @example inst/examples/ex-theme_hc.R
#' @family themes hc
#' @export
theme_hc <- function(base_size = 12,
                     base_family = "sans",
                     hc_theme = c("default", "darkunica"),
                     bgcolor = NULL) {

  if (!is.null(bgcolor)) {
    warning("`bgcolor` is deprecated. Use `name`")
  }
  hc_theme <- match.arg(hc_theme)
  bgcol <- switch(hc_theme,
                  default = "#FFFFFF",
                  "darkunica" = "#2a2a2b")

  ret <- theme(rect = element_rect(fill = bgcol, linetype = 0, colour = NA),
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

  if (hc_theme == "darkunica") {
    ret <- (ret + theme(rect = element_rect(fill = bgcol),
                        text = element_text(colour = "#A0A0A3"),
                        title = element_text(colour = "#FFFFFF"),
                        axis.title.x = element_text(colour = "#A0A0A3"),
                        axis.title.y = element_text(colour = "#A0A0A3"),
                        panel.grid.major.y = element_line(colour = "#707073"),
                        legend.title = element_text(colour = "#A0A0A3")))
  }
  ret
}

#' Highcharts color palettes (discrete)
#'
#' Color palettes used in selected \code{Highcharts JS}{https://www.highcharts.com/}
#' themes.
#' These palettes should be used with the \code{\link{theme_hc}} theme
#' with the \code{hc_theme} argument of the same name.
#'
#' @section Palettes:
#'
#' The following palettes are defined,
#'
#' \itemize{
#'   \item{\href{http://www.highcharts.com/demo}{default}}
#'   \item{\href{http://www.highcharts.com/demo/line-basic/dark-unica}{dark-unica}}
#' }
#'
#' @param palette \code{character} The name of the palette to use. If used
#'   with \code{\link{theme_hc}} this should be the same as the \code{hc_theme}
#'   passed to it.
#' @family colour hc
#' @export
hc_pal <- function(palette = "default") {
  palnames <- names(ggthemes::ggthemes_data$hc)
  if (!palette %in% names(palnames)) {
    manual_pal(unname(ggthemes::ggthemes_data$hc[[palette]]))
  } else {
    stop("Palette `", palette, "` not valid. Must be one of ",
         stringr::str_c("`", palnames, "`", collapse = ", "), ".",
         call. = FALSE)
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
