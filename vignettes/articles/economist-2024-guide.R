# Shared setup for the 2024 style guide (economist-2024-styleguide.Rmd) and its child documents
# (_2024-guide-*.Rmd). The guide draws the 2017 guide's example charts, with the same data, titles and figure sizes,
# in the style of the charts The Economist has drawn since its redesign of March 2024.
#
# Conventions for the child documents:
#
# * Chunk labels start with `g24-`; objects a child creates start with its own prefix (`g24b_` for bars, `g24l_` for
#   lines and scatters, `g24t_` for tables, pies, double scales and blob heads, `g24m_` for timelines and the rest),
#   so the documents can share one knitr session.
# * Figures keep the 2017 chunk's `econ_size` and `econ_height`, and its medium: print unless the 2017 chart is web.
# * Every chart is a `g24_theme()` plot finished by `g24_chart()`, in the 2024 palettes only.

library(ggthemes)
library(ggplot2)
library(grid)
library(gtable)

## ragg writes plain sRGB PNGs; the macOS default device embeds a profile that darkens colors.
knitr::opts_chunk$set(comment = "#>", dpi = 192, dev = "ragg_png")

## Each chunk names a size (`econ_size`, `econ_height`): the 2017 guide's sizes, in points, so that every figure here
## is the size of its 2017 version.
knitr::opts_chunk$set(econ_size = "one_column")
knitr::opts_hooks$set(econ_size = function(options) {
  ## Chunks that draw no figure name no height, and keep knitr's defaults.
  size <- tryCatch(economist_2017_size(options$econ_size, options$econ_height), error = function(e) NULL)
  if (is.null(size)) {
    return(options)
  }
  options$fig.width <- size[["width"]]
  options$fig.height <- size[["height"]]
  options$out.width <- paste0(round(size[["width"]] * 96), "px")
  options
})

## Text drawn on the charts is set in the charts' typeface.
ggplot2::update_geom_defaults("text", list(family = economist_2017_font()))
ggplot2::update_geom_defaults("label", list(family = economist_2017_font()))

## The aesthetics of the helper functions are columns of their data.
.data <- rlang::.data

## The 2024 data, and the six-color qualitative order in each medium, by name.
econ <- ggthemes_data$economist_2024
g24_names <- c("red", "salmon", "blue", "light blue", "dark gray", "light gray")
p24 <- stats::setNames(economist_2024_pal("print")(6), g24_names)
w24 <- stats::setNames(economist_2024_pal("web")(6), g24_names)
## The colors of one medium, by name: `g24_pal("print")[["salmon"]]`.
g24_pal <- function(media = "print") switch(media, print = p24, web = w24)

## The brighter red of a plain single-series chart, and the deeper red of emphasis.
single24 <- c(print = econ$print$single, web = econ$web$single)
accent24 <- c(print = econ$print$accent, web = econ$web$accent)

## The axis-label size of every chart here: the 2017 guide's, so the two guides' figures compare at the same size.
g24_size <- 7

## The 2024 theme at the guide's size.
g24_theme <- function(media = "print", ..., base_size = g24_size) {
  theme_economist_2024(media, base_size = base_size, ...)
}

## The tab, panel rules, number box and footnote that no theme can draw.
g24_chart <- function(plot, media = "print", ...) {
  economist_2024_chart(plot, media, ...)
}

## The value axis: on the right, each label above its gridline at the right-hand end, as in the published charts
## (`20240330_CNC083`, `20240406_BRC149`).
g24_value_axis <- function(...) {
  scale_y_continuous(guide = guide_axis_economist_2017(), position = "right", ...)
}

## A line width given in points.
g24_lw <- function(pt) pt / 0.75 / ggplot2::.pt

## A text size given in points, and the chart's sizes as multiples of the axis-label size.
g24_pt <- function(pt) pt / ggplot2::.pt
g24_text <- g24_pt(g24_size)

## Set the labels of some categories in bold.
g24_bold_label <- function(which) {
  function(x) as.expression(lapply(x, function(l) if (l %in% which) bquote(bold(.(l))) else l))
}

## No value axis: for charts labelled on the marks.
g24_no_value_axis <- function() {
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank(),
    panel.grid.major = element_blank()
  )
}

## No axes at all: for swatches and diagrams. The 2024 theme sets the right-hand axis text itself, so blanking
## `axis.text` alone does not reach it.
g24_no_axes <- function() {
  theme(
    axis.text = element_blank(),
    axis.text.x = element_blank(),
    axis.text.x.top = element_blank(),
    axis.text.y = element_blank(),
    axis.text.y.right = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    panel.grid = element_blank()
  )
}

## The link to the 2017 version of a chart, by the 2017 guide's section anchor.
g24_2017 <- function(anchor, text = "2017 version") {
  sprintf("([%s](economist-2017-styleguide.html#%s))", text, anchor)
}
