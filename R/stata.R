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
##' Themes which replicate Stata graph schemes.
##'
##' @param scheme One of "s2color", "s2mono", "s1color", "s1rcolor", or "s1mono"
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes
##'
##' @note Stata graph schemes
##' include what ggplot seperates into themes and scales, as well as
##' defaults specific to different graph types (which ggplot does not
##' support). The theme "s2color" corresponds to Stata schemes
##' "s2color" and "s2gcolor"; "s2mono" corresponds to Stata schemes
##' "s2mono", "s2gmanual", and "sj"; "s1rcolor" to "s1rcolor";
##' "s1color" to "s1color"; "s1mono" to "s1mono" and "s1manual".
##'
##' @references \url{http://www.stata.com/help.cgi?schemes}
##'
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_stata()
##'                + scale_colour_stata("s2color"))
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_stata("s1color")
##'                + scale_colour_stata("s1color"))
##' (qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_stata("s1rcolor")
##'                + scale_colour_stata("s1rcolor"))
##' (qplot(carat, price, data=dsamp, colour=clarity)
##' + theme_stata("s2mono")
##' + scale_colour_stata("mono"))
##' (qplot(carat, price, data=dsamp, colour=clarity)
##' + theme_stata("s1mono")
##' + scale_colour_stata("mono"))
theme_stata <- function(scheme="s2color", base_size=12, base_family="") {
    ## S2color
    if (scheme %in% c("s2color", "s2mono")) {
        if (scheme == "s2color") {
            bgcolor <- stata_colors['ltbluishgray']
            color_grid <- stata_colors['ltbluishgray']
            color_grid_major <- stata_colors['ltbluishgray']
            color_grid_minor <- stata_colors['gs5']
            color_strip <- stata_colors['bluishgray']
        } else {  # scheme == s2mono
            bgcolor <- stata_colors['gs15']
            color_grid <- stata_colors['dimgray']
            color_grid_major <- stata_colors['dimgray']
            color_grid_minor <- stata_colors['gs5']
            color_strip <- stata_colors['gs13']
        }
        ret <-
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
                  panel.grid.major = element_line(colour = color_grid_major),
                  ## panel.grid.minor = element_line(colour = stata_colors['gs5'], size=0.25),
                  panel.grid.minor = element_blank(),
                  panel.grid.major.x = element_blank(),
                  panel.margin = grid::unit(0.25, "lines"),
                  strip.background = element_rect(fill = color_strip, linetype=0),
                  strip.text = element_text(size = rel(0.8)),
                  strip.text.x = element_text(vjust=0.5),
                  strip.text.y = element_text(angle = -90),
                  plot.background = element_rect(fill = bgcolor, colour=NA),
                  plot.title = element_text(size = rel(2), hjust=0.5, vjust=0.5),
                  plot.margin = grid::unit(c(1, 1, 0.5, 0.5), "lines"),
                  complete=TRUE)
    } else if (scheme %in% c("s1color", "s1rcolor", "s1mono")) {
        if (scheme == "s1color") {
            bgcolor <- "white"
            fgcolor <- "black"
            color_strip <- stata_colors['ltkhaki']
            color_grid <- stata_colors['gs14']
            color_grid <- stata_colors['gs5']
        } else if (scheme == "s1rcolor") {
            bgcolor <- "black"
            fgcolor <- "white"
            color_strip <- stata_colors['maroon']
            color_grid_major <- stata_colors['gs5']
            color_grid_minor <- stata_colors['gs8']
        } else { # scheme == "s1mono"
            bgcolor <- "white"
            fgcolor <- "black"
            color_strip <- stata_colors['gs13']
            color_grid <- stata_colors['gs14']
            color_grid <- stata_colors['gs5']
        }
        ret <-
            theme(# Basic
              line = element_line(colour = fgcolor, size = 0.5,
              linetype = 1, lineend = "butt"),
                  rect = element_rect(fill = bgcolor, colour = fgcolor, size = 0.5, linetype = 1),
                  text = element_text(family = base_family, face = "plain",
                  colour = fgcolor,
                  size = base_size, hjust = 0.5, vjust = 1, angle = 0,
                  lineheight = 0.9),
                  ## Axis
                  axis.text = element_text(),
                  axis.line = element_line(),
                  axis.text.x = element_text(vjust=0),
                  axis.text.y = element_text(angle=90, vjust=0),
                  axis.ticks = element_line(),
                  axis.title = element_text(colour=fgcolor, size=rel(1.2)),
                  axis.title.x = element_text(),
                  axis.title.y = element_text(angle = 90, vjust=0.1),
                  axis.ticks.length = grid::unit(0.30, "cm"),
                  axis.ticks.margin = grid::unit(0.05, "cm"),
                  legend.background = element_rect(linetype=1),
                  legend.margin = grid::unit(0.2, "cm"),
                  legend.key = element_rect(fill=bgcolor, linetype=0),
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
                  panel.background = element_rect(fill=bgcolor, colour=bgcolor, linetype=1),
                  panel.border = element_rect(fill=NA, linetype=1, colour=fgcolor),
                  ## Sometimes stata uses lines, but not always
                  panel.grid.major = element_line(colour=stata_colors['gs14']),
                  panel.grid.major.x = element_blank(),
                  panel.grid.minor = element_blank(),
                  ## panel.grid.minor = element_line(colour=stata_colors['gs5']),
                  panel.margin = grid::unit(0.25, "lines"),
                  strip.background = element_rect(linetype=1, fill=color_strip),
                  strip.text = element_text(size = rel(0.8)),
                  strip.text.x = element_text(vjust=0.5),
                  strip.text.y = element_text(angle = -90),
                  plot.background = element_rect(colour=NA),
                  plot.title = element_text(size = rel(2), hjust=0.5, vjust=0.5),
                  plot.margin = grid::unit(c(1, 1, 0.5, 0.5), "lines"),
                  complete=TRUE)
    }
}

