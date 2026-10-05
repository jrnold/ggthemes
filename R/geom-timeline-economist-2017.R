#' Economist timeline elements
#'
#' Layers for the timelines of *The Economist*'s 2017 styleguide, which add
#' events and periods to an ordinary chart of a year axis:
#'
#' * `geom_event_economist_2017()` marks a **specific date event**: a 0.5pt rule
#'   from the data (or the axis) to a label, with an arrowhead at the label's
#'   end. Draw it dashed, with `linetype = "dashed"`, to set labels apart from
#'   the bars of a bar chart.
#' * `geom_span_economist_2017()` marks a **time period** in the panel: a pale
#'   shaded span with a 1pt rule along its top and its label centred above.
#' * `geom_period_economist_2017()` draws the thin bars below the axis that mark
#'   out successive periods, such as terms of office, in alternating colors,
#'   each labelled in its own color.
#' * `geom_year_band_economist_2017()` draws the year band the guide uses as a
#'   timeline's x-axis: a cell for each year, every fifth one darker, with the
#'   years labelled inside it.
#'
#' Positions are in data units -- years along `x`, the chart's own values up
#' `y` -- so periods and the year band, which sit below the data, take values
#' below the lowest gridline. Rules, bars, the band's height and the type are
#' in points, and keep the guide's sizes whatever the size of the figure.
#'
#' @section Aesthetics:
#' `geom_event_economist_2017()`: **`x`**, **`y`** (where the rule starts),
#' **`yend`** (where it ends, at the label), **`label`**, `colour` (the
#' rule's), `linewidth`, `linetype`, `hjust` (0, the default, sets the label
#' to the right of the rule; 1 to its left; 0.5 centres it beyond the rule's
#' end), `vjust` (for a label beside the rule: 1, the default, hangs it from
#' the rule's end, its first line level with it; 0 stands it on the end, its
#' last line level with it), `text_colour`, `size`, `family`, `fontface`.
#'
#' `geom_span_economist_2017()`: **`xmin`**, **`xmax`**, `ymin`, `ymax` (default
#' the whole panel), `label`, `fill`, `colour` (the top rule's), `linewidth`,
#' `text_colour`, `size`, `family`, `fontface`.
#'
#' `geom_period_economist_2017()`: **`xmin`**, **`xmax`**, **`y`** (the top of the
#' bar), `label`, `fill` (by default, alternating through `fills`),
#' `colour` (the label's; by default the bar's color), `size`, `family`,
#' `fontface`.
#'
#' `geom_year_band_economist_2017()` takes no aesthetics.
#'
#' Text `size` is in mm, as for [ggplot2::geom_text()]; the default is the
#' guide's 6.5pt.
#'
#' @inheritParams ggplot2::geom_text
#' @param arrow Whether to draw an arrowhead at the label end of each rule.
#' @param gap Space between the end of a rule (or the top of a span or the
#'   bottom of a bar) and its label, in points.
#' @param fills For `geom_period_economist_2017()`, the colors the bars alternate
#'   through, in order of `xmin`, when `fill` is not mapped. The default is
#'   the guide's maroon and mauve.
#' @param height Height of the bars (`geom_period_economist_2017()`) or of the
#'   year band (`geom_year_band_economist_2017()`), in points.
#' @param from,to For `geom_year_band_economist_2017()`, the first and last years in the
#'   band. Each year's cell runs from the year to the next.
#' @param y For `geom_year_band_economist_2017()`, the data value at the top of the band.
#' @param label_every Label the years divisible by this, and the first year,
#'   in the guide's style (see [economist_2017_year()]).
#' @param colour For `geom_year_band_economist_2017()`, the color of the year labels.
#' @param size,family For `geom_year_band_economist_2017()`, the size (in mm, as for
#'   [ggplot2::geom_text()]) and font family of the year labels.
#'
#' @return A [ggplot2::layer()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean).
#'
#' @family economist 2017
#' @name geom_timeline_economist_2017
#' @example inst/examples/ex-geom_timeline_economist_2017.R
NULL

# Sizes the timeline layers share, in points.
timeline_pt <- function(x) grid::unit(x, "pt")
# ggplot2 draws `linewidth` as `linewidth * .pt` in grid's lwd, which is 1/96in.
timeline_linewidth <- function(pt) pt / 0.75 / ggplot2::.pt
timeline_text_size <- 6.5 / ggplot2::.pt

# nolint start: object_name_linter. ggplot2's own argument and class names.

#' @rdname geom_timeline_economist_2017
#' @export
geom_event_economist_2017 <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  arrow = TRUE,
  gap = 1.5,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomEventEconomist2017,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(arrow = arrow, gap = gap, na.rm = na.rm, ...)
  )
}

