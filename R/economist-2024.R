# Measurements from the chart corpus, in units of the axis-label size, which
# is `base_size` in theme_economist_2024(), as in theme_economist_2017().
#
# Web: the `ai2html` files of Graphic Detail charts set axis numbers at 15px,
# light, in a 700px artboard; titles 20/24px bold, subtitles 17/20px medium,
# the source 15/20px light in #666666. The tab is 40 by 4px, flush left.
#
# Print: delivery images are 608px wide, with axis numbers about 20px tall. The
# tab is 68 by 9px, inset 23px; panel headings open with a 68 by 2px black
# rule; the number box is a 26px square outlined in black.
economist_2024_tab <- list(print = c(3.4, 0.45), web = c(2.67, 0.27))

#' Economist color palette (2024 redesign)
#'
#' @description
#' The categorical palette of the charts *The Economist* has drawn since its
#' redesign of March 2024, reverse-engineered from published charts: there is
#' no public style guide for it. The order is red, salmon, blue, light blue,
#' dark gray and light gray. Print and web use different production values of
#' each color.
#'
#' A palette of one color is the brighter red of plain single-series charts,
#' not the first color of the full palette: the published charts keep the
#' deeper red for emphasis in charts with more than one series, and rarely use
#' both in one chart. Reversing the palette does not change this: one color
#' is that red in either direction.
#'
#' The palettes are provisional and will be updated when a better corpus of
#' examples is available.
#'
#' @param media Either `"print"` or `"web"`.
#' @param direction `1` (the default) for the published order, or `-1` to
#'   reverse it.
#'
#' @returns A palette function that takes the number of colors required.
#' @family economist 2024
#' @export
#' @example inst/examples/ex-economist_2024_pal.R
economist_2024_pal <- function(media = c("print", "web"), direction = 1) {
  media <- rlang::arg_match(media)
  economist_2024_check_direction(direction)
  spec <- ggthemes::ggthemes_data[["economist_2024"]][[media]]
  values <- spec[["qualitative"]][["value"]]
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    if (n == 1) {
      return(spec[["single"]])
    }
    colors <- values[seq_len(min(n, max_n))]
    if (direction < 0) {
      colors <- rev(colors)
    }
    colors
  }
  attr(f, "max_n") <- max_n
  f
}

#' Economist continuous color palettes (2024 redesign)
#'
#' Red and gray sequential ramps, and a gray-to-red diverging ramp, for
#' charts drawn in the style of *The Economist* since its 2024 redesign. These
#' are reconstructions rather than sampled house ramps: the web red ramp comes
#' from a single published map, and the print gray steps are warm grays
#' between the ground and the text color. Like [economist_2024_pal()], they
#' are provisional and will be updated when a better corpus of examples is
#' available.
#'
#' @param palette One of `"red"`, `"gray"` or `"red-gray"`.
#' @inheritParams economist_2024_pal
#'
#' @returns A continuous palette function that maps values in `[0, 1]` to
#'   colors.
#' @family economist 2024
#' @export
#' @example inst/examples/ex-economist_2024_gradient_pal.R
economist_2024_gradient_pal <- function(
  palette = c("red", "gray", "red-gray"),
  media = c("print", "web"),
  direction = 1
) {
  palette <- rlang::arg_match(palette)
  media <- rlang::arg_match(media)
  economist_2024_check_direction(direction)
  key <- switch(
    palette,
    red = "sequential_red",
    gray = "sequential_gray",
    `red-gray` = "diverging"
  )
  values <- ggthemes::ggthemes_data[["economist_2024"]][[media]][[key]][["value"]]
  if (direction < 0) {
    values <- rev(values)
  }
  scales::gradient_n_pal(colours = values)
}

#' @rdname economist_2024_gradient_pal
#' @export
economist_2024_seq_gradient_pal <- function(
  palette = c("red", "gray"),
  media = c("print", "web"),
  direction = 1
) {
  economist_2024_check_direction(direction)
  economist_2024_gradient_pal(rlang::arg_match(palette), media, direction)
}