##' Mapping from Stata Symbol Names to R shape numbers
##'
##' Character vector of the hex RGB values of the named colors in
##' Stata. Useful for translating Stata schemes to ggplot themes. This
##' mapping does not distinguish between small and large symbols. E.g.
##' both "circle" and "smcircle" correspond to the R symbol 16.
##'
##' @export
##' @format Named \code{character} vector with the names corresponding
##' to a Stata symbol name, and the values corresponding to an R
##' shape.
##' @references \url{http://www.stata.com/help.cgi?symbolstyle}
stata_symbols <- {
    x <- c()
    for (i in c("O", "o", "circle", "smcircle")) {
        x[i] <- 16
    }
    for (i in c("D", "d", "diamond", "smdiamond")) {
        x[i] <- 18
    }
    for (i in c("T", "t", "triangle", "smtriangle")) {
        x[i] <- 17
    }
    for (i in c("S", "s", "square", "smsquare")) {
        x[i] <- 15
    }
    for (i in c("+", "plus", "smplus")) {
        x[i] <- 3
    }
    for (i in c("X", "x", "smx")) {
        x[i] <- 4
    }
    for (i in c("Oh", "oh", "circle_hollow", "smcircle_hollow")) {
        x[i] <- 1
    }
    for (i in c("Dh", "dh", "diamond_hollow", "smdiamond_hollow")) {
        x[i] <- 5
    }
    for (i in c("Th", "th", "triangle_hollow", "smtriangle_hollow")) {
        x[i] <- 2
    }
    for (i in c("Sh", "sh", "square_hollow", "smsquare_hollow")) {
        x[i] <- 15
    }
    ## Point
    for (i in c(".", "p")) {
        x[i] <- -0x2218
    }
    ## Invisible
    x['i'] <- NA
    x
}

