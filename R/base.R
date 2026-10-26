#' Base R graphics theme
#'
#' Theme similar to the default settings of the "base" R graphics.
#'
#' The theme is fixed: it does not change with [graphics::par()]. Use
#' [theme_par()] for a theme that follows the current `par()` values.
#'
#' @param base_size Base font size, in points. The default, 12, is the
#'   default text size of base graphics devices.
#' @inheritParams ggplot2::theme_bw
#' @returns A ggplot2 theme object (class `theme`).
#' @export
#' @family themes
#' @example inst/examples/ex-theme_base.R
theme_base <- function(base_size = 12, base_family = "") {
  theme_foundation() +
    theme(
      line = element_line(
        colour = "black",
        lineend = "round",
        linetype = "solid"
      ),
      rect = element_rect(
        fill = "white",
        colour = "black",
        linetype = "solid"
      ),
      text = element_text(
        colour = "black",
        face = "plain",
        family = base_family,
        size = base_size,
        vjust = 0.5,
        hjust = 0.5,
        lineheight = 1
      ),
      panel.grid = element_blank(),
      strip.background = element_rect(colour = NA),
      legend.key = element_rect(colour = NA),
      title = element_text(size = rel(1)),
      plot.title = element_text(size = rel(1.2), face = "bold"),
      # Base graphics draws axis labels and other text at full size
      # (`cex.axis = 1`), where ggplot2 shrinks them to 0.8.
      strip.text = element_text(size = rel(1)),
      axis.text = element_text(size = rel(1)),
      legend.text = element_text(size = rel(1)),
      plot.caption = element_text(size = rel(1)),
      axis.ticks.length = unit(0.5, "lines")
    )
  # TODO: get margins right
}

