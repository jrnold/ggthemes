#' Wall Street Journal theme
#'
#' Theme based on the plots in \emph{The Wall Street Journal}.
#'
#' @references
#'
#' \url{https://twitter.com/WSJGraphics}
#'
#' \url{https://pinterest.com/wsjgraphics/wsj-graphics/}
#'
#' @inheritParams ggplot2::theme_grey
#' @param color The background color of plot. One of \code{'brown',
#' 'gray', 'green', 'blue'}, the names of values in
#' \code{ggthemes_data$wsj$bg}.
#' @param title_family Plot title font family.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am) +
#'      ggtitle('Diamond Prices')
#' p + scale_colour_wsj('colors6', '') + theme_wsj()
#' # Use a gray background instead#'
#' p + scale_colour_wsj('colors6', '') + theme_wsj(color = "gray")
#' @export
theme_wsj <- function(base_size = 12,
                      color = "brown",
                      base_family = "sans",
                      title_family = "mono") {
  colorhex <- ggthemes_data$wsj$bg[color]
  (theme_foundation(base_size = base_size, base_family = base_family) +
    theme(line = element_line(linetype = 1, colour = "black"),
          rect = element_rect(fill = colorhex, linetype = 0, colour = NA),
          text = element_text(colour = "black"),
          title = element_text(family = title_family,
                               size = rel(2)),
          axis.title = element_blank(),
          axis.text = element_text(face = "bold", size = rel(1)),
          axis.text.x = element_text(colour = NULL),
          axis.text.y = element_text(colour = NULL),
          axis.ticks = element_line(colour = NULL),
          axis.ticks.y = element_blank(),
          axis.ticks.x = element_line(colour = NULL),
          axis.line = element_line(),
          axis.line.y = element_blank(),
          legend.background = element_rect(),
          legend.position = "top",
          legend.direction = "horizontal",
          legend.box = "vertical",
          panel.grid = element_line(colour = NULL, linetype = 3),
          panel.grid.major = element_line(colour = "black"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0, face = "bold"),
          plot.margin = unit(c(1, 1, 1, 1), "lines"),
          strip.background = element_rect()))
}

#' Wall Street Journal color palette (discrete)
#'
#' The Wall Street Journal uses many different color palettes in its
#' plots. This collects a few of them, but is by no means exhaustive.
#' Collections of these plots can be found on the WSJ Graphics
#' \href{https://twitter.com/WSJGraphics}{Twitter} feed and
#' \href{https://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}.
#'
#' @section Palettes:
#'
#' The following palettes are defined,
#'
#' \describe{
#' \item{rgby}{Red/Green/Blue/Yellow theme.
#' Examples: \url{https://twitpic.com/b2e3v2}.}
#' \item{green_red}{Green/red two-color scale for good/bad. Examples:
#' \url{https://twitpic.com/b1avj6}, \url{http://twitpic.com/a4kxcl}.}
#' \item{green_black}{Black-green 4-color scale for 'Very negative',
#' 'Somewhat negative', 'somewhat positive', 'very positive'.
#' Examples: \url{https://twitpic.com/awbua0}.}
#' \item{dem_rep}{Democrat/Republican/Undecided blue/red/gray scale.
#' Examples: \url{https://twitpic.com/awbua0}.}
#' \item{colors6}{Red, blue, gold, green, orange, and black palette.
#' Examples: \url{https://twitpic.com/9gfg5q}.}
#' }
#'
#' @param palette \code{character} The color palette to use. This
#' must be a name in
#' \code{\link[=ggthemes_data]{ggthemes_data$wsj$palettes}}.
#'
#' @family colour wsj
#' @export
wsj_pal <- function(palette = "colors6") {
  if (palette %in% names(ggthemes_data$wsj$palettes)) {
    manual_pal(unname(ggthemes_data$wsj$palettes[[palette]]))
  } else {
    stop(sprintf("palette %s not a valid palette.", palette))
  }
}

#' Wall Street Journal color and fill scales
#'
#' Colour and fill scales which use the palettes in
#' \code{\link{wsj_pal}} and are meant for use with
#' \code{\link{theme_wsj}}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams wsj_pal
#' @family colour wsj
#' @rdname scale_wsj
#' @export
scale_colour_wsj <- function(palette = "colors6", ...) {
  discrete_scale("colour", "wsj", wsj_pal(palette), ...)
}

#' @rdname scale_wsj
#' @export
scale_color_wsj <- scale_colour_wsj

#' @rdname scale_wsj
#' @export
scale_fill_wsj <- function(palette = "colors6", ...) {
  discrete_scale("fill", "wsj", wsj_pal(palette), ...)
}
