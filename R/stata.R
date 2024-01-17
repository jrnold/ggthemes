#' Stata color palettes (discrete)
#'
#' Stata color palettes. See Stata documentation for a description of
#' the schemes, \url{https://www.stata.com/help.cgi?schemes}.
#'
#' All these palettes support up to 15 values.
#'
#' @param scheme \code{character}. One of \code{"s2color"},
#' \code{"s1rcolor"}, \code{"s1color"}, or \code{"mono"}.
#'
#' @export
#' @family stata colour
#' @example inst/examples/ex-stata_pal.R
stata_pal <- function(scheme="s2color") {
  colors <-
    ggthemes::ggthemes_data[["stata"]][["colors"]][["schemes"]][[scheme]]
  max_n <- length(colors)
  f <- manual_pal(colors[["value"]])
  attr(f, "max_n") <- max_n
  f
}

#' Stata color scales
#'
#' See \code{\link{stata_pal}()} for details.
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

#' @importFrom ggplot2 margin
theme_stata_base <- function(base_size = 11, base_family = "sans") {
  ## Sizes
  relsz <- sapply(as.numeric(stata_gsize), `/`,
                  y = as.numeric(stata_gsize$medium))
  names(relsz) <- names(stata_gsize)
  theme_foundation() +
  theme(line = element_line(linewidth = 0.5, linetype = 1, lineend = "butt",
                            colour = "black"),
        rect = element_rect(linewidth = 0.5, linetype = 1, fill = "white",
                            colour = "black"),
        text = element_text(family = base_family,
                            face = "plain",
                            colour = "black",
                            size = base_size, hjust = 0.5,
                            vjust = 1, angle = 0,
                            lineheight = 1, margin = margin(),
                            debug = FALSE),
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
        legend.background =
          element_rect(linetype = 1,
                       linewidth = rel(stata_linewidths[["thin"]])),
        legend.spacing = unit(1.2 / 100, "npc"),
        legend.key = element_rect(linetype = 0),
        legend.key.size = unit(1.2, "lines"),
        legend.key.height = NULL,
        legend.key.width = NULL,
        legend.text = element_text(size = rel(relsz["medsmall"])),
        legend.text.align = NULL,
        ## See textboxstyle leg_title
        legend.title = element_text(size = rel(relsz["large"]), hjust = 0.5),
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
        panel.spacing = unit(0.25, "lines"),
        ## textboxstyle bytitle      bytitle
        strip.background = element_rect(linetype = 0),
        strip.text = element_text(size = rel(relsz["medlarge"])),
        strip.text.x = element_text(vjust = 0.5),
        strip.text.y = element_text(angle = -90),
        plot.background = element_rect(linetype = 0, colour = NA),
        # Stata subtitle
        plot.title = element_text(size = rel(relsz["large"]),
                                  hjust = 0.5,
                                  vjust = 1),
        # Stata subtitle
        plot.subtitle = element_text(size = rel(relsz["medium"]),
                                     hjust = 0.5,
                                     vjust = 1),
        # Stata note
        plot.caption = element_text(size = rel(relsz["small"]),
                                    hjust = 0, vjust = 0),
        plot.margin = unit(rep(0.035, 4), "npc"))

}