#' @rdname economist_2024_gradient_pal
#' @export
economist_2024_div_gradient_pal <- function(media = c("print", "web"), direction = 1) {
  economist_2024_check_direction(direction)
  economist_2024_gradient_pal("red-gray", media, direction)
}

economist_2024_check_direction <- function(direction, call = rlang::caller_env()) {
  if (length(direction) != 1L || is.na(direction) || !direction %in% c(-1, 1)) {
    cli::cli_abort("{.arg direction} must be 1 or -1, not {.val {direction}}.", call = call)
  }
  invisible(direction)
}

#' Economist color scales (2024 redesign)
#'
#' Discrete scales use [economist_2024_pal()]. The `_gradient` scales use the
#' red or gray sequential ramp of [economist_2024_seq_gradient_pal()], and the
#' `_gradient2` scales the diverging ramp, centered on `midpoint`.
#'
#' @inheritParams economist_2024_pal
#' @param palette Either `"red"` or `"gray"`.
#' @param midpoint The data value at the neutral center of the diverging
#'   ramp.
#' @param na.value The color for missing values.
#' @param guide The guide for a continuous scale. The default,
#'   [guide_colourbar_economist_2024()], sizes the colorbar as the published
#'   charts do.
#' @param ... Passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()].
#'
#' @returns A ggplot2 scale.
#' @family economist 2024
#' @rdname scale_economist_2024
#' @export
#' @example inst/examples/ex-scale_economist_2024.R
scale_colour_economist_2024 <- function(media = c("print", "web"), direction = 1, ...) {
  discrete_scale("colour", palette = economist_2024_pal(media, direction), ...)
}

#' @rdname scale_economist_2024
#' @export
scale_color_economist_2024 <- scale_colour_economist_2024

#' @rdname scale_economist_2024
#' @export
scale_fill_economist_2024 <- function(media = c("print", "web"), direction = 1, ...) {
  discrete_scale("fill", palette = economist_2024_pal(media, direction), ...)
}

