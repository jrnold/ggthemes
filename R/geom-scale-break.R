#' Broken-scale symbol
#'
#' The mark *The Economist* puts on a y-axis that does not reach zero: a small
#' zigzag sitting between the x-axis baseline and the lowest y-axis tick,
#' announcing that the scale is truncated.
#'
#' The symbol is decoration, not a transformation. Truncate the axis in the
#' usual way -- `scale_y_continuous(limits = ...)` or
#' [ggplot2::coord_cartesian()] -- and add this layer to declare it. The
#' styleguide never excises a band from the middle of an axis, so there is
#' nothing here that rescales the data.
#'
#' @section Aesthetics:
#' None. The layer draws one symbol per panel and takes no data, so its
#' appearance is set through the `colour`, `stroke`, `width` and `height`
#' arguments rather than through mapped aesthetics.
#'
#' @details The styleguide (p.25) attaches two rules to this mark:
#'
#' * Use it when breaking the y-axis on **line, thermometer and scatter**
#'   charts. Never on a bar or column chart -- a truncated bar misstates the
#'   comparison the bar is making, and the guide's instruction there is to use
#'   a thermometer chart instead.
#' * It is **not needed** on indexed, negative or inverted scales, where no
#'   reader expects the axis to start at zero.
#'
#' @param side Which edge of the panel the symbol sits on. `"right"` matches
#'   the styleguide's usual placement, since it puts axis labels on the right;
#'   `"left"` is for a double-scale chart whose broken axis is the left one.
#' @param width,height Size of the symbol in points. The guide specifies a
#'   6pt width (p.25).
#' @param colour Color of the symbol. The guide draws it in black, not in the
#'   axis or text color.
#' @param stroke Stroke weight in points. The guide specifies 0.4pt.
#' @param ... Other arguments passed to [ggplot2::layer()].
#'
#' @return A [ggplot2::layer()].
#'
#' @references
#' \emph{The Economist visual styleguide}, v1.2, 4 May 2017 (internal;
#' Matt McLean), p.25.
#'
#' @family economist 2017
#' @importFrom ggplot2 layer
#' @export
#' @example inst/examples/ex-geom_scale_break.R
geom_scale_break <- function(
  side = c("right", "left"),
  width = 6,
  height = 4,
  colour = "black",
  stroke = 0.4,
  ...
) {
  side <- match.arg(side)
  layer(
    # The symbol is positioned from the panel's own breaks rather than from
    # data, so the layer supplies a single dummy row and maps nothing.
    data = data.frame(x = 0),
    mapping = NULL,
    stat = "identity",
    geom = GeomScaleBreak,
    position = "identity",
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      side = side,
      width = width,
      height = height,
      colour = colour,
      stroke = stroke,
      ...
    )
  )
}

#' @rdname geom_scale_break
#' @usage NULL
#' @format NULL
#' @export
#' @importFrom ggplot2 ggproto Geom zeroGrob draw_key_blank
#' @importFrom grid polylineGrob gpar unit
# nolint start: object_name_linter
GeomScaleBreak <- ggproto(
  "GeomScaleBreak",
  Geom,
  required_aes = character(),
  draw_key = draw_key_blank,
  draw_panel = function(
    data,
    panel_params,
    coord,
    side = "right",
    width = 6,
    height = 4,
    colour = "black",
    stroke = 0.4
  ) {
    # Break positions come back in npc, with out-of-range breaks as NA. The
    # lowest one that is actually inside the panel is the "first y-axis tick"
    # the guide measures against; the baseline is the panel bottom, at 0.
    breaks <- panel_params$y$break_positions()
    breaks <- breaks[is.finite(breaks) & breaks > 0 & breaks <= 1]
    if (!length(breaks)) {
      return(zeroGrob())
    }
    centre <- min(breaks) / 2

    # A flat run, one up-down zigzag, then a flat run, drawn symmetrically
    # about the panel edge.
    dx <- c(-0.5, -0.25, -0.05, 0.05, 0.25, 0.5) * width
    dy <- c(0, 0, 0.5, -0.5, 0, 0) * height

    # Inset by half the symbol's width so it sits against the panel edge but
    # wholly inside it. Centring it on the edge itself would clip half the
    # symbol away unless the user also set `coord_cartesian(clip = "off")`.
    anchor <- if (side == "right") {
      unit(1, "npc") - unit(width / 2, "pt")
    } else {
      unit(0, "npc") + unit(width / 2, "pt")
    }

    polylineGrob(
      x = anchor + unit(dx, "pt"),
      y = unit(centre, "npc") + unit(dy, "pt"),
      # grid draws lwd 1 as 1/96in = 0.75pt, so a stroke given in points
      # converts by dividing by 0.75.
      gp = gpar(col = colour, lwd = stroke / 0.75, lineend = "butt")
    )
  }
)
# nolint end: object_name_linter