#' @importFrom tibble deframe
#' @importFrom stringr str_c
theme_stata_colors <- function(scheme="s2color") {
  stata_colors <- ggthemes::ggthemes_data[["stata"]][["colors"]][["names"]]
  stata_colors <- deframe(stata_colors[, c("name", "value")])
  schemes <- c("s2color", "s2mono", "s2manual", "sj", "s1color", "s1rcolor",
               "s1mono", "s1manual")
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
    legend_border <- "black"
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
    legend_border <- "black"
  } else if (scheme == "s1color") {
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["gs14"]
    fill_strip <- stata_colors["ltkhaki"]
    color_strip <- "black"
    color_title <- "black"
    color_border <- "black"
    legend_border <- "black"
  } else if (scheme == "s1rcolor") {
    color_plot <- "black"
    color_bg <- "black"
    color_fg <- "white"
    color_grid <- stata_colors["gs5"]
    fill_strip <- stata_colors["maroon"]
    color_strip <- "white"
    color_title <- "white"
    color_border <- "white"
    legend_border <- "black"
  } else if (scheme %in% c("s1mono", "s1manual")) {
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["gs14"]
    fill_strip <- stata_colors["gs13"]
    color_strip <- "black"
    color_title <- "black"
    color_border <- "black"
    legend_border <- "black"
  } else {
    stop(str_c("`scheme` must be one of: ",
               str_c(sort(schemes), collapse = ","), ", "))
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
        legend.background = element_rect(linetype = 1,
                                         colour = legend_border),
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
#' @details These themes approximate Stata schemes using the features
#' \pkg{ggplot2}. The graphical models of Stata and ggplot2 differ
#' in various ways that make an exact replication impossible (or
#' more difficult than it is worth).
#' Some features in Stata schemes not in ggplot2:
#' defaults for specific graph types, different levels of titles,
#' captions and notes. These themes also adopt some of the ggplot2
#' defaults, and more effort was made to match the colors and sizes
#' of major elements than in matching the margins.
#'
#' @references \url{https://www.stata.com/help.cgi?schemes}
#'
#' @example inst/examples/ex-theme_stata.R
theme_stata <- function(base_size = 11, base_family = "sans",
                        scheme="s2color") {
  ## Sizes
  (theme_stata_base(base_size = eval(base_size), base_family = base_family)
   + theme_stata_colors(scheme = scheme))
}

#' Stata shape palette (discrete)
#'
#' Shape palette based on the symbol palette in Stata used in scheme s2mono.
#' This palette supports up to 10 values.
#'
#' @export
#' @family shapes stata
#' @seealso See \code{\link{scale_shape_stata}()} for examples.
#' @importFrom purrr map_dfr map
#' @importFrom tibble as_tibble
#' @importFrom stringr str_replace
stata_shape_pal <- function() {
  ## From s1mono, ignore small shapes
  shapes <- c("circle", "diamond", "square",
              "triangle", "X", "plus",
              "circle_hollow", "diamond_hollow",
              "square_hollow", "triangle_hollow")
  statadata <- ggthemes::ggthemes_data[["stata"]][["shapes"]]
  shapenames <- tibble::deframe(statadata[, c("symbolstyle", "unicode_value")])
  values <- as.hexmode(str_replace(shapenames[shapes], "U\\+", ""))
  values <- -as.integer(values)
  out <- manual_pal(values)
  attr(out, "max_n") <- length(shapes)
  out
}

#' Stata shape scale
#'
#' See \code{\link{stata_shape_pal}()} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shape stata
#' @export
#' @example inst/examples/ex-scale_shape_stata.R
#' @importFrom ggplot2 discrete_scale
scale_shape_stata <- function(...) {
  discrete_scale("shape", "stata", stata_shape_pal(), ...)
}

#' Stata linetype palette (discrete)
#'
#' Linetype palette based on the linepattern scheme in Stata.
#' This palette supports up to 15 values.
#'
#' @family linetype stata
#' @export
#' @seealso \code{\link{scale_linetype_stata}()}
stata_linetype_pal <- function() {
  values <- ggthemes::ggthemes_data[["stata"]][["linetypes"]]
  f <- function(n) {
    values[seq_len(n)]
  }
  attr(f, "max_n") <- length(values)
  f
}

#' Stata linetype palette (discrete)
#'
#' See \code{\link{stata_linetype_pal}()} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family linetype stata
#' @export
#' @example inst/examples/ex-scale_linetype_stata.R
scale_linetype_stata <- function(...)  {
  discrete_scale("linetype", "stata", stata_linetype_pal(), ...)
}

## Text sizes (from style definitions ado/base/style/gsize-*.style)
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

# Line width styles ado/base/style/linewidth-*.style
# original values in npc * 100
# provide this in terms of relative values to medium
stata_linewidths <-
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
      vvvthin = .000001) / 0.3


# Stata margin styles
# From ado/base/style/margin-*.style
stata_margins <- list(bargraph = c(3.5, 3.5, 3.5, 0),
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


# s1mono line
# linepattern p1line  solid
# linepattern p2line  dash
# linepattern p3line  vshortdash
# linepattern p4line  longdash_dot
# linepattern p5line  longdash
# linepattern p6line  dash_dot
# linepattern p7line  dot
# linepattern p8line  shortdash_dot
# linepattern p9line  tight_dot
# linepattern p10line dash_dot_dot
# linepattern p11line longdash_shortdash
# linepattern p12line dash_3dot
# linepattern p13line longdash_dot_dot
# linepattern p14line shortdash_dot_dot
# linepattern p15line longdash_3dot
