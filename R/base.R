#' Theme Base
#'
#' Theme similar to the default settings of the \sQuote{base} R graphics.
#'
#' @inheritParams ggplot2::theme_bw
#' @export
#' @family themes
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
#'      colour=factor(gear))) + facet_wrap(~am)
#' p + theme_base()
theme_base <- function(base_size = 16, base_family = "") {
 theme_foundation() +
    theme(line = element_line(colour = "black",
                              lineend = "round",
                              linetype = "solid"),
          rect = element_rect(fill = "white",
                              colour = "black",
                              linetype = "solid"),
          text = element_text(colour = "black",
                              face = "plain",
                              family = base_family,
                              size = base_size,
                              vjust = 0.5,
                              hjust = 0.5,
                              lineheight = 1),
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

# #' Theme Par
#'
#' Theme which takes its values from the current \sQuote{base} graphics
#' parameter values in \code{\link{par}}.
#'
#' Currently this theme uses the values of the parameters:
#' \code{"code"}, "\code{"ps"}", \code{"code"} \code{"family"}, \code{"fg"},
#' \code{"bg"}, \code{"adj"}, \code{"font"}, \code{"cex.axis"},
#' \code{"cex.lab"}, \code{"cex.main"}, \code{"cex.sub"}, \code{"col.axis"},
#' \code{"col.lab"}, \code{"col.main"}, \code{"col.sub"}, \code{"font"},
#' \code{"font.axis"}, \code{"font.lab"}, \code{"font.main"},
#' \code{"font.sub"}, \code{"las"}, \code{"lend"},
#' \code{"lheight"}, \code{"lty"}, \code{"mar"}, \code{"ps"}, \code{"tcl"},
#' \code{"tck"}, \code{"xaxt"}, \code{"yaxt"}.
#'
#' This theme does not translate the base graphics perfectly, so the graphs
#' produced by it will not be identical to those produced by base graphics,
#' most notably in the spacing of the margins.
#'
#' @inheritParams ggplot2::theme_bw
#' @export
#' @family themes
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
#'      colour=factor(gear))) + facet_wrap(~am)
#' par(font = 2, col.lab = "red", fg = "blue")
#' p + theme_par()
theme_par <- function(base_size = par()$ps, base_family = par()$family) {
  faces <- c("plain", "bold", "italic", "bold.italic")
  half_line <- base_size / 2
  thm <- theme_foundation() %+replace%
        theme(line = element_line(colour = par()$fg,
                                   size = 0.5,
                                   lineend = par()$lend,
                                   linetype = par()$lty),
        rect = element_rect(fill = par()$bg,
                            colour = par()$fg,
                            size = 0.5,
                            linetype = par()$lty),
        text = element_text(colour = par()$fg,
                            face = faces[par()$font],
                            family = base_family,
                            size = base_size,
                            angle = 0,
                            margin = margin(),
                            vjust = par()$adj,
                            hjust = par()$adj,
                            lineheight = par()$lheight,
                            debug = FALSE),
        axis.title = element_text(size = rel(par()$cex.lab),
                                  colour = par()$col.lab,
                                  face = faces[par()$font.lab]),
        axis.text = element_text(size = rel(par()$cex.axis),
                                 colour = par()$col.axis,
                                 face = faces[par()$font.axis]),
        axis.text.x = element_text(margin = margin(t = 0.8 * half_line / 2,
                                                   b = 0.8 * half_line / 2)),
        axis.text.y = element_text(margin = margin(r = 0.8 * half_line / 2,
                                                   l = 0.8 * half_line / 2)),
        axis.ticks = element_line(colour = par()$fg),
        legend.title = element_text(colour = par()$fg),
        legend.text = element_text(colour = par()$fg),
        legend.margin = unit(0.2, "cm"),
        legend.key = element_rect(colour = NA),
        panel.margin = unit(half_line, "pt"),
        panel.margin.x = NULL,
        panel.margin.y = NULL,
        panel.background = element_rect(fill = NA, colour = par()$col),
        panel.grid = element_blank(),
        plot.background = element_rect(colour = NA),
        plot.margin = unit(par()$mar, "lines"),
        plot.title = element_text(size = rel(par()$cex.main),
                                  face = faces[par()$font.main],
                                  colour = par()$col.main,
                                  margin = margin(b = half_line * 1.2)),
        strip.text = element_text(size = rel(par()$cex.sub),
                                  face = faces[par()$font.sub],
                                  colour = par()$col.sub),
        strip.text.x = element_text(margin = margin(t = half_line,
                                                    b = half_line)),
        strip.text.y = element_text(margin = margin(l = half_line,
                                                    r = half_line)),
        strip.background = element_rect(colour = NA)
  )

  las <- par()$las
  if (las == 0) {
    # parallel to axis
    thm <- thm + theme(axis.title.x = element_text(angle = 0),
                       axis.title.y = element_text(angle = 90))
  } else if (las == 1) {
    # horizontal
    thm <- thm + theme(axis.title.x = element_text(angle = 0),
                       axis.title.y = element_text(angle = 0))
  } else if (las == 2) {
    # perpendicular
    thm <- thm + theme(axis.title.x = element_text(angle = 90),
                       axis.title.y = element_text(angle = 0))
  } else if (las == 3) {
    # vertical
    thm <- thm + theme(axis.title.x = element_text(angle = 90),
                       axis.title.y = element_text(angle = 90))
  }

  # ticks
  if (! is.na(par()$tck)) {
    thm <- thm + theme(axis.ticks.length = unit(- par()$tck, "snpc"))
  } else {
    thm <- thm + theme(axis.ticks.length = unit(- par()$tcl, "lines"))
  }
  # plot x or y axis
  if (par()$xaxt == "n") {
    thm <- thm + theme(axis.line.x = element_blank(),
                       axis.text.x = element_blank(),
                       axis.ticks.x = element_blank())
  }
  if (par()$yaxt == "n") {
    thm <- thm + theme(axis.line.y = element_blank(),
                       axis.text.y = element_blank(),
                       axis.ticks.y = element_blank())
  }

  thm
  # TODO: get margins right
}
