# Helpers shared by the classic-vs-2017 articles. Sourced from the articles as
# `source("economist-classic-helpers.R")`; nothing here is exported.

# The red of the classic charts, looked up by name among the ground colors.
classic_tab_colour <- function() {
  bg <- ggthemes_data$economist$bg
  bg$value[bg$name == "red"]
}

# The classic chart (pre-2017) has a red tab too, but a vertical one flush with
# the left edge, at the top of the chart; the 2017 guide calls the change a
# "rotated tag" (p.3). `theme_economist()` cannot draw it, so this draws it
# around a finished plot, as `economist_2017_chart()` does for the 2017 tab. The
# tab is 5pt wide by 15pt tall, the 2017 tab turned through a right angle. In
# the chart corpus (2012 to 2018) it is on nearly every classic chart, flush
# left and flush with the top edge, at a constant size in points.
classic_chart <- function(plot, tab = c(5, 15), colour = classic_tab_colour()) {
  # Not scaled with the theme's base size: `classic_size` shrinks the type to fit
  # a 160pt chart, but the chart, and so its tab, is the size it is.
  tab_grob <- grid::rectGrob(
    x = grid::unit(0, "npc"),
    y = grid::unit(1, "npc"),
    width = grid::unit(tab[[1]], "pt"),
    height = grid::unit(tab[[2]], "pt"),
    just = c("left", "top"),
    gp = grid::gpar(fill = colour, col = NA)
  )
  # The tab goes into the plot's own layout, spanning all of it, so that it
  # sits at the plot's top left corner even when a fixed aspect ratio (a pie,
  # say) leaves the plot smaller than the space it is drawn in.
  gt <- ggplot2::ggplotGrob(plot)
  gtable::gtable_add_grob(
    gt,
    tab_grob,
    t = 1,
    l = 1,
    b = nrow(gt),
    r = ncol(gt),
    z = Inf,
    clip = "off",
    name = "classic-tab"
  )
}

# `theme_economist()` is sized for a larger figure than the guide's charts: at
# its default `base_size = 10` the title is 15pt, where a one-column chart
# (160pt wide) carries a title of about 9.5pt. The classic charts here use this
# base size so that type is comparable with the 2017 charts at the same size.
# 6.5 is a starting point, to be checked against the charts in the Economist's
# "Mistakes, we've drawn a few" (see economist-mistakes.Rmd).
classic_size <- 6.5

# Draw a classic chart and its 2017 counterpart side by side on one device,
# each in its own half under a heading. Both arguments are grobs: the result of
# `classic_chart()` and of `economist_2017_chart()`.
chart_pair <- function(classic, modern, headings = c("Classic", "2017")) {
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(2, 2, heights = grid::unit(c(1.2, 1), c("lines", "null")))))
  cell <- function(row, col) grid::viewport(layout.pos.row = row, layout.pos.col = col)
  for (j in 1:2) {
    grid::pushViewport(cell(1, j))
    grid::grid.text(headings[[j]], gp = grid::gpar(fontface = "bold", fontsize = 9, col = "#404040"))
    grid::popViewport()
  }
  grid::pushViewport(cell(2, 1))
  grid::grid.draw(classic)
  grid::popViewport()
  grid::pushViewport(cell(2, 2))
  grid::grid.draw(modern)
  grid::popViewport(2)
  invisible(NULL)
}

# The chunk options of the 2017 article: `econ_size` names one of the guide's
# chart sizes and `econ_height` its height in points. A pair is drawn at twice
# the width, one chart in each half, plus a row for the headings.
knitr::opts_chunk$set(econ_size = "one_column", econ_pair = TRUE)
knitr::opts_hooks$set(econ_size = function(options) {
  size <- tryCatch(economist_2017_size(options$econ_size, options$econ_height), error = function(e) NULL)
  if (is.null(size)) {
    return(options)
  }
  w <- size[["width"]] * if (isTRUE(options$econ_pair)) 2 else 1
  options$fig.width <- w
  options$fig.height <- size[["height"]] + if (isTRUE(options$econ_pair)) 0.2 else 0
  options$out.width <- paste0(round(w * 96), "px")
  options
})