#' Theme based on base graphics parameters
#'
#' Theme which uses the current "base" graphics parameter values
#' from [graphics::par()].
#' Not all `par()` parameters are supported, and not all are relevant to
#' ggplot2 themes.
#'
#' Currently this theme uses the values of the parameters:
#' `"adj"`, `"ann"`, `"bg"`, `"bty"`, `"cex"`, `"cex.axis"`, `"cex.lab"`,
#' `"cex.main"`, `"cex.sub"`, `"cin"`, `"col.axis"`, `"col.lab"`,
#' `"col.main"`, `"col.sub"`, `"family"`, `"fg"`, `"font"`, `"font.axis"`,
#' `"font.lab"`, `"font.main"`, `"font.sub"`, `"las"`, `"lend"`, `"lheight"`,
#' `"lty"`, `"lwd"`, `"mar"`, `"mex"`, `"mgp"`, `"oma"`, `"pin"`, `"ps"`,
#' `"tck"`, `"tcl"`, `"xaxt"`, `"yaxt"`, and with ggplot2 4.0.0 or later also
#' `"col"`, `"ljoin"` and `"pch"`.
#'
#' The `"sub"` parameters style `plot.subtitle`, `plot.caption` and
#' `strip.text`. Box types (`"bty"`) other than `"o"`, `"l"` and `"n"` are
#' drawn as a full box, since a theme can only draw axis lines on the sides
#' that have an axis. As in base graphics, `bty = "n"` still draws the axis
#' lines; `guide_axis(cap = "both")` ends them at the outermost ticks the way
#' [graphics::axis()] does. A `tck` of 0.5 or more draws grid lines, and a
#' smaller `tck` is converted using the current plot region size, `"pin"`.
#'
#' This theme does not translate the base graphics perfectly, so the graphs
#' produced by it will not be identical to those produced by base graphics,
#' most notably in the spacing of the margins.
#'
#' With ggplot2 4.0.0 or later, the theme also sets the defaults for geoms,
#' from `"bg"`, `"cex"`, `"cin"`, `"col"`, `"lty"`, `"lwd"`, `"pch"` and `"ps"`, joins
#' lines with `"ljoin"`, and sets the default palettes. Discrete scales use the
#' current [grDevices::palette()], recycled as base graphics does when there
#' are more groups than colours. Continuous scales use
#' `hcl.colors(12, "YlOrRd", rev = TRUE)`, the default colours of
#' [graphics::image()] and [graphics::filled.contour()].
#'
#' Like [graphics::par()] itself, `theme_par()` opens a graphics device if
#' none is open, because the parameter values belong to a device.
#'
#' @param base_size Base font size, in points. Defaults to the base graphics
#'   text size, `par("ps") * par("cex")`.
#' @param base_family Base font family. Defaults to `par("family")`.
#' @returns A ggplot2 theme object (class `theme`).
#' @export
#' @family themes
#' @example inst/examples/ex-theme_par.R
theme_par <- function(base_size = par("ps") * par("cex"), base_family = par("family")) {
  p <- par()
  # One margin line, in points: base graphics sizes margins by the device's
  # default character height, `cin`, scaled by `mex`.
  line_pt <- p$mex * p$cin[2] * 72
  # Tick length in points. Negative lengths draw ticks inside the panel, which
  # is what positive `tck` and `tcl` do in base graphics.
  big_tck <- !is.na(p$tck) && p$tck >= 0.5
  tick_pt <- if (is.na(p$tck)) {
    -p$tcl * p$cin[2] * p$cex * 72
  } else if (big_tck) {
    0
  } else {
    -p$tck * min(p$pin) * 72
  }
  # Distance from the end of the ticks to the tick labels, and from the tick
  # labels to the axis title (`mgp` gives their margin lines).
  text_pt <- max(p$mgp[2] * line_pt - max(tick_pt, 0), 0)
  title_pt <- max((p$mgp[1] - p$mgp[2]) * line_pt - p$cex.axis * base_size, 0)
  # Margins left over once the axis titles (and plot title) are placed.
  axis_pt <- p$mgp[1] * line_pt + p$cex.lab * base_size
  main_pt <- max((p$mar[3] * line_pt - p$cex.main * base_size) / 2, 0)
  oma_pt <- p$oma * line_pt
  plot_margin <- margin(
    t = main_pt + oma_pt[3],
    r = p$mar[4] * line_pt + oma_pt[4],
    b = max(p$mar[1] * line_pt - axis_pt, 0) + oma_pt[1],
    l = max(p$mar[2] * line_pt - axis_pt, 0) + oma_pt[2],
    unit = "pt"
  )
  half_line <- base_size / 2
  linewidth <- p$lwd / ggplot2::.pt

  thm <- theme_foundation() %+replace%
    theme(
      line = element_line(
        colour = p$fg,
        linewidth = linewidth,
        lineend = p$lend,
        linetype = p$lty
      ),
      rect = element_rect(
        fill = p$bg,
        colour = p$fg,
        linewidth = linewidth,
        linetype = p$lty
      ),
      text = element_text(
        colour = p$fg,
        face = par_face(p$font),
        family = base_family,
        size = base_size,
        angle = 0,
        margin = margin(),
        vjust = 0.5,
        hjust = 0.5,
        lineheight = p$lheight,
        debug = FALSE
      ),
      axis.title = element_text(
        size = rel(p$cex.lab),
        colour = p$col.lab,
        face = par_face(p$font.lab),
        hjust = p$adj
      ),
      axis.title.x = element_text(margin = margin(t = title_pt, unit = "pt")),
      axis.title.x.top = element_text(margin = margin(b = title_pt, unit = "pt")),
      axis.title.y = element_text(angle = 90, margin = margin(r = title_pt, unit = "pt")),
      axis.title.y.right = element_text(angle = -90, margin = margin(l = title_pt, unit = "pt")),
      axis.text = element_text(
        size = rel(p$cex.axis),
        colour = p$col.axis,
        face = par_face(p$font.axis)
      ),
      axis.text.x = element_text(margin = margin(t = text_pt, unit = "pt"), vjust = 1),
      axis.text.x.top = element_text(margin = margin(b = text_pt, unit = "pt"), vjust = 0),
      axis.text.y = element_text(margin = margin(r = text_pt, unit = "pt"), hjust = 1),
      axis.text.y.right = element_text(margin = margin(l = text_pt, unit = "pt"), hjust = 0),
      axis.ticks = element_line(colour = p$fg),
      axis.ticks.length = unit(tick_pt, "pt"),
      legend.title = element_text(colour = p$fg),
      legend.text = element_text(colour = p$fg),
      legend.spacing = unit(0.2, "cm"),
      legend.key = element_rect(colour = NA),
      panel.spacing = unit(half_line, "pt"),
      panel.spacing.x = NULL,
      panel.spacing.y = NULL,
      panel.background = element_rect(fill = NA, colour = NA),
      panel.border = element_rect(fill = NA, colour = p$fg),
      panel.grid = element_blank(),
      plot.background = element_rect(colour = NA),
      plot.margin = plot_margin,
      plot.title = element_text(
        size = rel(p$cex.main),
        face = par_face(p$font.main),
        colour = p$col.main,
        hjust = p$adj,
        margin = margin(b = main_pt, unit = "pt")
      ),
      plot.subtitle = element_text(
        size = rel(p$cex.sub),
        face = par_face(p$font.sub),
        colour = p$col.sub,
        hjust = p$adj,
        margin = margin(b = half_line)
      ),
      plot.caption = element_text(
        size = rel(p$cex.sub),
        face = par_face(p$font.sub),
        colour = p$col.sub,
        hjust = p$adj,
        margin = margin(t = half_line)
      ),
      strip.text = element_text(
        size = rel(p$cex.sub),
        face = par_face(p$font.sub),
        colour = p$col.sub
      ),
      strip.text.x = element_text(
        margin = margin(
          t = half_line,
          b = half_line
        )
      ),
      strip.text.y = element_text(
        margin = margin(
          l = half_line,
          r = half_line
        )
      ),
      strip.background = element_rect(colour = NA)
    )

  # `las` rotates the tick labels; axis titles stay parallel to the axis.
  # Labels perpendicular to an axis are justified at the end nearest it.
  if (p$las %in% c(2, 3)) {
    thm <- thm +
      theme(
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        axis.text.x.top = element_text(angle = 90, hjust = 0, vjust = 0.5)
      )
  }
  if (p$las %in% c(0, 3)) {
    thm <- thm +
      theme(
        axis.text.y = element_text(angle = 90, hjust = 0.5, vjust = 0),
        axis.text.y.right = element_text(angle = 90, hjust = 0.5, vjust = 1)
      )
  }

  if (big_tck) {
    thm <- thm + theme(panel.grid.major = element_line(colour = p$fg))
  }

  thm <- thm + par_bty(p$bty, p$fg)

  # ggplot2 >= 4.0.0 also takes geom defaults and palettes from the theme.
  if (rlang::is_installed("ggplot2", version = "4.0.0")) {
    thm <- thm + par_geom_theme(p, base_size, base_family)
  }

  if (!p$ann) {
    thm <- thm +
      theme(
        plot.title = element_blank(),
        plot.subtitle = element_blank(),
        plot.caption = element_blank(),
        axis.title = element_blank()
      )
  }

  # plot x or y axis
  if (p$xaxt == "n") {
    thm <- thm +
      theme(
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      )
  }
  if (p$yaxt == "n") {
    thm <- thm +
      theme(
        axis.line.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
      )
  }

  thm
}

