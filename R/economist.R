##' Economist colors
##'
##' @format \code{character} vector of the hex RGB values of the
##' colors used by The Economist.
##' @seealso economist_pal
##' @export
economist_colors <-
    c(## Background
      ebg = rgb(198,211,223, max=255),
      edkbg = rgb(178,191,203, max=255),
      ## Symbols
      edkblue = rgb(62,100,125, max=255),
      emidblue = rgb(123,146,168, max=255),
      eltblue = rgb(130,192,233, max=255),
      gs6 = rgb(96, 96, 96, max=255),
      emerald = rgb(45,109,102, max=255),
      erose = rgb(191,161,156, max=255),
      ebblue = rgb(0,139,188, max=255),
      eltgreen = rgb(151,182,176, max=255),
      stone = rgb(215,210,158, max=255),
      navy = rgb(26,71,111, max=255),
      maroon = rgb(144,53,59, max=255),
      brown = rgb(156,136,71, max=255),
      lavender = rgb(147,141,210, max=255),
      teal = rgb(110,142,132, max=255),
      cranberry=rgb(193, 5, 52, max=255),
      khaki = rgb(202,194, 126, max=255))

##' Economist color palette (discrete)
##'
##' @param n \code{integer}. Number of values.
##' @export
##' @examples
##' show_col(economist_pal(16))
economist_pal <- manual_pal(unname(economist_colors[3:length(economist_colors)]))

##' Economist color scales
##'
##' Color scales using the colors in the Economist graphics. These scales use
##' RGB values and ordering of the colors in the State economist scheme.
##'
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour scales
##' @rdname scale_economist
##' @export
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_economist()
##'                + scale_colour_economist() )
scale_colour_economist <- function(...) discrete_scale("colour", "economist",
                                                       economist_pal, ...)
#' @export
#' @rdname scale_economist
scale_color_economist <- scale_colour_economist

#' @export
#' @rdname scale_economist
scale_fill_economist <- function(...) discrete_scale("colour", "economist",
                                                     economist_pal, ...)

##' ggplot color theme based on the Economist
##'
##' Style plots similar to those in The Economist.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @param horizontal \code{logical}. Horizontal axis lines?
##' @param dkplot \code{logical} Darker background for plot region?
##' @export
##' @family themes
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_economist()
##'                + scale_colour_economist() )
theme_economist <- function(base_size = 12, base_family="",
                            horizontal=TRUE, dkplot=FALSE) {
    palette_economist_bg <- c(ebg = "#C6D3DF",
                              edkbg = "#B2BFCB")
    ret <-
        theme(# Basic
              line = element_line(colour = "black", size = 0.5,
              linetype = 1, lineend = "butt"),
              rect = element_rect(fill = palette_economist_bg['ebg'],
              colour = NA, size = 0.5, linetype = 1),
              text = element_text(family = base_family, face = "plain",
              colour = "black",
              size = base_size, hjust = 0.5, vjust = 0.5, angle = 0,
              lineheight = 0.9),
              ## Axis
              axis.text = element_text(size = rel(0.8)),
              axis.line = element_line(size = rel(0.8)),
              axis.line.y = element_blank(),
              axis.text.x = element_text(vjust = 1),
              axis.text.y = element_text(hjust = 0),
              ## I cannot figure out how to get ggplot to do 2 levels of ticks
              axis.ticks = element_line(),
              axis.ticks.y = element_blank(),
              axis.title.x = element_text(),
              axis.title.y = element_text(angle = 90),
              axis.ticks.length = grid::unit(-0.2 , "cm"),
              axis.ticks.margin = grid::unit(0.6, "cm"),
              legend.background = element_rect(linetype=0),
              legend.margin = grid::unit(0.2, "cm"),
              legend.key = element_rect(linetype=0),
              legend.key.size = grid::unit(1.2, "lines"),
              legend.key.height = NULL,
              legend.key.width = NULL,
              legend.text = element_text(size = rel(0.8)),
              legend.text.align = NULL,
              legend.title = element_text(size = rel(0.8), face = "bold",
              hjust = 0),
              legend.title.align = NULL,
              legend.position = "right",
              legend.direction = NULL,
              legend.justification = "center",
              ## legend.box = element_rect(fill = palette_economist['bgdk'], colour=NA, linetype=0),
              ## Economist only uses vertical lines
              panel.background = element_rect(linetype=0),
              panel.border = element_blank(),
              panel.grid.major = element_line(colour = "white", size=rel(2)),
              panel.grid.minor = element_blank(),
              panel.margin = grid::unit(0.25, "lines"),
              strip.background = element_rect(fill = palette_economist_bg['edkbg'],
              colour = NA, linetype=0),
              strip.text = element_text(size = rel(0.8)),
              strip.text.x = element_text(),
              strip.text.y = element_text(angle = -90),
              plot.background = element_rect(fill = palette_economist_bg['ebg'], colour=NA),
              plot.title = element_text(size = rel(1.2), hjust=0),
              plot.margin = grid::unit(c(1, 1, 0.5, 0.5), "lines"),
              complete = TRUE)
    if (horizontal) {
        ret <- ret + theme(panel.grid.major.x = element_blank())
    } else {
        ret <- ret + theme(panel.grid.major.y = element_blank())
    }
    if (dkplot==TRUE) {
        ret <- ret + theme(panel.background=element_rect(fill = palette_economist_bg['edkbg']))
    }
    ret
}
## TODO:
## - white background http://junkcharts.typepad.com/.shared/image.html?/photos/uncategorized/2008/04/18/econ_anglosaxon.gif
## - white and gray http://www.economist.com/blogs/graphicdetail/2012/09/daily-chart-3

