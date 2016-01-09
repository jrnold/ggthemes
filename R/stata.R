#' Stata color palettes (discrete)
#'
#' Stata color palettes. See Stata documentation for a description of
#' the schemes, \url{http://www.stata.com/help.cgi?schemes}.
#'
#' @param scheme \code{character}. One of \code{"s2color"},
#' \code{"s1rcolor"}, \code{"s1color"}, or \code{"mono"}.
#'
#' @export
#' @family stata colour
#' @examples
#' library("scales")
#' show_col(stata_pal("s2color")(15))
#' show_col(stata_pal("s1rcolor")(15))
#' show_col(stata_pal("s1color")(15))
#' show_col(stata_pal("mono")(15))
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
  manual_pal(unname(ggthemes_data$stata$colors[colorlists[[scheme]]]))
}

#' Stata color scales
#'
#' See \code{\link{stata_pal}} for details.
#'
#' @inheritParams stata_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour stata
#' @rdname scale_stata
#' @export
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

theme_stata_base <- function(base_size = 11, base_family = "sans") {
  ## Sizes
  relsz <- sapply(as.numeric(stata_gsize), `/`,
                  y = as.numeric(stata_gsize$medium))
  names(relsz) <- names(stata_gsize)
  theme(line = element_line(size = 0.5, linetype = 1, lineend = "butt",
                            colour="black"),
        rect = element_rect(size = 0.5, linetype = 1, fill = "white",
                            colour="black"),
        text = element_text(family = base_family,
                            face = "plain",
                            colour = "black",
                            size = base_size, hjust = 0.5,
                            vjust = 1, angle = 0,
                            lineheight = 1, margin = margin(), debug = FALSE),
        title = element_text(),
        ## Axis
        axis.line = element_line(),
        axis.text = element_text(size = rel(relsz["medsmall"])),
        axis.text.x = element_text(vjust = 1),
        axis.text.y = element_text(angle = 90, vjust = 0.5),
        ## I cannot figure out how to get ggplot to do 2 levels of ticks
        axis.ticks = element_line(),
        axis.title = element_text(size = rel(relsz["medsmall"])),
        axis.title.x = element_text(),
        axis.title.y = element_text(angle = 90, vjust = 0),
        # axis.ticks.length = stata_gsize$tiny,
        # axis.ticks.margin = stata_gsize$half_tiny,
        axis.ticks.length = unit(4 / 11, "lines"),
        legend.background = element_rect(linetype = 1),
        legend.margin = unit(1.2 / 100, "npc"),
        legend.key = element_rect(linetype = 0),
        legend.key.size = unit(1.2, "lines"),
        legend.key.height = NULL,
        legend.key.width = NULL,
        legend.text = element_text(size = rel(relsz["medsmall"])),
        legend.text.align = NULL,
        ## See textboxstyle leg_title
        legend.title = element_text(size = rel(relsz["large"]), hjust = 0),
        legend.title.align = 0.5,
        legend.position = "bottom",
        legend.direction = NULL,
        legend.justification = "center",
        legend.box = "vertical",
        ## plotregion
        panel.background = element_rect(),
        panel.border = element_blank(),
        panel.grid.major = element_line(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.margin = unit(0.25, "lines"),
        ## textboxstyle bytitle      bytitle
        strip.background = element_rect(linetype = 0),
        strip.text = element_text(size = rel(relsz["medlarge"])),
        strip.text.x = element_text(vjust = 0.5),
        strip.text.y = element_text(angle = -90),
        plot.background = element_rect(linetype = 0, colour = NA),
        plot.title = element_text(size = rel(relsz["large"]),
                                  hjust = 0.5,
                                  vjust = 1),
        plot.margin = unit(rep(0.035, 4), "npc"),
        complete = TRUE)
}

theme_stata_colors <- function(scheme="s2color") {
  stata_colors <- ggthemes_data$stata$colors
  if (scheme == "s2color") {
    color_plot <- stata_colors["ltbluishgray"]
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["ltbluishgray"]
    #color_grid_major <- stata_colors["ltbluishgray"]
    fill_strip <- stata_colors["bluishgray"]
    color_strip <- NA
    color_title <- stata_colors["dknavy"]
    color_border <- NA
  } else if (scheme %in% c("s2mono", "s2manual", "sj")) {
    color_plot <- stata_colors["gs15"]
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["dimgray"]
    #color_grid_major <- stata_colors["dimgray"]
    fill_strip <- stata_colors["gs13"]
    color_strip <- NA
    color_title <- "black"
    color_border <- NA
  } else if (scheme == "s1color") {
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["gs14"]
    fill_strip <- stata_colors["ltkhaki"]
    color_strip <- "black"
    color_title <- "black"
    color_border <- "black"
  } else if (scheme == "s1rcolor") {
    color_plot <- "black"
    color_bg <- "black"
    color_fg <- "white"
    color_grid <- stata_colors["gs5"]
    fill_strip <- stata_colors["maroon"]
    color_strip <- "white"
    color_title <- "white"
    color_border <- "white"
  } else if (scheme %in% c("s1mono", "s1manual")) {
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["gs14"]
    fill_strip <- stata_colors["gs13"]
    color_strip <- "black"
    color_title <- "black"
    color_border <- "black"
  } else {
    stop(sprintf("'%s' is not a valid value for scheme.", scheme))
  }

  theme(line = element_line(colour = color_fg, linetype = 1),
        rect = element_rect(fill = color_bg, colour = color_fg, linetype = 1),
        text = element_text(colour = color_fg),
        title = element_text(colour = color_title),
        axis.title = element_text(colour = color_fg),
        axis.ticks.x = element_line(colour = color_fg),
        axis.ticks.y = element_line(colour = color_fg),
        axis.text.x = element_text(colour = color_fg),
        axis.text.y = element_text(colour = color_fg),
        legend.key = element_rect(fill = color_bg, colour = NA, linetype = 0),
        legend.background = element_rect(linetype = 1),
        panel.background = element_rect(fill = color_bg,
                                        colour = color_border,
                                        linetype = 1),
        panel.grid.major = element_line(colour = color_grid),
        strip.background = element_rect(fill = fill_strip,
                                        colour = color_strip,
                                        linetype = 1),
        plot.background = element_rect(fill = color_plot))
}

#' Themes based on Stata graph schemes
#'
#' @param scheme One of "s2color", "s2mono", "s1color",
#'   "s1rcolor", or "s1mono", "s2manual",
#'   "s1manual", or "sj"
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes stata
#'
#' @note Stata graph schemes include the features of \pkg{ggplot2}
#' into themes and scales. Stata graph themes also allow for defaults
#' for specific graph types, a feature which \pkg{ggplot2} does not directly
#' support.
#'
#' @references \url{http://www.stata.com/help.cgi?schemes}
#'
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'     facet_wrap(~am)
#' # s2color
#' p + theme_stata() + scale_colour_stata("s2color")
#' # s2mono
#' p + theme_stata(scheme = "s2mono") + scale_colour_stata("mono")
#' # s1color
#' p + theme_stata(scheme = "s2color") + scale_colour_stata("s1color")
#' # s1rcolor
#' p + theme_stata(scheme = "s1rcolor") + scale_colour_stata("s1rcolor")
#' # s1mono
#' p + theme_stata(scheme = "s1mono") + scale_colour_stata("mono")
theme_stata <- function(base_size = 11, base_family = "sans", scheme="s2color") {
  ## Sizes
  (theme_stata_base(base_size = eval(base_size), base_family = base_family)
   + theme_stata_colors(scheme = scheme))
}

#' Stata shape palette (discrete)
#'
#' Shape palette based on the symbol palette in Stata, specifically
#' that for the scheme s2mono.
#'
#' @export
#' @family shapes stata
#' @seealso See \code{\link{scale_shape_stata}} for examples.
stata_shape_pal <- function() {
  ## From s1mono, ignore small shapes
  shapenames <- c("circle", "diamond", "square",
                  "triangle", "x", "plus",
                  "circle_hollow", "diamond_hollow",
                  "square_hollow", "triangle_hollow")
  values <- ggthemes_data$stata$shapes[shapenames]
  manual_pal(unname(values))
}

#' Stata shape scale
#'
#' See \code{\link{stata_shape_pal}} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shape stata
#' @export
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
#'      facet_wrap(~am)
#' p + theme_stata() + scale_shape_stata()
scale_shape_stata <- function (...) {
  discrete_scale("shape", "stata", stata_shape_pal(), ...)
}

#' Stata linetype palette (discrete)
#'
#' Linetype palette based on the linepattern scheme in Stata.
#'
#' @family linetype stata
#' @export
#' @seealso \code{\link{scale_linetype_stata}}
stata_linetype_pal <- function() {
  values <- ggthemes_data$stata$linetypes
  function(n) {
    values[seq_len(n)]
  }
}

#' Stata linetype palette (discrete)
#'
#' See \code{\link{stata_linetype_pal}} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family linetype stata
#' @export
#' @examples
#' library("reshape2") # for melt
#' library("plyr") # for ddply
#' library("ggplot2")
#' ecm <- melt(economics, id = "date")
#' rescale01 <- function(x) {(x - min(x)) / diff(range(x))}
#' ecm <- ddply(ecm, "variable", transform, value = rescale01(value))
#' ggplot(ecm, aes(x = date, y = value, linetype=variable)) +
#'   geom_line() +
#'   scale_linetype_stata()
scale_linetype_stata <- function(...)  {
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
## stata_linewidth <-
##     c(medium  = 0.3,
##       medthick = 0.45,
##       medthin = 0.25,
##       none = 0,
##       thick = 0.8,
##       thin = 0.2,
##       vthick = 1.4,
##       thin = 0.15,
##       vvthick = 2.6,
##       vvthin = 0.01,
##       vvvthick = 4.2,
##       vvvthin = .000001)

## Stata margin styles
## Units are npc * 100
## Left, right, top, bottom
## ggplot margins go top, right, bottom, left.
## From ado/base/style/margin-*.style
## stata_margins <-
##     list(bargraph = c(3.5, 3.5, 3.5, 0),
##          bottom = c(0, 0, 0, 3),
##          ebargraph = c(1.5, 1.5, 1.5, 0),
##          esubhead = c(2.2, 2.2, 0, 4),
##          horiz_bargraph = c(0, 3.5, 3.5, 3.5),
##          large = c(8, 8, 8, 8),
##          left = c(3, 0, 0, 0),
##          medium = c(3.5, 3.5, 3.5, 3.5),
##          medlarge = c(5, 5, 5, 5),
##          medsmall = c(2.2, 2.2, 2.2, 2.2),
##          right = c(0, 3, 0, 0),
##          sides = c(3.5, 3.5, 0, 0),
##          small = rep(1.2, 4),
##          tiny = rep(0.3, 4),
##          top_bottom = c(0, 0, 3.5, 3.5),
##          top = c(0, 0, 3, 0),
##          vlarge = rep(12, 4),
##          vsmall = rep(0.6, 4),
##          zero = rep(0, 4))
