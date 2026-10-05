#' Economist text blocks
#'
#' The labelled box *The Economist*'s 2017 styleguide uses to annotate a
#' chart, such as a "Market cap, $bn" key above a column of number blocks or
#' an "ECB announces QE" callout on a line: text set in a shaded box, with a
#' small pointer on one side aimed at the thing it labels.
#'
#' The box follows the guide's specification in points, whatever the size of
#' the figure: 12pt tall for one line of text, 23pt for two, and 11pt more for
#' each further line, with 6pt of padding either side of the text. The pointer
#' is a triangle 5pt across and 3.75pt deep. It is centred on its side of the
#' box unless `hjust` (for a pointer on the top or bottom) or `vjust` (for one
#' on the left or right) moves it, and then stays at least 6pt in from the
#' box's corners where the box is big enough.
#'
#' `x` and `y` are the point the pointer touches, so the box sits beside the
#' data it labels. With `pointer = "none"`, they place the box itself, and
#' `hjust` and `vjust` justify it as they would text.
#'
#' The guide fills the box with its number-box color (C22.5 K15) at 100%
#' multiply. The default `fill` is that color; on the pale blue print
#' background, pass the multiplied color for an exact match (see the
#' examples).
#'
#' @section Aesthetics:
#' `geom_label_economist_2017()` understands the following aesthetics (required ones
#' are in bold):
#'
#' * **`x`**, **`y`**: the point the pointer touches.
#' * **`label`**: the text. Use `"\\n"` for a line break.
#' * `colour`: text color. Default black.
#' * `fill`: box color. Default the guide's number-box color.
#' * `alpha`: box transparency.
#' * `size`: text size in mm. Default 7.5pt, the guide's.
#' * `family`, `fontface`: the text's font.
#' * `hjust`, `vjust`: where the pointer sits along its side of the box,
#'   from 0 to 1; or, with `pointer = "none"`, the box's justification.
#'
#' @inheritParams ggplot2::geom_text
#' @param pointer Which side of the box the pointer is on: `"bottom"` (the
#'   default; the box sits above `x`, `y`), `"top"`, `"left"`, `"right"`, or
#'   `"none"` for a plain box.
#' @param padding Space either side of the text, in points. The guide
#'   specifies 6pt; a smaller value fits a block into a tight corner.
#'
#' @return A [ggplot2::layer()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean).
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-geom_label_economist_2017.R
# nolint start: object_name_linter. ggplot2's own argument names.
geom_label_economist_2017 <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  pointer = c("bottom", "top", "left", "right", "none"),
  padding = 6,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
) {
  pointer <- rlang::arg_match(pointer)
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomLabelEconomist2017,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(pointer = pointer, padding = padding, na.rm = na.rm, ...)
  )
}
# nolint end

#' @rdname geom_label_economist_2017
#' @usage NULL
#' @format NULL
#' @export
#' @importFrom ggplot2 ggproto Geom aes draw_key_rect
# nolint start: object_name_linter
GeomLabelEconomist2017 <- ggproto(
  "GeomLabelEconomist2017",
  Geom,
  required_aes = c("x", "y", "label"),
  default_aes = aes(
    colour = "black",
    fill = "#B8D2E0",
    alpha = NA,
    size = 7.5 / 72.27 * 25.4,
    family = "",
    fontface = 1,
    hjust = 0.5,
    vjust = 0.5
  ),
  draw_key = draw_key_rect,
  draw_panel = function(data, panel_params, coord, pointer = "bottom", padding = 6, na.rm = FALSE) {
    data <- coord$transform(data, panel_params)
    blocks <- lapply(seq_len(nrow(data)), function(i) {
      row <- data[i, , drop = FALSE]
      grid::gTree(
        x = row$x,
        y = row$y,
        label = as.character(row$label),
        pointer = pointer,
        padding = padding,
        hjust = row$hjust,
        vjust = row$vjust,
        text_gp = grid::gpar(
          col = row$colour,
          fontsize = row$size * ggplot2::.pt,
          fontfamily = row$family,
          fontface = row$fontface,
          lineheight = 9.5 / 7.5
        ),
        box_gp = grid::gpar(col = NA, fill = ggplot2::fill_alpha(row$fill, row$alpha)),
        cl = "ggthemes_label_economist_2017"
      )
    })
    grid::gTree(children = do.call(grid::gList, blocks))
  }
)
# nolint end: object_name_linter