## RGB values from Stata economist scheme


## From latticeExtra::theEconomist.theme
## palette_economist_1 <- c(dkblue="#00526D", ltblue="#00A3DB", dkred="#7A2713",
##                          yellow="#939598", ltblue2="#6CCFF6")

## Palette
## 3 color http://www.economist.com/blogs/graphicdetail/2012/08/daily-chart-olympics-4 (blue, red, lt red)
## 3 and 4 colors http://www.economist.com/node/21561909
## 5 colors http://www.economist.com/node/21560601, http://www.economist.com/blogs/graphicdetail/2012/08/daily-chart-6
## pal_economist_colour <-
##     manual_pal(c(dkblue="#014B62", blue="#00A0D8", ltblue="#79D3F6",
##                  red="#781D01", gray="#ACABAC"))

##
## 1 color http://www.economist.com/node/21561883
## 2 color http://www.economist.com/node/21560572
## 3 color http://www.economist.com/node/21560582
## 4 color http://www.economist.com/blogs/graphicdetail/2012/09/focus
## 6 color http://junkcharts.typepad.com/.a/6a00d8341e992c53ef01538e032bd5970b-pi
## 7 color
## http://www.economist.com/node/14941181?story_id=14941181, http://www.economist.com/blogs/graphicdetail/2012/07/focus-4
## 8 color http://www.economist.com/node/16834943?story_id=16834943
## pal_economist_fill <- function(n) {
##     colors <- c(bluegray="#6794a7", dkblue="#014D65", blue="01a29d9",
##                 gray="ADADAD", ltgreen="#7AD2F6", ltgreen2="#76C0C1",
##                 green="#00887E")
##     if (n == 1) {
##         colors['dkblue']
##     } else if (n == 2) {
##         colors[c("blue", "dkblue")]
##     } else {
##         colors[1:n]
##     }
## }

## RGB values from Stata economist scheme
## pal_economist_fill <-
##     manual_pal(c(blue="#014D63", bluegray="#6895A7", gray="#ACADAF",
##                  ltblue="#009FD7", ltgreen="#74BBBE", red="#762918",
##                  green="#02847B", ltblue2="#75CFF3"))