##' Stata shape palette (discrete)
##'
##' Shape palette based on the symbol palette in Stata,
##' specifically the scheme s2mono.
##'
##' @export
##' @seealso See \code{\link{scale_shape_stata}} for examples.
stata_shape_pal <- function() {
    ## From s1mono, ignore small shapes
    manual_pal(unname(stata_symbols[c('circle', 'diamond', 'square',
                                      'triangle', 'x', 'plus',
                                      'circle_hollow', 'diamond_hollow',
                                      'square_hollow', 'triangle_hollow')]))
}

##' Stata shape scale
##'
##' Shape scale palette based on the symbol palette in Stata,
##' specifically the one in scheme s1mono.
##'
##' @inheritParams ggplot2::scale_x_discrete
##' @export
##' @examples
##' dsmall <- diamonds[sample(nrow(diamonds), 100), ]
##' (d <- qplot(carat, price, data=dsmall, shape=cut))
scale_shape_stata <- function (...) {
    discrete_scale("shape", "stata", stata_shape_pal(), ...)
}


## From s1mono and s2mono
## help linepatternstyle
## linepattern p1line  solid
## linepattern p2line  dash
## linepattern p3line  vshortdash
## linepattern p4line  longdash_dot
## linepattern p5line  longdash
## linepattern p6line  dash_dot
## linepattern p7line  dot
## linepattern p8line  shortdash_dot
## linepattern p9line  tight_dot
## linepattern p10line dash_dot_dot
## linepattern p11line longdash_shortdash
## linepattern p12line dash_3dot
## linepattern p13line longdash_dot_dot
## linepattern p14line shortdash_dot_dot
## linepattern p15line longdash_3dot
##
## Conversion between Stata decimals and R hex
## Range of stata dash lengths is 4 to 0.1
## x <- ceiling(seq(.1, 1, by=0.1) / (4/15))
## names(x) <- seq(.1, 1, by=0.1)
## 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9   1
##   1   1   2   2   2   3   3   3   4   4
## 2 = 8
## 4 = F

##' Stata linetype palette (discrete)
##'
##' Linetype palette based on the linepattern scheme in Stata.
##'
##' @export
##' @seealso \code{\link{scale_linetype_stata}}
stata_linetype_pal <- function() {
    types <-
        c(
            ## solid
            "solid",
            ## dash = "2 1"
            "84",
            ## vshortdash = ".5 .7",
            "23",
            ## longdash_dot = "4 1 .1 1",
            "F414",
            ## longdash = "4 1",
            "F4",
            ## dash_dot = "2 .9 .1 .9",
            "8414",
            ## dot = ".1 .7",
            "13",
            ## shortdash_dot = ".8 .8 .1 .8"
            "3313",
            ## tight_dot = ".1 .4"
            "12",
            ## dash_dot_dot = "2 .9 .1 .9 .1 .9"
            "841414",
            ## longdash_shortdash = "4 1 .8 1 .8 1 .8"
            "F434343",
            ## dash_3dot "2 .9 .1 .9 .1 .9 .1 .9"
            "84141414",
            ## longdash_dot_dot "4 1 .1 1 .1 1"
            "F41414",
            ## shortdash_dot_dot ".8 .8 .1 .8 .1 .8"
            "331313",
            ## longdash_3dot "4 1 .1 1 .1 1 .1 1",
            "F4141414"
            )
    function(n) {
        types[seq_len(n)]
    }
}

##' Stata linetype palette (discrete)
##'
##' Linetype scale based on the linepatterns used in Stata.
##'
##' @inheritParams ggplot2::scale_x_discrete
##' @export
##' @examples
##' library(reshape2) # for melt
##' library(plyr) # for ddply
##' ecm <- melt(economics, id = "date")
##' rescale01 <- function(x) (x - min(x)) / diff(range(x))
##' ecm <- ddply(ecm, "variable", transform, value = rescale01(value))
##' qplot(date, value, data=ecm, geom="line", linetype=variable) + scale_linetype_stata()
scale_linetype_stata <- function (...)  {
    discrete_scale("linetype", "stata", stata_linetype_pal(), ...)
}