#' @rdname geom_timeline_economist_2017
#' @usage NULL
#' @format NULL
#' @export
GeomEventEconomist2017 <- ggproto(
  "GeomEventEconomist2017",
  Geom,
  required_aes = c("x", "y", "yend", "label"),
  default_aes = aes(
    colour = "#748D99",
    linewidth = timeline_linewidth(0.5),
    linetype = 1,
    hjust = 0,
    vjust = 1,
    size = timeline_text_size,
    family = "",
    fontface = 1,
    text_colour = "black"
  ),
  draw_key = ggplot2::draw_key_path,
  draw_panel = function(data, panel_params, coord, arrow = TRUE, gap = 1.5, na.rm = FALSE) {
    ends <- coord$transform(transform(data, y = yend), panel_params)
    data <- coord$transform(data, panel_params)
    grobs <- lapply(seq_len(nrow(data)), function(i) {
      row <- data[i, ]
      tip <- ends$y[i]
      up <- tip >= row$y
      rule <- grid::segmentsGrob(
        x0 = row$x, y0 = row$y, x1 = row$x, y1 = tip,
        arrow = if (arrow) grid::arrow(angle = 25, length = timeline_pt(2.5), type = "closed"),
        gp = grid::gpar(
          col = row$colour, fill = row$colour, lwd = row$linewidth * ggplot2::.pt,
          lty = row$linetype, lineend = "butt", linejoin = "mitre"
        )
      )
      fontsize <- row$size * ggplot2::.pt
      if (row$hjust == 0.5) {
        # Centred beyond the end of the rule.
        x <- grid::unit(row$x, "npc")
        y <- grid::unit(tip, "npc") + timeline_pt(if (up) gap else -gap)
        just <- c("centre", if (up) "bottom" else "top")
      } else {
        # Beside the rule, hanging from its end (first line level with it) or
        # standing on it (last line level with it).
        side <- if (row$hjust < 0.5) 1 else -1
        hang <- row$vjust >= 0.5
        x <- grid::unit(row$x, "npc") + timeline_pt(side * gap)
        y <- grid::unit(tip, "npc") + timeline_pt(if (hang) 0.55 * fontsize else -0.55 * fontsize)
        just <- c(if (side > 0) "left" else "right", if (hang) "top" else "bottom")
      }
      label <- grid::textGrob(
        row$label, x = x, y = y, just = just,
        gp = grid::gpar(
          col = row$text_colour, fontsize = fontsize, fontfamily = row$family,
          fontface = row$fontface, lineheight = 8 / 6.5
        )
      )
      grid::gList(rule, label)
    })
    grid::gTree(children = do.call(grid::gList, grobs))
  }
)

#' @rdname geom_timeline_economist_2017
#' @export
geom_span_economist_2017 <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  gap = 1.5,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomSpanEconomist2017,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(gap = gap, na.rm = na.rm, ...)
  )
}

#' @rdname geom_timeline_economist_2017
#' @usage NULL
#' @format NULL
#' @export
GeomSpanEconomist2017 <- ggproto(
  "GeomSpanEconomist2017",
  Geom,
  required_aes = c("xmin", "xmax"),
  optional_aes = "label",
  default_aes = aes(
    ymin = -Inf,
    ymax = Inf,
    fill = "#DBE8F0",
    colour = "#748D99",
    linewidth = timeline_linewidth(1),
    size = timeline_text_size,
    family = "",
    fontface = 1,
    text_colour = "black"
  ),
  draw_key = ggplot2::draw_key_rect,
  draw_panel = function(data, panel_params, coord, gap = 1.5, na.rm = FALSE) {
    data <- coord$transform(data, panel_params)
    clamp <- function(v) pmin(pmax(v, 0), 1)
    grobs <- lapply(seq_len(nrow(data)), function(i) {
      row <- data[i, ]
      bottom <- clamp(row$ymin)
      top <- clamp(row$ymax)
      shade <- grid::rectGrob(
        x = row$xmin, y = bottom, width = row$xmax - row$xmin, height = top - bottom,
        just = c("left", "bottom"), gp = grid::gpar(col = NA, fill = row$fill)
      )
      rule <- grid::segmentsGrob(
        row$xmin, top, row$xmax, top,
        gp = grid::gpar(col = row$colour, lwd = row$linewidth * ggplot2::.pt, lineend = "butt")
      )
      out <- grid::gList(shade, rule)
      if (!is.null(row$label) && !is.na(row$label)) {
        out <- grid::gList(out, grid::textGrob(
          row$label,
          x = (row$xmin + row$xmax) / 2,
          y = grid::unit(top, "npc") + timeline_pt(gap),
          just = c("centre", "bottom"),
          gp = grid::gpar(
            col = row$text_colour, fontsize = row$size * ggplot2::.pt, fontfamily = row$family,
            fontface = row$fontface, lineheight = 8 / 6.5
          )
        ))
      }
      out
    })
    grid::gTree(children = do.call(grid::gList, grobs))
  }
)