# The guide's text-block geometry, in points.
label_2017_spec <- list(
  line = 12, # box height for one line
  extra_line = 11, # added for each further line
  padding = 6, # either side of the text
  pointer_width = 5,
  pointer_depth = 3.75,
  corner = 6 # minimum distance from the pointer to a corner
)

# Where the pointer's centre sits along a side `length` long: at `just` of
# the way along, but at least `corner` from either end when the side is long
# enough, and never past the end.
label_2017_pointer_at <- function(length, just, corner) {
  half <- label_2017_spec$pointer_width / 2
  lo <- min(corner + half, length / 2)
  min(max(just * length, lo), length - lo)
}

# The box outline, pointer included, as (x, y) in points from the point the
# pointer touches; or, with no pointer, from the box's justification point.
label_2017_outline <- function(width, height, pointer, hjust, vjust) {
  s <- label_2017_spec
  half <- s$pointer_width / 2
  d <- s$pointer_depth
  switch(
    pointer,
    bottom = {
      p <- label_2017_pointer_at(width, hjust, s$corner)
      left <- -p
      list(
        x = c(0, -half, left, left, left + width, left + width, half),
        y = c(0, d, d, d + height, d + height, d, d),
        box = c(left, d, width, height)
      )
    },
    top = {
      p <- label_2017_pointer_at(width, hjust, s$corner)
      left <- -p
      list(
        x = c(0, half, left + width, left + width, left, left, -half),
        y = c(0, -d, -d, -d - height, -d - height, -d, -d),
        box = c(left, -d - height, width, height)
      )
    },
    left = {
      q <- label_2017_pointer_at(height, vjust, 0)
      bottom <- -q
      list(
        x = c(0, d, d, d + width, d + width, d, d),
        y = c(0, -half, bottom, bottom, bottom + height, bottom + height, half),
        box = c(d, bottom, width, height)
      )
    },
    right = {
      q <- label_2017_pointer_at(height, vjust, 0)
      bottom <- -q
      list(
        x = c(0, -d, -d, -d - width, -d - width, -d, -d),
        y = c(0, half, bottom + height, bottom + height, bottom, bottom, -half),
        box = c(-d - width, bottom, width, height)
      )
    },
    none = {
      left <- -hjust * width
      bottom <- -vjust * height
      list(
        x = c(left, left + width, left + width, left),
        y = c(bottom, bottom, bottom + height, bottom + height),
        box = c(left, bottom, width, height)
      )
    }
  )
}

# The text is measured when the block is drawn, so the box fits it on the
# device it is drawn on.
#' @exportS3Method grid::makeContent
makeContent.ggthemes_label_economist_2017 <- function(x) {
  s <- label_2017_spec
  lines <- strsplit(x$label, "\n", fixed = TRUE)[[1]]
  n <- max(length(lines), 1)
  text <- grid::textGrob(x$label, gp = x$text_gp)
  padding <- x$padding %||% s$padding
  width <- grid::convertWidth(grid::grobWidth(text), "pt", valueOnly = TRUE) + 2 * padding
  height <- s$line + s$extra_line * (n - 1)
  shape <- label_2017_outline(width, height, x$pointer, x$hjust, x$vjust)
  at <- function(npc, pt) grid::unit(npc, "npc") + grid::unit(pt, "pt")
  box <- grid::polygonGrob(at(x$x, shape$x), at(x$y, shape$y), gp = x$box_gp)
  label <- grid::textGrob(
    x$label,
    x = at(x$x, shape$box[1] + padding),
    y = at(x$y, shape$box[2] + shape$box[4] / 2),
    just = c("left", "centre"),
    gp = x$text_gp
  )
  grid::setChildren(x, grid::gList(box, label))
}