#' @rdname scale_economist_2024
#' @export
scale_colour_gradient_economist_2024 <- function(
  palette = c("red", "gray"),
  media = c("print", "web"),
  direction = 1,
  ...,
  na.value = "grey50",
  guide = guide_colourbar_economist_2024()
) {
  continuous_scale(
    "colour",
    palette = economist_2024_seq_gradient_pal(palette, media, direction),
    na.value = na.value,
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_2024
#' @export
scale_color_gradient_economist_2024 <- scale_colour_gradient_economist_2024

#' @rdname scale_economist_2024
#' @export
scale_fill_gradient_economist_2024 <- function(
  palette = c("red", "gray"),
  media = c("print", "web"),
  direction = 1,
  ...,
  na.value = "grey50",
  guide = guide_colourbar_economist_2024()
) {
  continuous_scale(
    "fill",
    palette = economist_2024_seq_gradient_pal(palette, media, direction),
    na.value = na.value,
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_2024
#' @export
scale_colour_gradient2_economist_2024 <- function(
  media = c("print", "web"),
  direction = 1,
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = guide_colourbar_economist_2024()
) {
  continuous_scale(
    "colour",
    palette = economist_2024_div_gradient_pal(media, direction),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(mid = midpoint),
    ...
  )
}

#' @rdname scale_economist_2024
#' @export
scale_color_gradient2_economist_2024 <- scale_colour_gradient2_economist_2024

#' @rdname scale_economist_2024
#' @export
scale_fill_gradient2_economist_2024 <- function(
  media = c("print", "web"),
  direction = 1,
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = guide_colourbar_economist_2024()
) {
  continuous_scale(
    "fill",
    palette = economist_2024_div_gradient_pal(media, direction),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(mid = midpoint),
    ...
  )
}

#' Economist colorbar (2024 redesign)
#'
#' A [ggplot2::guide_colourbar()] sized like the color keys of *The
#' Economist*'s 2024 charts: a long, thin bar with its labels above it and
#' black ticks across it. The one continuous key in the sample, on the web map
#' `20260801_WOM946`, is a bar 207px long and 10px tall, about 13.8 and 0.67
#' times its 15px labels. The guide reads the label size from the plot's theme
#' when it is drawn, so the bar scales with the `base_size` of
#' [theme_economist_2024()].
#'
#' A theme cannot set these sizes: ggplot2 makes a colorbar five legend keys
#' long, and the theme's keys are sized for discrete legends. The continuous
#' scales of [scale_colour_gradient_economist_2024()] use this guide by
#' default; pass it as `guide` to use it with any other continuous scale.
#'
#' @param ... Passed to [ggplot2::guide_colourbar()]. Anything set in its
#'   `theme` argument overrides the sizes above.
#'
#' @returns A guide.
#' @family economist 2024
#' @export
#' @examples
#' library("ggplot2")
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_viridis_c(guide = guide_colourbar_economist_2024()) +
#'   theme_economist_2024("web")
guide_colourbar_economist_2024 <- function(...) {
  guide <- ggplot2::guide_colourbar(...)
  ggproto(NULL, GuideColourbarEconomist2024, params = guide$params, available_aes = guide$available_aes)
}

#' @rdname guide_colourbar_economist_2024
#' @export
guide_colorbar_economist_2024 <- guide_colourbar_economist_2024

# Sizes in multiples of the label size, from 20260801_WOM946 (15px labels):
# the bar, the ticks across it and above it, and the gap to the labels.
economist_2024_colourbar <- list(long = 13.8, short = 0.67, tick_above = 0.27, gap = 0.4)

GuideColourbarEconomist2024 <- ggproto(
  "GuideColourbarEconomist2024",
  ggplot2::GuideColourbar,
  setup_elements = function(self, params, elements, theme) {
    own <- params$theme %||% list()
    size <- ggplot2::calc_element("legend.text", theme)$size
    bar <- economist_2024_colourbar
    # GuideColourbar makes the long side five keys long.
    long <- unit(bar$long * size / 5, "pt")
    short <- unit(bar$short * size, "pt")
    horizontal <- params$direction == "horizontal"
    set <- function(name, value) {
      if (is.null(own[[name]])) {
        theme[[name]] <<- value
      }
    }
    set("legend.key.width", if (horizontal) long else short)
    set("legend.key.height", if (horizontal) short else long)
    set("legend.text.position", if (horizontal) "top" else "right")
    # Black ticks across the whole bar and a little past it toward the
    # labels. The first length is for the bottom (or right) edge.
    set(
      "legend.ticks",
      element_line(
        colour = ggplot2::calc_element("text", theme)$colour,
        linewidth = ggplot2::calc_element("axis.ticks", theme)$linewidth
      )
    )
    ticks <- if (horizontal) c(bar$short, -bar$tick_above) else c(-bar$tick_above, bar$short)
    set("legend.ticks.length", unit(ticks * size, "pt"))
    if (is.null(own[["legend.text"]])) {
      text <- theme[["legend.text"]] %||% element_text()
      gap <- (bar$tick_above + bar$gap) * size
      text$margin <- if (horizontal) margin(b = gap) else margin(l = gap)
      theme[["legend.text"]] <- text
    }
    ggproto_parent(ggplot2::GuideColourbar, self)$setup_elements(params, elements, theme)
  }
)

#' Economist theme (2024 redesign)
#'
#' @description
#' A theme for charts in the style *The Economist* has used since its
#' redesign of March 2024: a warm gray ground for print and white for web,
#' black text, pale rules, a black baseline with outward ticks, and values on
#' the right. It keeps the layout of [theme_economist_2017()] and changes only
#' what the published charts show has changed: the grounds and inks, a larger
#' type hierarchy, a source line as large as the axis labels, and keys flush left
#' above the plot in both media.
#'
#' The type sizes come from the `ai2html` files of web charts: a 20px bold
#' title, a 17px subtitle and 15px axis labels and source. Print charts set
#' their subtitles bolder, so the print subtitle is bold. The axis labels and
#' source are light in the original, which a theme cannot ask for; pass a
#' light family as `base_family` to match them.
#'
#' The red tab, the rule over each panel heading and the number box sit
#' outside anything a theme can set: draw them with [economist_2024_chart()].
#'
#' @inheritParams economist_2024_pal
#' @param base_size The size of the axis labels, in points. Every other size
#'   is a multiple of it.
#' @param base_family The font family. The default is the first of Fira Sans
#'   Condensed and Roboto Condensed that is installed, standing in for the
#'   paper's own Economist Sans; see [economist_2017_font()].
#' @param horizontal Draw horizontal grid lines (the default), or vertical
#'   ones for a horizontal bar chart?
#'
#' @returns A complete [ggplot2::theme()].
#' @family economist 2024
#' @export
#' @example inst/examples/ex-theme_economist_2024.R
theme_economist_2024 <- function(
  media = c("print", "web"),
  base_size = 10,
  base_family = economist_2017_font(),
  horizontal = TRUE
) {
  media <- rlang::arg_match(media)
  spec <- ggthemes::ggthemes_data[["economist_2024"]][[media]]
  ground <- spec[["bg"]][["value"]][spec[["bg"]][["name"]] == "panel"]
  # Lengths in multiples of the axis-label size.
  u <- function(x) unit(x * base_size, "pt")
  m <- function(t = 0, r = 0, b = 0, l = 0) margin(t * base_size, r * base_size, b * base_size, l * base_size, "pt")
  # Rules: 1px pale grid lines and a heavier black baseline at 15px type.
  lw <- function(x) x * base_size / ggplot2::.pt
  plot_margin <- switch(media, print = m(0, 1.15, 0.9, 1.15), web = m(0, 0, 0.5, 0))

  ret <- theme_economist_2017(
    media = media,
    base_size = base_size,
    base_family = base_family,
    horizontal = horizontal
  ) +
    theme(
      line = element_line(colour = spec[["text"]], linewidth = lw(0.067)),
      rect = element_rect(fill = ground),
      text = element_text(colour = spec[["text"]]),
      axis.line = element_line(colour = spec[["text"]], linewidth = lw(0.1)),
      axis.ticks = element_line(colour = spec[["text"]], linewidth = lw(0.067)),
      axis.ticks.length = u(0.4),
      axis.ticks.length.y = unit(0, "pt"),
      axis.ticks.length.x.top = unit(0, "pt"),
      axis.text.x = element_text(vjust = 1, margin = m(t = 0.25)),
      axis.text.x.top = element_text(vjust = 0, margin = m(b = 0.25)),
      axis.text.y = element_text(hjust = 0, margin = m(r = 0.3)),
      axis.text.y.right = element_text(hjust = 1, margin = m(l = 0.3)),
      legend.text = element_text(size = rel(1), lineheight = 1.15, margin = m(l = 0.3)),
      legend.title = element_text(size = rel(1), lineheight = 1.15, hjust = 0, margin = m(b = 0.3)),
      legend.key.height = u(0.8),
      legend.key.width = u(0.8),
      legend.key.spacing = u(1),
      legend.key.spacing.y = u(0.2),
      legend.justification = "left",
      legend.box.spacing = u(0.8),
      panel.grid = element_line(colour = spec[["grid"]], linewidth = lw(0.067)),
      panel.spacing.x = u(1.6),
      panel.spacing.y = u(1.6),
      strip.text = element_text(
        size = rel(17 / 15),
        face = "bold",
        lineheight = 20 / 17,
        hjust = 0,
        margin = m(t = 0.6, b = 0.4)
      ),
      plot.background = element_rect(fill = ground, colour = NA),
      plot.title = element_text(
        size = rel(20 / 15),
        face = "bold",
        lineheight = 24 / 20,
        hjust = 0,
        vjust = 1,
        margin = m(t = 1.5, b = 0.25)
      ),
      plot.subtitle = element_text(
        size = rel(17 / 15),
        face = switch(media, print = "bold", web = "plain"),
        lineheight = 20 / 17,
        hjust = 0,
        vjust = 1,
        margin = m(b = 1)
      ),
      plot.caption = element_text(
        size = rel(1),
        lineheight = 20 / 15,
        colour = spec[["source"]],
        hjust = 0,
        vjust = 1,
        margin = m(t = 0.6)
      ),
      plot.tag = element_text(size = rel(20 / 15)),
      plot.margin = plot_margin
    )
  ret
}

#' Draw a chart in the 2024 Economist style
#'
#' @description
#' Adds the furniture of a chart drawn in the style *The Economist* has used
#' since its 2024 redesign, which no [ggplot2::theme()] can set:
#'
#' * the short red tab on the chart's top edge, at the left margin;
#' * a short black rule above each panel heading;
#' * the y-axis titles moved above the panels and set horizontally, as in
#'   [economist_2017_chart()];
#' * optionally, a footnote set right on the source line, and a number box
#'   at the top right, a square outlined in black.
#'
#' Sizes scale with the theme's `base_size`. Use it with
#' [theme_economist_2024()] in the same medium.
#'
#' @param plot A ggplot styled with [theme_economist_2024()].
#' @inheritParams economist_2017_chart
#' @param tab Width and height of the red tab, as multiples of `base_size`, or
#'   `NULL` (the default) for the sizes measured in published charts:
#'   `c(3.4, 0.45)` in print and `c(2.67, 0.27)` on the web, so 34 by 4.5pt and
#'   about 27 by 2.7pt at the default `base_size` of 10.
#'
#' @returns A grob. Print it to draw it, or pass it to [ggplot2::ggsave()].
#' @family economist 2024
#' @export
#' @example inst/examples/ex-economist_2024_chart.R
economist_2024_chart <- function(
  plot,
  media = c("print", "web"),
  footnote = NULL,
  number = NULL,
  tab = NULL
) {
  media <- rlang::arg_match(media)
  tab <- tab %||% economist_2024_tab[[media]]
  if (!is.numeric(tab) || length(tab) != 2 || anyNA(tab) || any(tab < 0)) {
    cli::cli_abort("{.arg tab} must be two non-negative numbers: a width and a height.")
  }
  # The layout code measures in the 2017 guide's points.
  new_economist_chart(plot, media, footnote, number, tab * economist_2017_base, era = "2024")
}

# The 2024 number box: a square outlined in the text colour, with the number
# in that colour (print charts, 2024-26), top-aligned with the title.
economist_2024_number_box <- function(number, theme, plot_margin, pt) {
  text <- ggplot2::calc_element("text", theme)
  title <- ggplot2::calc_element("plot.title", theme)
  side <- pt(1.3 * economist_2017_base)
  x <- grid::unit(1, "npc") - plot_margin[2]
  y <- grid::unit(1, "npc") - plot_margin[1] - title$margin[1]
  grid::gTree(
    children = grid::gList(
      grid::rectGrob(
        x = x,
        y = y,
        width = side,
        height = side,
        just = c("right", "top"),
        gp = grid::gpar(fill = NA, col = text$colour, lwd = 0.1 * text$size / 0.75)
      ),
      grid::textGrob(
        as.character(number),
        x = x - side * 0.5,
        y = y - side * 0.5,
        gp = grid::gpar(col = text$colour, fontsize = text$size * 1.1, fontfamily = text$family)
      )
    )
  )
}