# Geom defaults, line joins and palettes from `par()` and `palette()`, using
# theme settings added in ggplot2 4.0.0.
par_geom_theme <- function(p, base_size, base_family) {
  # Base graphics sizes symbols at half the device's character height times
  # `cex`. ggplot2 sizes points in mm, excluding their default stroke.
  linewidth <- p$lwd / ggplot2::.pt
  symbol_pt <- 0.5 * p$cin[2] * 72 * p$cex
  discrete <- par_discrete_pal(grDevices::palette())
  continuous <- grDevices::hcl.colors(12, "YlOrRd", rev = TRUE)
  theme(
    line = element_line(linejoin = p$ljoin),
    geom = ggplot2::element_geom(
      ink = p$col,
      paper = p$bg,
      linewidth = linewidth,
      borderwidth = linewidth,
      linetype = p$lty,
      bordertype = p$lty,
      family = base_family,
      fontsize = base_size / ggplot2::.pt,
      pointsize = (symbol_pt - 0.5 * ggplot2::.stroke / 2) / ggplot2::.pt,
      pointshape = p$pch
    ),
    palette.colour.discrete = discrete,
    palette.fill.discrete = discrete,
    palette.colour.continuous = continuous,
    palette.fill.continuous = continuous
  )
}

# Base graphics recycles `palette()` when there are more groups than colours.
par_discrete_pal <- function(colours) {
  force(colours)
  function(n) rep_len(colours, n)
}

# Convert a base graphics font number to a ggplot2 font face.
par_face <- function(font, call = rlang::caller_env()) {
  faces <- c("plain", "bold", "italic", "bold.italic")
  if (font %in% seq_along(faces)) {
    return(faces[[font]])
  }
  cli::cli_warn(
    "Font {font} has no ggplot2 font face, so {.fn theme_par} uses {.val plain}.",
    call = call
  )
  "plain"
}

# Theme elements for the box drawn around the plot region, `par("bty")`.
par_bty <- function(bty, colour) {
  axis_lines <- theme(
    panel.border = element_blank(),
    axis.line = element_line(colour = colour)
  )
  switch(
    bty,
    l = axis_lines,
    n = axis_lines,
    theme(panel.border = element_rect(fill = NA, colour = colour))
  )
}
