# - White Background
# - Title
# - Centered, Helvetica Neue Regular, 12 Pt
# - No Subtitle
#
# Plot Area
#
# -  No Border
#
# Axis
#
# -  Only Y Axis Major Lines
# -  Y Axis Line: 0.5 Pt, #A7a7a7 Small Dotted
# -  No X- Or Y- Axis Lines
# -  Defaults To No Title.
# -  If Title: Helvetica Neue Regular, 10 Pt
# -  Labels: Helvetica Neue Regular, 10 Pt
# -  No Ticks
#
# Legend
#
# -  Below
# -  No Border

#' Theme inspired by Numbers
#'
#' Theme similar to the default theme for charts in
#' \href{https://www.apple.com/numbers/}{Numbers}
#'
#' @inheritParams ggplot2::theme_bw
#'
#' @details
#'
#' The default font for Numbers charts is Helvetica Neue.
#'
#' @export
theme_numbers <- function(base_family = "sans", base_size = 10) {
  theme_bw(base_family = base_family, base_size = base_size) +
    theme(
      text = element_text(face = "plain"),
      title = element_text(face = "plain", size = rel(1), hjust = 0.5),
      line = element_line(colour = "#A7A7A7", linetype = "solid"),
      rect = element_rect(linetype = 0, colour = NA),
      plot.title = element_text(face = "plain", size = rel(1.2),
                                hjust = 0.5,
                                margin = margin(b = base_size * 1.2)),
      plot.subtitle = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_text(size = rel(1)),
      axis.line = element_blank(),
      # Numbers uses dotted lines, but the R dotted linetype is too
      # light and dashed looks less like numbers than solid
      panel.grid.major = element_line(linetype = "solid"),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "bottom"
    )
}