#' @rdname geom_timeline_economist_2017
#' @export
geom_period_economist_2017 <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  fills = c("#9A3F4F", "#B6939D"),
  height = 3,
  gap = 1,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPeriodEconomist2017,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(fills = fills, height = height, gap = gap, na.rm = na.rm, ...)
  )
}

#' @rdname geom_timeline_economist_2017
#' @usage NULL
#' @format NULL
#' @export
GeomPeriodEconomist2017 <- ggproto(
  "GeomPeriodEconomist2017",
  Geom,
  required_aes = c("xmin", "xmax", "y"),
  optional_aes = "label",
  default_aes = aes(
    fill = NA,
    colour = NA,
    size = timeline_text_size,
    family = "",
    fontface = 1
  ),
  draw_key = ggplot2::draw_key_rect,
  draw_panel = function(
    data,
    panel_params,
    coord,
    fills = c("#9A3F4F", "#B6939D"),
    height = 3,
    gap = 1,
    na.rm = FALSE
  ) {
    # Unmapped bars alternate through `fills` in time order.
    data <- data[order(data$xmin), , drop = FALSE]
    unset <- is.na(data$fill)
    data$fill[unset] <- rep_len(fills, nrow(data))[unset]
    data$colour[is.na(data$colour)] <- data$fill[is.na(data$colour)]
    data <- coord$transform(data, panel_params)
    grobs <- lapply(seq_len(nrow(data)), function(i) {
      row <- data[i, ]
      bar <- grid::rectGrob(
        x = row$xmin, y = row$y, width = row$xmax - row$xmin, height = timeline_pt(height),
        just = c("left", "top"), gp = grid::gpar(col = NA, fill = row$fill)
      )
      if (is.null(row$label) || is.na(row$label)) {
        return(bar)
      }
      grid::gList(bar, grid::textGrob(
        row$label,
        x = grid::unit(row$xmin, "npc") + timeline_pt(0.5),
        y = grid::unit(row$y, "npc") - timeline_pt(height + gap),
        just = c("left", "top"),
        gp = grid::gpar(
          col = row$colour, fontsize = row$size * ggplot2::.pt, fontfamily = row$family,
          fontface = row$fontface, lineheight = 8 / 6.5
        )
      ))
    })
    grid::gTree(children = do.call(grid::gList, grobs))
  }
)

#' @rdname geom_timeline_economist_2017
#' @export
geom_year_band_economist_2017 <- function(
  from,
  to,
  y = 0,
  height = 11.3,
  label_every = 5,
  fills = c("#B8D2E0", "#A1C3D5"),
  colour = "black",
  size = timeline_text_size,
  family = "",
  ...
) {
  stopifnot(is.numeric(from), is.numeric(to), from <= to)
  layer(
    # The band is drawn from its parameters, not from data.
    data = data.frame(x = from),
    mapping = NULL,
    stat = "identity",
    geom = GeomYearBandEconomist2017,
    position = "identity",
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      from = from, to = to, y = y, height = height, label_every = label_every,
      fills = fills, colour = colour, size = size, family = family, ...
    )
  )
}

#' @rdname geom_timeline_economist_2017
#' @usage NULL
#' @format NULL
#' @export
GeomYearBandEconomist2017 <- ggproto(
  "GeomYearBandEconomist2017",
  Geom,
  required_aes = character(),
  draw_key = ggplot2::draw_key_blank,
  draw_panel = function(
    data,
    panel_params,
    coord,
    from,
    to,
    y = 0,
    height = 11.3,
    label_every = 5,
    fills = c("#B8D2E0", "#A1C3D5"),
    colour = "black",
    size = timeline_text_size,
    family = ""
  ) {
    years <- seq(from, to)
    edges <- coord$transform(data.frame(x = c(years, to + 1), y = y), panel_params)
    left <- edges$x[seq_along(years)]
    right <- edges$x[-1]
    top <- edges$y[1]
    cells <- grid::rectGrob(
      x = left, y = top, width = right - left, height = timeline_pt(height),
      just = c("left", "top"),
      gp = grid::gpar(col = NA, fill = ifelse(years %% 5 == 0, fills[2], fills[1]))
    )
    # A thin rule between each pair of years, in the chart's background color.
    dividers <- grid::segmentsGrob(
      x0 = right[-length(right)], y0 = grid::unit(top, "npc"),
      x1 = right[-length(right)], y1 = grid::unit(top, "npc") - timeline_pt(height),
      gp = grid::gpar(col = "white", lwd = 0.5 / 0.75, alpha = 0.6)
    )
    labelled <- years %% label_every == 0 | years == from
    text <- grid::textGrob(
      economist_2017_year(years[labelled]),
      x = grid::unit(left[labelled], "npc") + timeline_pt(1),
      y = grid::unit(top, "npc") - timeline_pt(height / 2),
      just = c("left", "centre"),
      gp = grid::gpar(col = colour, fontsize = size * ggplot2::.pt, fontfamily = family)
    )
    grid::gTree(children = grid::gList(cells, dividers, text))
  }
)

# nolint end
