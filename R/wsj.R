#' Wall Street Journal theme
#'
#' Theme based on the plots in \emph{The Wall Street Journal}.
#'
#' This theme should be used with \code{\link{scale_color_wsj}()}.
#'
#' @references
#'
#' \url{https://twitter.com/WSJGraphics}
#'
#' \url{https://pinterest.com/wsjgraphics/wsj-graphics/}
#'
#' @inheritParams ggplot2::theme_grey
#' @param color The background color of plot. One of \code{'brown',
#' 'gray', 'green', 'blue'}.
#' @param title_family Plot title font family.
#' @family themes wsj
#' @example inst/examples/ex-theme_wsj.R
#' @export
#' @importFrom ggplot2 element_line element_rect element_text element_blank rel
theme_wsj <- function(base_size = 12,
                      color = "brown",
                      base_family = "sans",
                      title_family = "mono") {
  colorhex <- ggthemes::ggthemes_data$wsj$bg[color]
  theme_foundation(base_size = base_size, base_family = base_family) +
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
          strip.background = element_rect())
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
#' \item{rgby}{Red/Green/Blue/Yellow theme.}
#'   \item{red_green}{Green/red two-color scale for good/bad.}
#' \item{green_black}{Black-green 4-color scale for 'Very negative',
#'   'Somewhat negative', 'somewhat positive', 'very positive'.}
#' \item{dem_rep}{Democrat/Republican/Undecided blue/red/gray scale.}
#' \item{colors6}{Red, blue, gold, green, orange, and black palette.}
#' }
#'
#' @param palette \code{character} The color palette to use: .
#' \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$wsj$palettes))}
#'
#' @family colour wsj
#' @export
wsj_pal <- function(palette = "colors6") {
  palettes <- ggthemes::ggthemes_data[["wsj"]][["palettes"]]
  if (palette %in% names(palettes)) {
    colors <- palettes[[palette]][["value"]]
    max_n <- length(colors)
    f <- manual_pal(unname(colors))
    attr(f, "max_n") <- max_n
    f
  } else {
    stop(sprintf("palette %s not a valid palette.", palette))
  }
}

#' Wall Street Journal color and fill scales
#'
#' Colour and fill scales which use the palettes in \code{\link{wsj_pal}()}.
#' These scales should be used with \code{\link{theme_wsj}()}.
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
