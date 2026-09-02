# Stata's factory default scheme changed from s2color to stcolor in Stata 18.
# ggthemes will follow in 7.0.0; until then an omitted `scheme` keeps the
# historical default and says so.
#' @importFrom lifecycle deprecate_soft
stata_default_scheme <- function(scheme, what) {
  if (!is.null(scheme)) {
    return(scheme)
  }
  deprecate_soft(
    "6.1.0",
    I(paste0("Omitting `scheme` in ", what)),
    details = c(
      i = paste0(
        "The default will change from \"s2color\" to \"stcolor\" in ggthemes 7.0.0, ",
        "following Stata 18's change of factory default."
      ),
      i = "Set `scheme` explicitly to keep the current appearance."
    )
  )
  "s2color"
}

#' Stata color palettes (discrete)
#'
#' Stata color palettes. See Stata documentation for a description of
#' the schemes, \url{https://www.stata.com/help.cgi?schemes}.
#'
#' All these palettes support up to 15 values.
#'
#' @details
#' Stata's palettes come in two generations, and both are included here.
#'
#' \describe{
#' \item{Stata 17 and earlier}{Schemes \code{"s2color"}, \code{"s1color"},
#' \code{"s1rcolor"}, and \code{"mono"} are built from Stata's classic named
#' colors (\code{navy}, \code{maroon}, \code{forest_green}, and so on) and the
#' \code{gs0}--\code{gs16} gray scale. \code{"s2color"} was Stata's factory
#' default through Stata 17.}
#' \item{Stata 18 and later}{Scheme \code{"stcolor"} uses the
#' \code{stc1}--\code{stc15} colors introduced in Stata 18. They are brighter
#' than the classic palette and chosen to stay distinguishable for readers
#' with a color vision deficiency. The first four are also available under
#' the aliases \code{stblue}, \code{stred}, \code{stgreen}, and
#' \code{styellow}. \code{"stcolor"} has been Stata's factory default since
#' Stata 18.}
#' }
#'
#' \code{"economist"} is not one of Stata's general-purpose schemes; it is the
#' set of Economist-styled colors that Stata ships in
#' \code{scheme-economist.scheme}.
#'
#' @param scheme \code{character}. One of \code{"s2color"},
#' \code{"s1rcolor"}, \code{"s1color"}, \code{"mono"}, \code{"stcolor"}, or
#' \code{"economist"}. If \code{NULL}, the default, \code{"s2color"} is used
#' and a deprecation message is issued; this default becomes \code{"stcolor"}
#' in ggthemes 7.0.0.
#'
#' @export
#' @family colour stata
#' @example inst/examples/ex-stata_pal.R
stata_pal <- function(scheme = NULL) {
  scheme <- stata_default_scheme(scheme, "stata_pal()")
  schemes <- ggthemes::ggthemes_data[["stata"]][["colors"]][["schemes"]]
  if (!scheme %in% names(schemes)) {
    cli::cli_abort("{.arg scheme} must be one of {.val {sort(names(schemes))}}, not {.val {scheme}}.")
  }
  colors <- schemes[[scheme]]
  f <- manual_pal_checked(colors[["value"]])
  attr(f, "max_n") <- nrow(colors)
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
scale_colour_stata <- function(scheme = NULL, ...) {
  scheme <- stata_default_scheme(scheme, "scale_colour_stata()")
  discrete_scale("colour", palette = stata_pal(scheme), ...)
}

#' @export
#' @rdname scale_stata
scale_fill_stata <- function(scheme = NULL, ...) {
  scheme <- stata_default_scheme(scheme, "scale_fill_stata()")
  discrete_scale("fill", palette = stata_pal(scheme), ...)
}

#' @export
#' @rdname scale_stata
scale_color_stata <- scale_colour_stata

# Stata text sizes expressed relative to gsize medium, which is what
# `base_size` corresponds to.
stata_relsize <- function() {
  relsz <- sapply(as.numeric(stata_gsize), `/`, y = as.numeric(stata_gsize$medium))
  names(relsz) <- names(stata_gsize)
  relsz
}

#' @importFrom ggplot2 margin
theme_stata_base <- function(base_size = 11, base_family = "sans") {
  ## Sizes
  relsz <- stata_relsize()
  theme_foundation() +
    theme(
      line = element_line(
        linewidth = 0.5,
        linetype = 1,
        lineend = "butt",
        colour = "black"
      ),
      rect = element_rect(
        linewidth = 0.5,
        linetype = 1,
        fill = "white",
        colour = "black"
      ),
      text = element_text(
        family = base_family,
        face = "plain",
        colour = "black",
        size = base_size,
        hjust = 0.5,
        vjust = 1,
        angle = 0,
        lineheight = 1,
        margin = margin(),
        debug = FALSE
      ),
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
      legend.background = element_rect(
        linetype = 1,
        linewidth = rel(stata_linewidths[["thin"]])
      ),
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
      plot.title = element_text(
        size = rel(relsz["large"]),
        hjust = 0.5,
        vjust = 1
      ),
      # Stata subtitle
      plot.subtitle = element_text(
        size = rel(relsz["medium"]),
        hjust = 0.5,
        vjust = 1
      ),
      # Stata note
      plot.caption = element_text(
        size = rel(relsz["small"]),
        hjust = 0,
        vjust = 0
      ),
      plot.margin = unit(rep(0.035, 4), "npc")
    )
}

# Layout, as opposed to color, differences of the Stata 18 st family.
#
# Measured from Stata 18-generated reference graphs; see
# `data-raw/reference/stata/SOURCES.md`. The legacy schemes get an empty
# theme, so nothing about their appearance changes.
theme_stata_layout <- function(scheme = "s2color") {
  relsz <- stata_relsize()
  # stsj is sj with a white background and horizontal y-axis labels; it does
  # not take the rest of the st family's layout.
  if (scheme == "stsj") {
    return(theme(axis.text.y = element_text(angle = 0, vjust = 0.5)))
  }
  if (!scheme %in% c("stcolor", "stcolor_alt", "stmono1", "stmono2")) {
    return(theme())
  }
  out <- theme(
    # y-axis labels are horizontal rather than rotated.
    axis.text.y = element_text(angle = 0, vjust = 0.5),
    # The major grid is dashed and drawn on both axes. Stata draws 64.8-unit
    # dashes separated by 32.4-unit gaps at a line width of 9.72, i.e. a 2:1
    # on/off ratio measured in line widths.
    panel.grid.major = element_line(linetype = "63"),
    panel.grid.major.x = element_line(),
    # Titles are set in gsize medium, not the large that s1/s2 use.
    plot.title = element_text(size = rel(relsz[["medium"]])),
    plot.subtitle = element_text(size = rel(relsz[["medsmall"]])),
    # The legend sits beside the plot with no surrounding box.
    legend.position = "right",
    legend.direction = "vertical",
    legend.justification = "center",
    legend.title = element_text(size = rel(relsz[["medsmall"]]), hjust = 0)
  )
  if (scheme == "stcolor_alt") {
    out <- out +
      theme(legend.position = "bottom", legend.direction = "horizontal")
  }
  out
}

#' @importFrom tibble deframe
theme_stata_colors <- function(scheme = "s2color") {
  stata_colors <- ggthemes::ggthemes_data[["stata"]][["colors"]][["names"]]
  stata_colors <- deframe(stata_colors[, c("name", "value")])
  # schemes is used inside the cli_abort() glue string below, which
  # object_usage_linter can't see into.
  # nolint start: object_usage_linter
  schemes <- c(
    "s2color",
    "s2mono",
    "s2manual",
    "sj",
    "s1color",
    "s1rcolor",
    "s1mono",
    "s1manual",
    "stcolor",
    "stcolor_alt",
    "stmono1",
    "stmono2",
    "stsj"
  )
  # nolint end: object_usage_linter
  if (scheme == "s2color") {
    color_plot <- stata_colors["ltbluishgray"]
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors["ltbluishgray"]
    # color_grid_major <- stata_colors["ltbluishgray"]
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
    # color_grid_major <- stata_colors["dimgray"]
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
  } else if (scheme %in% c("stcolor", "stcolor_alt")) {
    # Values read from Stata 18-generated SVGs; see data-raw/reference/stata.
    # The graph region, plot region and legend are all plain white, and the
    # grid and the by-graph strips share gs15.
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors[["gs15"]]
    fill_strip <- stata_colors[["gs15"]]
    color_strip <- NA
    color_title <- "black"
    color_border <- NA
    legend_border <- NA
  } else if (scheme == "stmono1") {
    # stcolor over s1mono: s1mono's white background and gs14 grid, but
    # stcolor's borderless legend.
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors[["gs14"]]
    fill_strip <- stata_colors[["gs13"]]
    color_strip <- "black"
    color_title <- "black"
    color_border <- "black"
    legend_border <- NA
  } else if (scheme %in% c("stmono2", "stsj")) {
    # stcolor over s2mono: s2mono's dimgray grid, but stcolor's white
    # background in place of s2mono's gs15.
    color_plot <- "white"
    color_bg <- "white"
    color_fg <- "black"
    color_grid <- stata_colors[["dimgray"]]
    fill_strip <- stata_colors[["gs13"]]
    color_strip <- NA
    color_title <- "black"
    color_border <- NA
    legend_border <- NA
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
    cli::cli_abort("{.arg scheme} must be one of {.val {sort(schemes)}}, not {.val {scheme}}.")
  }

  theme(
    line = element_line(colour = color_fg, linetype = 1),
    rect = element_rect(fill = color_bg, colour = color_fg, linetype = 1),
    text = element_text(colour = color_fg),
    title = element_text(colour = color_title),
    axis.title = element_text(colour = color_fg),
    axis.ticks.x = element_line(colour = color_fg),
    axis.ticks.y = element_line(colour = color_fg),
    axis.text.x = element_text(colour = color_fg),
    axis.text.y = element_text(colour = color_fg),
    legend.key = element_rect(fill = color_bg, colour = NA, linetype = 0),
    legend.background = element_rect(
      linetype = 1,
      colour = legend_border
    ),
    panel.background = element_rect(
      fill = color_bg,
      colour = color_border,
      linetype = 1
    ),
    panel.grid.major = element_line(colour = color_grid),
    strip.background = element_rect(
      fill = fill_strip,
      colour = color_strip,
      linetype = 1
    ),
    plot.background = element_rect(fill = color_plot)
  )
}

#' Themes based on Stata graph schemes
#'
#' @param scheme One of "stcolor", "stcolor_alt", "stmono1", "stmono2",
#'   "stsj", "s2color", "s2mono", "s1color", "s1rcolor", "s1mono",
#'   "s2manual", "s1manual", or "sj". If \code{NULL}, the default,
#'   "s2color" is used and a deprecation message is issued; this default
#'   becomes "stcolor" in ggthemes 7.0.0.
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
#' The schemes fall into two generations. \code{"stcolor"},
#' \code{"stcolor_alt"}, \code{"stmono1"}, \code{"stmono2"} and \code{"stsj"}
#' are the st family introduced in Stata 18, of which \code{"stcolor"} is
#' Stata's current factory default: a white background, a dashed grid on both
#' axes, horizontal y-axis labels, and a borderless legend beside the plot.
#' The remaining schemes are the s1/s2 families that were the default through
#' Stata 17.
#'
#' Stata expresses text sizes as a percentage of graph height, while ggplot2
#' uses absolute points, so the two agree only at a particular graph size.
#' The relative sizes here match Stata exactly; \code{base_size = 12.4}
#' reproduces Stata's absolute sizes at its default 7.5 by 4.5 inch graph.
#' Two further differences are not expressible in a ggplot2 theme: the number
#' of legend columns (set by \code{\link[ggplot2]{guide_legend}()} rather than
#' the theme) and Stata's small default marker size (a geom default).
#'
#' @references \url{https://www.stata.com/help.cgi?schemes}
#'
#' @example inst/examples/ex-theme_stata.R
theme_stata <- function(base_size = 11, base_family = "sans", scheme = NULL) {
  scheme <- stata_default_scheme(scheme, "theme_stata()")
  theme_stata_base(base_size = base_size, base_family = base_family) +
    theme_stata_layout(scheme = scheme) +
    theme_stata_colors(scheme = scheme)
}

#' Select shape rows by symbolstyle, in the order asked for
#'
#' A bare `match()` returns `NA` for a name the catalogue does not have, which
#' indexes an all-`NA` row. `new_shape_pal()` would then drop that row as "no
#' font-independent equivalent" and report a `max_n` quietly below the
#' documented ten. Every other name lookup this data goes through fails loudly
#' -- `shape_table()` in `data-raw/build.R` aborts on an unknown shape name --
#' so this one does too.
#' @noRd
stata_shape_rows <- function(statadata, shapes) {
  idx <- match(shapes, statadata[["symbolstyle"]])
  if (anyNA(idx)) {
    # `absent` is read only inside cli's glue strings, which lintr cannot see.
    absent <- shapes[is.na(idx)] # nolint: object_usage_linter.
    cli::cli_abort(c(
      "Stata shape data is missing {length(absent)} symbolstyle{?s}: {.val {absent}}.",
      "i" = paste(
        "This means {.code ggthemes_data$stata$shapes} disagrees with the",
        "palette's canonical symbolstyles; rebuild it with {.file data-raw/build.R}."
      )
    ))
  }
  statadata[idx, ]
}

#' Stata shape palette (discrete)
#'
#' Shape palette based on the symbol palette in Stata used in scheme s2mono.
#' This palette supports up to 10 values.
#'
#' @inheritParams cleveland_shape_pal
#'
#' @note
#'
#' Stata's ten plotting symbols all have a base pch equivalent, so this palette
#' supports ten values on either branch and nothing is dropped:
#' solid and hollow circle, diamond, square and triangle, plus the X and the
#' plus sign.
#'
#' @export
#' @family shapes stata
#' @seealso See \code{\link{scale_shape_stata}()} for examples.
#' @importFrom purrr map_dfr map
#' @importFrom tibble as_tibble
stata_shape_pal <- function(unicode = FALSE) {
  statadata <- ggthemes::ggthemes_data[["stata"]][["shapes"]]
  new_shape_pal(
    stata_shape_rows(statadata, stata_palette_shapes),
    unicode = unicode
  )
}

#' Stata shape scale
#'
#' See \code{\link{stata_shape_pal}()} for details.
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams stata_shape_pal
#' @family shapes stata
#' @export
#' @example inst/examples/ex-scale_shape_stata.R
#' @importFrom ggplot2 discrete_scale
scale_shape_stata <- function(..., unicode = FALSE) {
  discrete_scale("shape", palette = stata_shape_pal(unicode = unicode), ...)
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
scale_linetype_stata <- function(...) {
  discrete_scale("linetype", palette = stata_linetype_pal(), ...)
}

## Text sizes (from style definitions ado/base/style/gsize-*.style)
stata_gsize <-
  lapply(
    c(
      default = 4.1667,
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
      zero = 0
    ) /
      100,
    unit,
    units = "npc"
  )

# Line width styles ado/base/style/linewidth-*.style
# original values in npc * 100
# provide this in terms of relative values to medium
stata_linewidths <-
  c(
    medium = 0.3,
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
    vvvthin = .000001
  ) /
  0.3


# Stata margin styles
# From ado/base/style/margin-*.style
stata_margins <- list(
  bargraph = c(3.5, 3.5, 3.5, 0),
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
  zero = rep(0, 4)
)

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
