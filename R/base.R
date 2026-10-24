#' Theme Base
#'
#' Theme similar to the default settings of the "base" R graphics.
#'
#' @inheritParams ggplot2::theme_bw
#' @return A ggplot2 theme object (class `theme`).
#' @export
#' @family themes
#' @example inst/examples/ex-theme_base.R
theme_base <- function(base_size = 16, base_family = "") {
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
      strip.text = element_text(),
      axis.ticks.length = unit(0.5, "lines")
    )
  # TODO: get margins right
}

# Notes for generating a theme that uses par() for its values.
#
# $xlog
# [1] TRUE
#
# $ylog
# [1] TRUE
#
# Justification of strings in text, mtext, and title
# # text = element_text(vjust = par()$adj, hjust = par$adj())
# $adj
# [1] 0.5
#
# $ann
# [1] TRUE
#
# $ask
# [1] FALSE
#
# Background. rect = element_rect(fill = par()$bg)
# $bg
# [1] "white"
#
# # Type of box drawn around the plot
# # Which sides of the box to draw
# $bty
# [1] "o"
#
# # magnification of text and symbols relative to the default. ggplot uses base_size instead.
# $cex
# [1] 1
#
# # mag of axis relative to current setting of cex
# # axis.text = element_text(size = rel(par()$cex.axis))
# $cex.axis
# [1] 1

