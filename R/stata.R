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
    manual_pal(unname(ggplotJrnoldPalettes$stata$colors[colorlists[[scheme]]]))
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
scale_colour_stata <- function(scheme="s2color", ...) {
    discrete_scale("colour", "stata", stata_pal(scheme), ...)
}

#' @export
#' @rdname scale_stata
scale_fill_stata <- function(scheme="s2color", ...) {
    discrete_scale("fill", "stata", stata_pal(scheme), ...)
}

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
theme_stata <- function(scheme="s2color", base_size=11, base_family="") {

    ## Sizes
    relsz <- sapply(as.numeric(stata_gsize), `/`, y=as.numeric(stata_gsize$medium))
    names(relsz) <- names(stata_gsize)

    stata_colors <- ggplotJrnoldPalettes$stata$colors
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
                  colour = "black", size = base_size, hjust = 0.5, vjust = 1, angle = 0,
                  lineheight = 1),
                  title = element_text(colour = stata_colors['dknavy']),
                  ## Axis
                  axis.text = element_text(),
                  axis.line = element_line(),
                  axis.text.x = element_text(vjust=0),
                  axis.text.y = element_text(angle=90, vjust=0),
                  ## I cannot figure out how to get ggplot to do 2 levels of ticks
                  axis.ticks = element_line(),
                  axis.title = element_text(colour="black", size=rel(relsz['medsmall'])),
                  axis.title.x = element_text(),
                  axis.title.y = element_text(angle = 90, vjust=0.1),
                  axis.ticks.length = grid::unit(stata_gsize['tiny'], "npc"),
                  axis.ticks.margin = grid::unit(stata_gsize['half_tiny'], "npc"),
                  legend.background = element_rect(linetype=1),
                  legend.margin = grid::unit(stata_margins$small / 100, "npc"),
                  legend.key = element_rect(fill="white", linetype=0),
                  legend.key.size = grid::unit(1.2, "lines"),
                  legend.key.height = NULL,
                  legend.key.width = NULL,
                  legend.text = element_text(size = rel(relsz['medsmall'])),
                  legend.text.align = NULL,
                  # See textboxstyle leg_title
                  legend.title = element_text(size = rel(relsz['large']), hjust = 0),
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
                  plot.title = element_text(size = rel(relsz['large']), hjust=0.5, vjust=0.5),
                  plot.margin = grid::unit(stata_margins$medsmall / 100, "npc"),
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

##' Stata shape palette (discrete)
##'
##' Shape palette based on the symbol palette in Stata,
##' specifically the scheme s2mono.
##'
##' @export
##' @seealso See \code{\link{scale_shape_stata}} for examples.
stata_shape_pal <- function() {
    ## From s1mono, ignore small shapes
    shapenames <- c('circle', 'diamond', 'square',
                    'triangle', 'x', 'plus',
                    'circle_hollow', 'diamond_hollow',
                    'square_hollow', 'triangle_hollow')
    values <- ggplotJrnoldPalettes$stata$shapes[shapenames]
    manual_pal(unname(shapenames))
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

##' Stata linetype palette (discrete)
##'
##' Linetype palette based on the linepattern scheme in Stata.
##'
##' @export
##' @seealso \code{\link{scale_linetype_stata}}
stata_linetype_pal <- function() {
    values <- ggplotJrnoldPalettes$stata$linetypes
    function(n) {
        values[seq_len(n)]
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


## Text sizes (from style definitions ado/base/style/gsize-*.style)
## default 4.166
## full 100
## half 50
## half_tiny 0.6944 (2 pt in 4 in high graph)
## huge 6.9444 (20 pt)
## large 4.8611 (14 pt)
## medium 3.8194 (11 pt)
## medlarge 4.1667 (12 pt)
## medsmall 3.4722 (10 pt)
## miniscule 0.3472 (1 pt in 1 in high graph)
## quarter 25
## quarter_tiny 0.34722 (1 pt in 4 in high graph)
## small 2.777 (8 pt)
## tenth 10
## third 33.33333333333
## third_tiny 0.46296 (1.33 pt)
## tiny 1.3888 (4 pt)
## vhuge 9.7222 (28 pt)
## vlarge 5.5556 (16 pt)
## vsmall 2.0833 (6 pt)
## zero 0
## which means
##
## text medium
## body medsmall
## heading large
## axis title medsmall
## label medsmall
## tick tiny =
## tick_label medsmall
## tick_biglabel medium
## key_label medsmall
stata_gsize <-
    lapply(c(default = 4.1667,
             full = 100,
             half = 50,
             half_tiny = 0.6944,
             huge = 6.944,
             large = 4.8611,
             medium = 3.8194,
             medlarge = 4.1667,
             medsmall = 3.4722,
             miniscule = 0.3472,
             quarter = 25,
             quarter_tiny = 0.34722,
             small = 2.777,
             tenth = 10,
             third = 33.33333333333,
             third_tiny = 0.46296,
             tiny = 1.3888,
             vhuge = 9.7222,
             vlarge = 5.5556,
             vsmall = 2.0833,
             zero = 0) / 100,
           unit,
           units = "npc")

## Line width styles ado/base/style/linewidth-*.style
## see stata help linewidth
## unsure of the scale. likely npc * 100
stata_linewidth <-
    c(medium  = 0.3,
      medthick = 0.45,
      medthin = 0.25,
      none = 0,
      thick = 0.8,
      thin = 0.2,
      vthick = 1.4,
      thin = 0.15,
      vvthick = 2.6,
      vvthin = 0.01,
      vvvthick = 4.2,
      vvvthin = .000001)

## Stata margin styles
## Units are npc * 100
## Left, right, top, bottom
## ggplot margins go top, right, bottom, left.
## From ado/base/style/margin-*.style
stata_margins <-
    list(bargraph = c(3.5, 3.5, 3.5, 0),
         bottom = c(0, 0, 0, 3),
         ebargraph = c(1.5, 1.5, 1.5, 0),
         esubhead = c(2.2, 2.2, 0, 4),
         horiz_bargraph = c(0, 3.5, 3.5, 3.5),
         large = c(8, 8, 8, 8),
         left = c(3, 0, 0, 0),
         medium = c(3.5, 3.5, 3.5, 3.5),
         medlarge = c(5, 5, 5, 5),
         medsmall = c(2.2, 2.2, 2.2, 2.2),
         right = c(0, 3, 0, 0),
         sides = c(3.5, 3.5, 0, 0),
         small = rep(1.2, 4),
         tiny = rep(0.3, 4),
         top_bottom = c(0, 0, 3.5, 3.5),
         top = c(0, 0, 3, 0),
         vlarge = rep(12, 4),
         vsmall = rep(0.6, 4),
         zero = rep(0, 4))



