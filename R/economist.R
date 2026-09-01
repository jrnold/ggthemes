#' Economist color palette (discrete)
#'
#' The nine colors \emph{The Economist} uses for chart series: blue,
#' cyan, green, yellow, olive, purple, gold, gray, and red, in that
#' order. Red comes last because the house style reserves it for data
#' the chart is making a point about, rather than handing it out as an
#' ordinary series color.
#'
#' A tenth color, "Econ red", is the brighter masthead red used for the
#' tag rectangle and for single-series highlights. It is excluded from
#' this palette; take it from
#' \code{ggthemes_data$economist$main} when you need it.
#'
#' @param fill `r lifecycle::badge("deprecated")` No longer has any effect.
#' @family colour economist
#' @export
#' @importFrom lifecycle deprecated is_present
#' @example inst/examples/ex-economist_pal.R
economist_pal <- function(fill = deprecated()) {
  if (is_present(fill)) {
    deprecate_warn(
      "7.0.0",
      "economist_pal(fill)",
      details = c(
        i = paste0(
          "The Economist's current chart palette draws no distinction ",
          "between fill and colour, so `fill` no longer has any effect."
        )
      )
    )
  }
  colors <- economist_main_colors()
  max_n <- length(colors)
  f <- function(n) {
    check_pal_n(n, max_n)
    unname(colors[seq_len(n)])
  }
  attr(f, "max_n") <- max_n
  f
}

# The nine general-purpose series colours, in the order ggthemes hands
# them out. "Econ red" is excluded: the styleguide reserves it for the
# tag rectangle and for single-series highlights.
economist_main_colors <- function() {
  colors <- deframe(ggthemes::ggthemes_data[["economist"]][["main"]])
  colors[names(colors) != "econ red"]
}

#' Economist color scales
#'
#' Color scales using the colors in the Economist graphics.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams economist_pal
#' @family colour economist
#' @rdname scale_economist
#' @seealso \code{\link{theme_economist}()} for examples.
#' @export
scale_colour_economist <- function(...) {
  discrete_scale("colour", palette = economist_pal(), ...)
}

#' @rdname scale_economist
#' @export
scale_color_economist <- scale_colour_economist

#' @rdname scale_economist
#' @export
scale_fill_economist <- function(...) {
  discrete_scale("fill", palette = economist_pal(), ...)
}

