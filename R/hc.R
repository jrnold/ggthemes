##' Wall Street Journal theme
##'
##' Theme based on the plots in \emph{Highcharts }.
##'
##' @references
##'
##' \url{http://www.highcharts.com/demo/line-basic}
##'
##' \url{https://github.com/highslide-software/highcharts.com/tree/master/js/themes}
##'
##' @param base_size Base font size.
##' @param color The background color of plot. One of \code{"brown",
##' "gray", "green", "blue"}, the names of values in
##' \code{ggthemes_data$wsj$bg}.
##' @param title_family Plot title font family.
##' @param base_family Plot text font family.
##' @family themes wsj
##' @examples
##' (qplot(hp, mpg, data=mtcars, geom="point")
##' + scale_colour_wsj("colors6", "")
##' + ggtitle("Diamond Prices")
##' + theme_wsj())
##' ## Use a gray background instead
##' (qplot(hp, mpg, data=mtcars, geom="point")
##'  + scale_colour_wsj("colors6", "")
##'  + ggtitle("Diamond Prices")
##'  + theme_wsj(color="gray"))
##' @export


theme_hc <- function(theme="default", base_size=12) {
  
  bgcol <- ggthemes_data$hc$bg[theme]
  
  themes <- list()
  
  t <-  theme(
    rect                = element_rect(fill=bgcol, linetype=0, colour=NA),
    text                = element_text(size=base_size),
    title               = element_text(hjust=.5), 
    axis.title.x        = element_text(hjust=.5),
    axis.title.y        = element_text(hjust=.5),
    panel.grid.major.y  = element_line(color='gray'),
    panel.grid.minor.y  = element_blank(),
    panel.grid.major.x  = element_blank(),
    panel.grid.minor.x  = element_blank(),
    panel.border        = element_blank(),
    panel.background    = element_blank(),
    legend.position     = "bottom",
    legend.key   = element_rect(fill="#FFFFFF00"))
  
  themes$default <- t
  
  themes$darkunica <- t + theme(
    rect                = element_rect(fill=bgcol),
    text                = element_text(colour = "#A0A0A3"),
    title               = element_text(colour = "#FFFFFF"), 
    axis.title.x        = element_text(colour = "#A0A0A3"),
    axis.title.y        = element_text(colour = "#A0A0A3"),
    panel.grid.major.y  = element_line(color='gray'),
    legend.title        = element_text(colour = "#A0A0A3"))
  
  themes[theme]
}


##' Wall Street Journal color palette (discrete)
##'
##' The Wall Street Journal uses many different color palettes in its
##' plots. This collects a few of them, but is by no means exhaustive.
##' Collections of these plots can be found on the WSJ Graphics
##' \href{https://twitter.com/WSJGraphics}{Twitter} feed and
##' \href{http://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}.
##'
##' @section Palettes:
##'
##' The following palettes are defined,
##'
##' \describe{
##' \item{rgby}{Red/Green/Blue/Yellow theme. Examples: \url{http://twitpic.com/b2e3v2}.}
##' \item{green_red}{Green/red two-color scale for good/bad. Examples: \url{http://twitpic.com/b1avj6}, \url{http://twitpic.com/a4kxcl}.}
##' \item{green_black}{Black-green 4-color scale for "Very negative", "Somewhat negative", "somewhat positive", "very positive". Examples: \url{http://twitpic.com/awbua0}.}
##' \item{dem_rep}{Democrat/Republican/Undecided blue/red/gray scale. Examples: \url{http://twitpic.com/awbua0}.}
##' \item{colors6}{Red,blue,gold,green,orange, and black palette. Examples: \url{http://twitpic.com/9gfg5q}.}
##' }
##'
##' @param palette \code{character} The color palette to use. This
##' must be a name in
##' \code{\link[=ggthemes_data]{ggthemes_data$hc$palettes}}.
##'
##' @family colour wsj
##' @export
hc_pal <- function(palette = "default") {
    if (palette %in% names(ggthemes_data$hc$palettes)) {
        manual_pal(unname(ggthemes_data$hc$palettes[[palette]]))
    } else {
        stop(sprintf("palette %s not a valid palette.", palette))
    }
}

##' Highcharts color and fill scales
##'
##' Colour and fill scales which use the palettes in
##' \code{\link{wsj_hc}} and are meant for use with
##' \code{\link{theme_hc}}.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @inheritParams hc_pal
##' @family colour hc
##' @rdname scale_hc
##' @export
scale_colour_hc <- function(palette = "default", ...) {
    discrete_scale("colour", "hc", hc_pal(palette), ...)
}

##' @rdname scale_hc
##' @export
scale_color_hc <- scale_colour_hc

##' @rdname scale_hc
##' @export
scale_fill_hc <- function(palette = "default", ...) {
    discrete_scale("fill", "hc", hc_pal(palette), ...)
}