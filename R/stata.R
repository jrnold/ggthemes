##' Stata colors
##'
##' Character vector of the hex RGB values of the named colors in Stata.
##' Useful for translating Stata schemes to ggplot themes.
##'
##' @format named \code{character} vector of the hex RGB values of the
##' colors used in Stata.
##'
##' @references \url{http://www.stata.com/help.cgi?colorstyle}
##' @export
stata_colors <-
    c(eltgreen = "#97b6b0", forest_green = "#55752f", sandb = "#ffe474", gold = "#ffd200", midgreen = "#00b000", lavender = "#938dd2", maroon = "#90353b", dknavy = "#1e2d53", sienna = "#a0522d", gs15 = "#f0f0f0", pink = "#ff0080", ebg = "#c6d3df", edkblue = "#3e647d", edkbg = "#b2bfcb", navy = "#1a476f", gs14 = "#e0e0e0", magenta = "#ff00ff", gs16 = "#ffffff", ltbluishgray = "#eaf2f3", gs10 = "#a0a0a0", gs13 = "#d0d0d0", lime = "#00ff00", blue = "#0000ff", gs0 = "#000000", gs3 = "#303030", gs2 = "#202020", gs5 = "#505050", gs4 = "#404040", gs7 = "#707070", gs6 = "#606060", dimgray = "#e8e8e8", gs8 = "#808080", bluishgray = "#d9e6eb", eggshell = "#fffbf0", gs1 = "#101010", sunflowerlime = "#eaffaa", ltblue = "#add8e6", black = "#000000", orange_red = "#ff4500", midblue = "#0080ff", white = "#ffffff", gs12 = "#c0c0c0", red = "#ff0000", olive_teal = "#c0dcc0", khaki = "#cac27e", eltblue = "#82c0e9", gs11 = "#b0b0b0", ebblue = "#008bbc", stone = "#d7d29e", ltbluishgray8 = "#e1e6f0", chocolate = "#804000", orange = "#ff7f00", bluishgray8 = "#d2d7e4", yellow = "#ffff00", emerald = "#2d6d66", olive = "#5c4717", cyan = "#00ffff", erose = "#bfa19c", gray = "#808080", none = "#000000", gs9 = "#909090", brown = "#9c8847", ltkhaki = "#e5daa5", navy8 = "#273f6f", mint = "#00ff80", purple = "#800080", emidblue = "#7b92a8", dkorange = "#e37e00", sand = "#d9c263", dkgreen = "#006000", green = "#008000", teal = "#6e8e84", cranberry = "#c10534")


##' Stata color palettes (discrete)
##'
##' Stata color palettes.  See Stata documentation for schemes: \url{http://www.stata.com/help.cgi?schemes}
##'
##' @param scheme \code{character}. One of "s2color", "s1rcolor", "s1color", or "mono".
##' @export
##' @examples
##' show_col(stata_pal("s2color")(15))
##' show_col(stata_pal("s1rcolor")(15))
##' show_col(stata_pal("s1color")(15))
##' show_col(stata_pal("mono")(15))
stata_pal <- function(scheme="s2color") {
    colorlists <-
        list(s2color = c("navy", "maroon", "forest_green",
             "dkorange", "teal", "cranberry", "lavender", "khaki", "sienna",
             "emidblue", "emerald", "brown", "erose", "gold", "bluishgray" # gs6
             ),
             s1rcolor = c("yellow", "lime", "midblue", "magenta", "orange",
             "red", "ltblue", "sandb", "mint", "olive_teal", "orange_red", "blue",
             "pink", "teal", "sienna"), # white
             s1color = c("dkgreen", "orange_red", "navy", "maroon", "teal", "sienna",
             "orange", "magenta", "cyan", "red", "lime", "brown", "purple",
             "olive_teal", "ltblue"), #gs6
             ## s2manual, s2gmanual, s1mono, s1manual, s
             mono = c("gs6", "gs10", "gs8", "gs4", "black", "gs14", "gs2", "gs7",
             "gs9", "gs11", "gs13", "gs15", "gs3", "gs12", "gs5") #black
             )
    manual_pal(unname(stata_colors[colorlists[[scheme]]]))
}

##' Stata color scales
##'
##' Color scales using the color palettes from Stata.
##'
##' @inheritParams stata_pal
##' @inheritParams ggplot2::scale_colour_hue
##' @family colour scales
##' @rdname scale_stata
##' @export
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_bw()
##'                + scale_color_stata())
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_bw()
##'                + scale_color_stata("s1color"))
scale_colour_stata <- function(scheme="s2color", ...) discrete_scale("colour", "stata", stata_pal(scheme), ...)

#' @export
#' @rdname scale_stata
scale_fill_stata <- function(scheme="s2color", ...) discrete_scale("fill", "stata", stata_pal(scheme), ...)

#' @export
#' @rdname scale_stata
scale_color_stata <- scale_colour_stata