#' Economist sequential color palettes
#'
#' The Economist's "equal lightness colour scales": six ordered steps for
#' each of the nine hues in the main chart palette, running darkest to
#' lightest. Use them for ordered data, where the main palette is for
#' unordered categories.
#'
#' \code{economist_seq_pal()} returns the six steps themselves, for
#' discrete ordered data. \code{economist_gradient_pal()} interpolates
#' between them, for continuous data.
#'
#' @param hue \code{character}. One of \code{"blue"}, \code{"cyan"},
#'   \code{"green"}, \code{"yellow"}, \code{"olive"}, \code{"purple"},
#'   \code{"gold"}, \code{"gray"}, or \code{"red"}.
#' @family colour economist
#' @rdname economist_seq_pal
#' @export
#' @example inst/examples/ex-economist_seq_pal.R
economist_seq_pal <- function(hue = "blue") {
  colors <- economist_scale_colors(hue)
  max_n <- length(colors)
  f <- function(n) {
    check_pal_n(n, max_n)
    colors[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' @rdname economist_seq_pal
#' @export
economist_gradient_pal <- function(hue = "blue") {
  scales::gradient_n_pal(colours = economist_scale_colors(hue))
}

economist_scale_colors <- function(hue) {
  scales <- ggthemes::ggthemes_data[["economist"]][["scales"]]
  if (!rlang::is_string(hue) || !hue %in% names(scales)) {
    cli::cli_abort(
      "{.arg hue} must be one of {.val {names(scales)}}, not {.val {hue}}."
    )
  }
  scales[[hue]][["value"]]
}

#' Economist sequential color scales
#'
#' Color scales built from The Economist's equal-lightness color scales.
#' The \code{_c} scales are continuous; the \code{_ordinal} scales are
#' discrete, for ordered factors. See \code{\link{scale_colour_economist}()}
#' for the unordered categorical scales.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams economist_seq_pal
#' @param guide Type of legend. Use \code{"colourbar"} for continuous
#'   color bars, or \code{"legend"} for discrete color legends.
#' @param ... Other arguments passed on to the underlying scale.
#' @family colour economist
#' @rdname scale_economist_seq
#' @export
scale_colour_economist_c <- function(hue = "blue", guide = "colourbar", ...) {
  continuous_scale(
    "colour",
    palette = economist_gradient_pal(hue),
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_seq
#' @export
scale_color_economist_c <- scale_colour_economist_c

#' @rdname scale_economist_seq
#' @export
scale_fill_economist_c <- function(hue = "blue", guide = "colourbar", ...) {
  continuous_scale(
    "fill",
    palette = economist_gradient_pal(hue),
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_seq
#' @export
scale_colour_economist_ordinal <- function(hue = "blue", ...) {
  discrete_scale("colour", palette = economist_seq_pal(hue), ...)
}

#' @rdname scale_economist_seq
#' @export
scale_color_economist_ordinal <- scale_colour_economist_ordinal

#' @rdname scale_economist_seq
#' @export
scale_fill_economist_ordinal <- function(hue = "blue", ...) {
  discrete_scale("fill", palette = economist_seq_pal(hue), ...)
}

#' ggplot color theme based on the Economist
#'
#' A theme that approximates the style of charts in \emph{The Economist}.
#'
#' This follows the chart design \emph{The Economist} introduced in 2017
#' and still publishes today: a white plot area on a pale ground, light
#' horizontal gridlines only, a black x-axis baseline with tick marks
#' below it, and no y-axis rule or ticks. Use
#' \code{\link{scale_colour_economist}()} with it.
#'
#' Two conventions of the house style cannot be expressed as theme
#' elements, and have to be set on the plot itself:
#'
#' \itemize{
#' \item \emph{The Economist} puts the y axis on the right. Use
#' \code{scale_y_continuous(position = "right")}.
#' \item Charts are tagged with a small red rectangle above the title.
#' Draw it with \code{\link[ggplot2]{annotate}()} or
#' \code{\link[grid]{grid.rect}()} in "Econ red", which is
#' \code{ggthemes_data$economist$main} row \code{"econ red"}.
#' }
#'
#' \emph{The Economist} sets charts in "Econ Sans", which is not publicly
#' available. Any narrow humanist sans is a reasonable substitute; with
#' the \pkg{extrafont} package, "Roboto Condensed" or "Fira Sans
#' Condensed" are close.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal \code{logical} Horizontal gridlines? If
#'   \code{FALSE}, vertical gridlines are drawn instead, for use with
#'   \code{\link[ggplot2]{coord_flip}()}.
#' @param dkpanel `r lifecycle::badge("deprecated")` The darker panel was
#'   a feature of the pre-2017 design and no longer has any effect.
#' @param gray_bg `r lifecycle::badge("deprecated")` No longer has any
#'   effect.
#'
#' @return An object of class \code{\link[ggplot2]{theme}()}.
#'
#' @export
#' @family themes economist
#'
#' @references
#' \itemize{
#' \item \href{https://www.economist.com/}{The Economist}
#' \item \emph{The Economist visual styleguide}, version 1.2, 4 May 2017.
#' }
#'
#' @example inst/examples/ex-theme_economist.R
theme_economist <- function(
  base_size = 10,
  base_family = "sans",
  horizontal = TRUE,
  dkpanel = deprecated()
) {
  if (is_present(dkpanel)) {
    deprecate_warn(
      "7.0.0",
      "theme_economist(dkpanel)",
      details = c(
        i = paste0(
          "The darker panel belonged to the pre-2017 design, which this ",
          "theme no longer implements."
        )
      )
    )
  }
  bg <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
  txt <- deframe(ggthemes::ggthemes_data[["economist"]][["text"]])
  # Type and spacing follow the styleguide's standard print chart
  # (p.6): 9.5pt bold headline over 8pt subtitle, 7.5pt labels, source
  # note at 6.5pt, and tick marks 2-5pt long below the baseline.
  half_line <- base_size / 2
  ret <- theme(
    line = element_line(colour = txt[["title"]]),
    rect = element_rect(fill = bg[["pale"]], colour = NA, linetype = 0),
    text = element_text(
      colour = txt[["body"]],
      family = base_family,
      size = base_size
    ),
    ## Axes. Only the x axis is ruled; the y axis is carried by the
    ## gridlines, with its labels on the right.
    axis.line = element_line(linewidth = rel(0.8), colour = txt[["title"]]),
    axis.line.y = element_blank(),
    axis.text = element_text(size = rel(0.95)),
    axis.text.x = element_text(margin = margin(t = half_line * 0.5)),
    axis.text.y = element_text(margin = margin(l = half_line * 0.5)),
    axis.ticks = element_line(linewidth = rel(0.5), colour = txt[["title"]]),
    axis.ticks.y = element_blank(),
    axis.ticks.length = unit(base_size * 0.4, "points"),
    axis.title = element_text(size = rel(0.95)),
    axis.title.x = element_text(margin = margin(t = half_line)),
    axis.title.y = element_text(angle = 90, margin = margin(r = half_line)),
    ## Legend. Keys sit under the subtitle, ranged left, with no frame.
    legend.background = element_rect(linetype = 0),
    # No box behind the key: a filled key reads as a white square
    # sitting on the pale ground.
    legend.key = element_rect(fill = NA, colour = NA, linetype = 0),
    legend.key.size = unit(1, "lines"),
    legend.key.height = unit(base_size, "points"),
    # Colour bars take their length from the key width; keep it wide
    # enough that the bar's own labels do not overprint.
    legend.key.width = unit(base_size * 2, "points"),
    legend.text = element_text(size = rel(0.95)),
    legend.title = element_text(size = rel(0.95), hjust = 0),
    legend.position = "top",
    legend.justification = "left",
    legend.margin = margin(b = half_line),
    ## Panel
    panel.background = element_rect(
      fill = bg[["white"]],
      colour = NA,
      linetype = 0
    ),
    panel.border = element_blank(),
    panel.grid.major = element_line(
      colour = bg[["gridline"]],
      linewidth = rel(0.5)
    ),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(base_size, "points"),
    ## Facets
    strip.background = element_rect(
      fill = bg[["pale"]],
      colour = NA,
      linetype = 0
    ),
    strip.text = element_text(
      size = rel(0.95),
      colour = txt[["title"]],
      face = "bold"
    ),
    strip.text.x = element_text(margin = margin(b = half_line * 0.5)),
    strip.text.y = element_text(angle = -90),
    ## Titles and source note, all ranged left against the whole plot.
    plot.background = element_rect(fill = bg[["pale"]], colour = NA),
    plot.title = element_text(
      size = rel(1.4),
      hjust = 0,
      face = "bold",
      colour = txt[["title"]],
      margin = margin(b = half_line * 0.5)
    ),
    plot.subtitle = element_text(
      size = rel(1),
      hjust = 0,
      margin = margin(b = half_line)
    ),
    plot.caption = element_text(
      size = rel(0.8),
      hjust = 0,
      margin = margin(t = half_line)
    ),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.margin = unit(c(6, 5, 6, 5) * 2, "points"),
    complete = TRUE
  )
  if (horizontal) {
    ret <- ret + theme(panel.grid.major.x = element_blank())
  } else {
    ret <- ret + theme(panel.grid.major.y = element_blank())
  }
  ret
}

#' @rdname theme_economist
#' @export
theme_economist_white <- function(
  base_size = 10,
  base_family = "sans",
  gray_bg = deprecated(),
  horizontal = TRUE
) {
  deprecate_warn(
    "7.0.0",
    "theme_economist_white()",
    "theme_economist()",
    details = c(
      i = paste0(
        "The current design already draws a white panel, so the white ",
        "variant no longer differs from `theme_economist()`."
      )
    )
  )
  theme_economist(
    base_size = base_size,
    base_family = base_family,
    horizontal = horizontal
  )
}