# # mag of axis relative to current setting of cex
# # axis.title = element_text(size = rel(par()$cex.lab))
# $cex.lab
# [1] 1
#
# # magnification of plot title relative to cex
# # plot.title = element_text(size = rel(par()$cex.main))
# $cex.main
# [1] 1.2
#
# # ggplot does not have subtitles
# # magnification of subtitle relative to cex
# # strip.title = element_text(size = rel(par()$cex.sub))
# $cex.sub
# [1] 1
#
# $cin
# # character size in inches
# [1] 0.2000000 0.2666667
#
# # default plotting color - not part of theme in gggplot
# $col
# [1] "black"
#
# # color for axis annotation
# #
# $col.axis
# [1] "black"
# # color for x and y labels
# # axis.text = element_text(colour = par()$col.axis)
#
# # color for x and y labels
# # axis.title = element_text(colour = par()$col.lab)
# $col.lab
# [1] "black"
#
# # color for main titles
# # plot.title = element_text(colour = par()$col.main)
# $col.main
# [1] "black"
#
# # color for subtitles
# # strip.title = element_text(colour = par()$col.sub)
# $col.sub
# [1] "black"
#
# # size of default character
# $cra
# [1] 14.4 19.2
#
# # numerical values for how single characters rotated. Nothing similar in ggplot
# $crt
# [1] 0
#
# # size of default characters in inches
# # Is this base size?
# $csi
# [1] 0.2666667
#
# # size of default character in user coord
# # not relevant
# $cxy
# [1] 0.1859782 0.3665854
#
# # device dimensions. not relevant
# $din
# [1] 11.236111  8.847222
#
# # error reporting. not relevant
# $err
# [1] 0
#
# # default font family
# # base_family = par()$family
# $family
# [1] ""
#
# # color of foreground in plots. Used in axes and boxes around plots.
# line = element_line(colour = par()$fg)
# rect = element_rect(colour = par()$fg)
# text = = element_text(colour = par()$fg)
# $fg
# [1] "black"
#
# # gives NDC coordinates of figure region in display device
# $fig
# [1] 0 1 0 1
#
# # figure region dimensions in inches
# # TODO: use for aspect ratio?
# $fin
# [1] 11.236111  8.847222
#
# # which font to use for text.
# # 1 = "plain"
# # 2 = "bold"
# # 3 = "italic"
# # 4 = "bold.italic"
# text = element_text(face = c("plain", "bold", "italic", "bold.italic")[par()$font])
# $font
# [1] 1
#
# # font to use for axis
# axis.text = element_text(face = c("plain", "bold", "italic", "bold.italic")[par()$font])
# $font.axis
# [1] 1
#
# axis.title = element_text(face = c("plain", "bold", "italic", "bold.italic")[par()$font])
# $font.lab
# [1] 1
#
# axis.title = element_text(face = c("plain", "bold", "italic", "bold.italic")[par()$font])
# $font.main
# [1] 2
#
# strip.title = element_text(face = c("plain", "bold", "italic", "bold.italic")[par()$font])
# $font.sub
# [1] 1
#
# # default number of tick-marks in x and y, and label lenghth.
# Not sure how that can be used
# $lab
# [1] 5 5 7
#
# # style of axis labels.
# # TODO: code that sets axis.text.x and axis.text.y angle according to its values.
# $las
# [1] 0
#
# # line end style
# line = element_line(lineend = par()$lend)
# $lend
# [1] "round"
#
# # line height
# text = element_text(lineheight = par()$lheight * par()$??)
# $lheight
# [1] 1
#
# # Line join style
# # not sure how this is used in ggplot
# $ljoin
# [1] "round"
#
# # line mitre imit. Not used in ggplot2.
# $lmitre
# [1] 10
#
# # Line type
# # line = element_line(linetype = par()$lty)
# $lty
# [1] "solid"
#
# # Line width?
# # Does this set size? ??
# # Maybe: line = element_line(size = par()$lwd)
# $lwd
# [1] 1
#
# # margin size in inches
# plot.margin = par()$mai
# $mai
# [1] 1.360000 1.093333 1.093333 0.560000
#
# # Number of lines of margin. How is this different than mai?
# $mar
# [1] 5.1 4.1 4.1 2.1
#
# $mex
# [1] 1
#
# # changes layout. ggplot uses facets.
# $mfcol
# [1] 1 1
#
# # used for layout
# $mfg
# [1] 1 1 1 1
#
# # changes layout. ggplot uses facets.
# $mfrow
# [1] 1 1
#
# # margine line in mex units for axis title, axis labels, and axis.line
# $mgp
# [1] 3 1 0
#
# # ignored in R
# $mkh
# [1] 0.001
#
# # irrelevant to ggplot
# $new
# [1] FALSE
#
# # size of outer margins in lines of text
# # TODO: what is this in ggplot
# $oma
# [1] 0 0 0 0
#
# # regions inside out margins in NDC
# # TODO: ?
# $omd
# [1] 0 1 0 1
#
# # size of outer margins in inches
# # TODO???
# $omi
# [1] 0 0 0 0
#
# # irrelevant
# $page
# [1] TRUE
#
# # dfault plotting symbol. not in themes.
# $pch
# [1] 1
#
# # Plot dimensions in inches.
# $pin
# [1] 9.582778 6.393889
#
# # Plot region as fractions of current figure region.
# $plt
# [1] 0.09730532 0.95016069 0.15372057 0.87642072
#
# # point size of text (not symbols)
# base_size = par()$ps
# $ps
# [1] 16
#
# # type of region to be drawn. s = square. m = maximal.
# # not sure how this maps to ggplot
# $pty
# [1] "m"
#
# # not used
# $smo
# [1] 1
#
# # string rotation in degrees
# # this is for text() plots not titles and labels
# $srt
# [1] 0
#
# # length of tick marks
# # use this to set axis.ticks.length
# $tck
# [1] NA
#
# # length of tick marks
# $tcl
# [1] -0.5
#
# # extremes of user coord of plotting regsion
# $usr
# [1] -0.0381697  0.9924122  0.2730712  1.0279588
#
# # used for generating ticks
# $xaxp
# [1]  1 10  3
#
# # used to generate axis
# $xaxs
# [1] "r"
#
# # any values other than "n" implies plotting x axis.
# $xaxt
# [1] "s"
#
# $xpd
# [1] FALSE
#
# $yaxp
# [1]  2 10 -4
#
# $yaxs
# [1] "r"
#
# # any value other than "n" implies plotting y axis.
# $yaxt
# [1] "s"
#
# # positioning of text in margins by axis and mtext.
# $ylbias
# [1] 0.2

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
#' `"tck"`, `"tcl"`, `"xaxt"`, `"yaxt"`.
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
#' Like [graphics::par()] itself, `theme_par()` opens a graphics device if
#' none is open, because the parameter values belong to a device.
#'
#' @param base_size Base font size, in points. Defaults to the base graphics
#'   text size, `par("ps") * par("cex")`.
#' @param base_family Base font family. Defaults to `par("family")`.
#' @return A ggplot2 theme object (class `theme`).
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