##' ggplot theme based on Stata graph schemes
##'
##' Theme which replicate Stata graph schemes.
##'
##' @param scheme "s2color" or "s1color"
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_stata()
##'                + scale_colour_stata("s2color"))
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_stata("s1color")
##'                + scale_colour_stata("s1color"))
theme_stata <- function(scheme="s2color", base_size=12, base_family="") {
    if (scheme == "s2color") {
        theme(# Basic
              line = element_line(colour = "black", size = 0.5,
              linetype = 1, lineend = "butt"),
              rect = element_rect(fill = "white", colour = "black", size = 0.5, linetype = 1),
              text = element_text(family = base_family, face = "plain",
              colour = "black",
              size = base_size, hjust = 0.5, vjust = 1, angle = 0,
              lineheight = 0.9),
              title = element_text(colour = stata_colors['dknavy']),
              ## Axis
              axis.text = element_text(),
              axis.line = element_line(),
              axis.text.x = element_text(vjust=0),
              axis.text.y = element_text(angle=90, vjust=0),
              ## I cannot figure out how to get ggplot to do 2 levels of ticks
              axis.ticks = element_line(),
              axis.title = element_text(colour="black", size=rel(1.2)),
              axis.title.x = element_text(),
              axis.title.y = element_text(angle = 90, vjust=0.1),
              axis.ticks.length = grid::unit(0.30, "cm"),
              axis.ticks.margin = grid::unit(0.05, "cm"),
              legend.background = element_rect(linetype=1),
              legend.margin = grid::unit(0.2, "cm"),
              legend.key = element_rect(fill="white", linetype=0),
              legend.key.size = grid::unit(1.2, "lines"),
              legend.key.height = NULL,
              legend.key.width = NULL,
              legend.text = element_text(size = rel(0.8)),
              legend.text.align = NULL,
              legend.title = element_text(size = rel(0.8), face = "bold",
              hjust = 0),
              legend.title.align = 0.5,
              legend.position = "bottom",
              legend.direction = NULL,
              legend.justification = "center",
              legend.box = "vertical",
              ## plotregion
              panel.background = element_rect(fill="white", colour="white", linetype=1),
              panel.border = element_blank(),
              panel.grid.major = element_line(colour = stata_colors['ltbluishgray']),
              # panel.grid.minor = element_line(colour = stata_colors['gs5'], size=0.25),
              panel.grid.minor = element_blank(),
              panel.grid.major.x = element_blank(),
              panel.margin = grid::unit(0.25, "lines"),
              strip.background = element_rect(fill = stata_colors['bluishgray'], linetype=0),
              strip.text = element_text(size = rel(0.8)),
              strip.text.x = element_text(vjust=0.5),
              strip.text.y = element_text(angle = -90),
              plot.background = element_rect(fill = stata_colors['ltbluishgray'], colour=NA),
              plot.title = element_text(size = rel(2), hjust=0.5, vjust=0.5),
              plot.margin = grid::unit(c(1, 1, 0.5, 0.5), "lines"),
              complete=TRUE)
    } else if (scheme == "s1color") {
        theme(# Basic
              line = element_line(colour = "black", size = 0.5,
              linetype = 1, lineend = "butt"),
              rect = element_rect(fill = "white", colour = "black", size = 0.5, linetype = 1),
              text = element_text(family = base_family, face = "plain",
              colour = "black",
              size = base_size, hjust = 0.5, vjust = 1, angle = 0,
              lineheight = 0.9),
              ## Axis
              axis.text = element_text(),
              axis.line = element_line(),
              axis.text.x = element_text(vjust=0),
              axis.text.y = element_text(angle=90, vjust=0),
              ## I cannot figure out how to get ggplot to do 2 levels of ticks
              axis.ticks = element_line(),
              axis.title = element_text(colour="black", size=rel(1.2)),
              axis.title.x = element_text(),
              axis.title.y = element_text(angle = 90, vjust=0.1),
              axis.ticks.length = grid::unit(0.30, "cm"),
              axis.ticks.margin = grid::unit(0.05, "cm"),
              legend.background = element_rect(linetype=1),
              legend.margin = grid::unit(0.2, "cm"),
              legend.key = element_rect(fill="white", linetype=0),
              legend.key.size = grid::unit(1.2, "lines"),
              legend.key.height = NULL,
              legend.key.width = NULL,
              legend.text = element_text(size = rel(0.8)),
              legend.text.align = NULL,
              legend.title = element_text(size = rel(0.8), face = "bold", hjust = 0),
              legend.title.align = 0.5,
              legend.position = "bottom",
              legend.direction = NULL,
              legend.justification = "center",
              legend.box = "vertical",
              ## plotregion
              panel.background = element_rect(fill="white", colour="white", linetype=1),
              # panel.border = element_rect(),
              panel.grid = element_blank(),
              # Sometimes stata uses lines
              #panel.grid.major = element_line(colour=stata_colors['gs14']),
              #panel.grid.major.x = element_blank(),
              #panel.grid.minor = element_blank(),
              # panel.grid.minor = element_line(colour=stata_colors['gs5']),
              panel.margin = grid::unit(0.25, "lines"),
              strip.background = element_rect(linetype=1, fill=stata_colors['ltkhaki']),
              strip.text = element_text(size = rel(0.8)),
              strip.text.x = element_text(vjust=0.5),
              strip.text.y = element_text(angle = -90),
              plot.background = element_rect(colour=NA),
              plot.title = element_text(size = rel(2), hjust=0.5, vjust=0.5),
              plot.margin = grid::unit(c(1, 1, 0.5, 0.5), "lines"),
              complete=TRUE)
    }
}

