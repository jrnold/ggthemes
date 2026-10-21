#' Wall Street Journal theme
#'
#' An editorial theme based on the Wall Street Journal's web graphics of
#' 2011--2014: a paper field, black type (dark gray but for the title on the
#' gray field of 2013--2014), a heavy serif title over a plain
#' subtitle, dotted horizontal reference rules, and a short tick under each x
#' label. The article "The Wall Street Journal chart style, 2010--2014" on the
#' package website documents the conventions and the charts they come from.
#'
#' Some of the style belongs to the plot, not the theme: draw the solid zero
#' line with `geom_hline(yintercept = 0)`, put the unit on the topmost y label
#' with [wsj_label()], abbreviate years with [wsj_year_label()], and use
#' [wsj_bands()] for the alternating bands of 2011--2012, [wsj_callout()]
#' for number callouts, and [geom_wsj_threshold()] with [wsj_direction_bar()]
#' for indexes drawn above and below a threshold. Label series directly
#' where there is room; a legend is a fallback. Axis titles are not drawn: the
#' charts state the unit in the subtitle instead.
#'
#' The charts set titles in a heavy Ionic slab serif and everything else in a
#' narrow sans. Free faces close to them are Bitter, in its heaviest weight, for
#' `title_family`, and Source Sans 3 for `base_family`; see the article for how
#' to fetch and register them with the systemfonts package.
#'
#' @inheritParams ggplot2::theme_grey
#' @param paper Plot field. `"ivory"` (`#f8f2e4`), the field from October 2011
#'   to July 2013, or `"gray"` (`#efefef`), the field from August 2013. The
#'   gray field also sets the subtitle, axis labels, legend and caption in the
#'   dark gray (`#444444`) of the charts from mid-2013; the title stays black.
#'   The pre-8.0.0 values `"brown"`, `"green"` and `"blue"` are accepted with a
#'   deprecation warning; `"brown"` is the former name of `"ivory"`.
#' @param title_family Font family for the plot title.
#' @param color `r lifecycle::badge("deprecated")` Use `paper` instead.
#' @family themes wsj
#' @returns A ggplot2 theme object (class `theme`).
#' @example inst/examples/ex-theme_wsj.R
#' @export
#' @importFrom ggplot2 element_blank element_line element_rect element_text rel
#' @importFrom lifecycle deprecated is_present deprecate_warn
theme_wsj <- function(
  base_size = 12,
  paper = c("ivory", "gray"),
  base_family = "sans",
  title_family = "serif",
  color = deprecated()
) {
  via_color <- is_present(color)
  if (via_color) {
    deprecate_warn("8.0.0", "theme_wsj(color)", "theme_wsj(paper)")
    paper <- color
  }
  # `color` has already warned; don't warn twice for a single call.
  paper_colour <- wsj_paper_colour(paper, warn = !via_color)
  # Black type until mid-2013; then dark gray everywhere but the title, which
  # arrived with the gray field.
  inks <- ggthemes::ggthemes_data$wsj$ink
  ink <- if (identical(paper_colour, ggthemes::ggthemes_data$wsj$paper[["gray"]])) inks[["gray"]] else inks[["ivory"]]

  theme_foundation(base_size = base_size, base_family = base_family) +
    theme(
      line = element_line(colour = "#000000", linewidth = 0.35),
      rect = element_rect(fill = paper_colour, colour = NA),
      text = element_text(colour = ink),
      plot.background = element_rect(fill = paper_colour, colour = NA),
      panel.background = element_rect(fill = paper_colour, colour = NA),
      plot.title = element_text(
        colour = "#000000",
        family = title_family,
        face = "bold",
        size = rel(1.4),
        hjust = 0,
        margin = margin(b = base_size / 3)
      ),
      # Regular weight from July 2012; bold before.
      plot.subtitle = element_text(
        size = rel(0.95),
        hjust = 0,
        margin = margin(b = base_size / 2)
      ),
      plot.caption = element_text(
        size = rel(0.7),
        hjust = 0,
        margin = margin(t = base_size / 2)
      ),
      # The charts carry no axis titles: the unit goes in the subtitle and on
      # the topmost y label.
      axis.title = element_blank(),
      # theme_foundation() grays the axis labels; the charts do not. Right
      # aligned, as published: wsj_label() hangs the unit past the column.
      axis.text = element_text(colour = ink, size = rel(0.8)),
      # Published WSJ charts carry a short tick per x label and none on y, where
      # the dotted reference lines already locate the value.
      axis.ticks.x = element_line(colour = "#000000", linewidth = 0.35),
      axis.ticks.y = element_blank(),
      axis.ticks.length = unit(base_size / 4, "pt"),
      # No axis rule on either side. The heavy horizontal line in WSJ charts is
      # the zero baseline drawn inside the panel, which is a `geom_hline()`
      # belonging to the plot, not an axis line belonging to the theme.
      axis.line = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(
        colour = "#8a8a8a",
        linewidth = 0.25,
        linetype = "dotted"
      ),
      panel.grid.minor = element_blank(),
      legend.position = "top",
      legend.direction = "horizontal",
      legend.background = element_rect(fill = paper_colour, colour = NA),
      legend.key = element_rect(fill = paper_colour, colour = NA),
      legend.title = element_text(face = "bold", size = rel(0.8)),
      legend.text = element_text(size = rel(0.8)),
      strip.background = element_rect(fill = paper_colour, colour = NA),
      # Panel headings sit flush left over their panel, as in multi-panel WSJ
      # charts, and the panels are set well apart: each carries its own y labels.
      strip.text = element_text(
        colour = ink,
        face = "bold",
        size = rel(0.85),
        hjust = 0,
        margin = margin(b = base_size / 3)
      ),
      panel.spacing = unit(2, "lines"),
      plot.margin = margin(base_size, base_size, base_size, base_size)
    )
}

# Resolves a plot field to a hex color. `paper` holds the current three
# fields; `bg` holds the pre-8.0.0 set, whose names reached here either through
# the deprecated `color` argument or positionally as `theme_wsj(12, "brown")`.
wsj_paper_colour <- function(paper, warn = TRUE, user_env = rlang::caller_env(2), call = rlang::caller_env()) {
  papers <- ggthemes::ggthemes_data$wsj$paper
  bg <- ggthemes::ggthemes_data$wsj$bg

  if (length(paper) > 1L) {
    paper <- paper[[1L]]
  }
  if (length(paper) != 1L || !is.character(paper)) {
    cli::cli_abort("{.arg paper} must be a single string.", call = call)
  }

  if (paper %in% names(papers)) {
    return(papers[[paper]])
  }
  if (paper %in% names(bg)) {
    if (warn) {
      replacement <- if (paper == "brown") "\"ivory\"" else NULL
      deprecate_warn(
        when = "8.0.0",
        what = I(sprintf(
          "The %s plot field of `theme_wsj()`",
          encodeString(paper, quote = "\"")
        )),
        with = if (!is.null(replacement)) I(replacement),
        details = if (is.null(replacement)) {
          "The current fields are \"ivory\" and \"gray\"."
        },
        user_env = user_env
      )
    }
    return(bg[[paper]])
  }

  cli::cli_abort(
    "{.arg paper} must be one of {.val {names(papers)}}, not {.val {paper}}.",
    call = call
  )
}

#' Wall Street Journal color palettes (discrete)
#'
#' Palettes measured on the Wall Street Journal's web graphics of 2010--2014,
#' named for the jobs they do in a chart.
#'
#' * `"categorical"` (the default): red, steel blue, green, black, gold and
#'   orange. Red is the usual color of a single series and the first of two;
#'   steel blue is the second. Black and gold follow, the order of the
#'   charts with three or more lines.
#' * `"direction"`: green for gains and red for losses.
#' * `"comparison"`: a highlighted bar and the rest. WSJ highlights with a
#'   darker shade of the same hue and a bold label, not by graying out the
#'   others. Use `"greens"`, `"reds"` or `"golds"` to highlight in another hue.
#' * `"actual_forecast"`: a steel-blue actual value and a pale forecast.
#' * `"blues"`, `"greens"`, `"reds"`, `"golds"` and `"oranges"`: three shades
#'   of one hue, darkest first, for stacks and highlights. The lightest orange
#'   is not measured: it is a 55% tint of the mid orange, the tint that makes
#'   the light step of every other family.
#' * `"party"`: Democratic blue, Republican red and gray. It is not from the
#'   corpus, which has no U.S. election charts.
#'
#' `"categorical_light"` holds the pale tint the charts pair with each
#' `"categorical"` color. It sits at roughly 1.2--2.2 contrast against the
#' ivory field, so it is a fill for forecasts, stack segments and context bars,
#' not a color for thin lines or text. `"categorical_dark"` is not measured: it
#' darkens each color in CIE Lab to 6:1 contrast against the ivory field, for
#' lines and small marks that must stand out.
#'
#' @section Deprecated palettes:
#'
#' `r lifecycle::badge("deprecated")`
#'
#' The pre-8.0.0 palettes `"rgby"`, `"red_green"`, `"black_green"`,
#' `"dem_rep"` and `"colors6"` still resolve, with a deprecation warning, to
#' the colors they always returned, so existing plots are unchanged. Only
#' `"dem_rep"` has an exact replacement: `"party"` holds the same three
#' colors. The others have no like-for-like successor -- `"direction"` and
#' `"categorical"` serve the same roles as `"red_green"` and `"colors6"` but
#' with different colors -- so switching to them will change a plot.
#'
#' @param palette A string, the palette to use. One of
#'   `r ggthemes:::md_optlist(ggthemes:::wsj_current_palettes())`.
#' @family color wsj
#' @returns A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-wsj_pal.R
#' @importFrom lifecycle deprecate_warn
wsj_pal <- function(palette = "categorical") {
  palettes <- ggthemes::ggthemes_data$wsj$palettes
  if (!rlang::is_string(palette) || !palette %in% names(palettes)) {
    cli::cli_abort(
      "{.arg palette} must be one of {.val {wsj_current_palettes()}}, not {.val {palette}}."
    )
  }
  warn_deprecated_wsj_palette(palette)

  colors <- palettes[[palette]]$value
  f <- manual_pal_checked(unname(colors))
  attr(f, "max_n") <- length(colors)
  f
}

# Palettes carried over from before the 8.0.0 redesign, mapped to a current
# replacement only where the colors are identical.
wsj_deprecated_palettes <- c(
  rgby = NA,
  red_green = NA,
  black_green = NA,
  dem_rep = "party",
  colors6 = NA
)

wsj_current_palettes <- function() {
  setdiff(
    names(ggthemes::ggthemes_data$wsj$palettes),
    names(wsj_deprecated_palettes)
  )
}

warn_deprecated_wsj_palette <- function(palette) {
  if (!palette %in% names(wsj_deprecated_palettes)) {
    return(invisible())
  }
  with <- wsj_deprecated_palettes[[palette]]
  deprecate_warn(
    when = "8.0.0",
    what = I(sprintf("The %s palette of `wsj_pal()`", encodeString(palette, quote = "\""))),
    with = if (!is.na(with)) I(sprintf("the %s palette", encodeString(with, quote = "\""))),
    details = if (is.na(with)) {
      c(
        "This palette has no like-for-like replacement.",
        i = paste0(
          "The current palettes are ",
          paste(encodeString(wsj_current_palettes(), quote = "\""), collapse = ", "),
          "."
        ),
        i = "They use different colors, so switching will change the plot."
      )
    },
    user_env = rlang::caller_env(2)
  )
  invisible()
}

#' Wall Street Journal color and fill scales
#'
#' Discrete color and fill scales using [wsj_pal()]. These scales should be
#' used with [theme_wsj()].
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams wsj_pal
#' @family color wsj
#' @rdname scale_wsj
#' @returns A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_wsj.R
scale_colour_wsj <- function(palette = "categorical", ...) {
  discrete_scale("colour", palette = wsj_pal(palette), ...)
}

#' @rdname scale_wsj
#' @export
scale_color_wsj <- scale_colour_wsj

#' @rdname scale_wsj
#' @export
scale_fill_wsj <- function(palette = "categorical", ...) {
  discrete_scale("fill", palette = wsj_pal(palette), ...)
}

wsj_gradient_pal <- function(palette, type) {
  palettes <- ggthemes::ggthemes_data$wsj[[type]]
  if (!rlang::is_string(palette) || !palette %in% names(palettes)) {
    cli::cli_abort("{.arg palette} must be one of {.val {names(palettes)}}, not {.val {palette}}.")
  }
  scales::gradient_n_pal(palettes[[palette]]$value)
}

#' Wall Street Journal sequential color scales
#'
#' Continuous color scales using a WSJ sequential palette: `"steel"`, the
#' default, runs from the pale blue field through the steel blue to the navy,
#' every step a color measured on the 2010--2014 charts; `"blue"` is the
#' brighter ramp of the WSJ's later open-source maps (2015 and after).
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @param palette Sequential palette name: `"steel"` or `"blue"`.
#' @param guide Guide type, normally `"colourbar"`.
#' @family color wsj
#' @rdname scale_colour_gradient_wsj
#' @export
#' @importFrom ggplot2 continuous_scale
scale_colour_gradient_wsj <- function(
  palette = "steel",
  ...,
  na.value = "grey50",
  guide = "colourbar"
) {
  continuous_scale(
    "colour",
    palette = wsj_gradient_pal(palette, "sequential"),
    na.value = na.value,
    guide = guide,
    ...
  )
}

#' @rdname scale_colour_gradient_wsj
#' @export
scale_color_gradient_wsj <- scale_colour_gradient_wsj

#' @rdname scale_colour_gradient_wsj
#' @export
scale_colour_continuous_wsj <- scale_colour_gradient_wsj

#' @rdname scale_colour_gradient_wsj
#' @export
scale_color_continuous_wsj <- scale_colour_gradient_wsj

#' @rdname scale_colour_gradient_wsj
#' @export
scale_fill_gradient_wsj <- function(
  palette = "steel",
  ...,
  na.value = "grey50",
  guide = "colourbar"
) {
  continuous_scale(
    "fill",
    palette = wsj_gradient_pal(palette, "sequential"),
    na.value = na.value,
    guide = guide,
    ...
  )
}

#' @rdname scale_colour_gradient_wsj
#' @export
scale_fill_continuous_wsj <- scale_fill_gradient_wsj

#' Wall Street Journal diverging color scales
#'
#' Continuous color scales using a WSJ diverging palette: `"blue_orange"`,
#' or `"green_red"`, which follows the green-up, red-down convention of the
#' charts. Both pass through the ivory field at the midpoint.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @param palette Diverging palette name: `"blue_orange"` or `"green_red"`.
#' @param midpoint Data value mapped to the neutral midpoint.
#' @param guide Guide type, normally `"colourbar"`.
#' @family color wsj
#' @rdname scale_colour_gradient2_wsj
#' @export
scale_colour_gradient2_wsj <- function(
  palette = "blue_orange",
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = "colourbar"
) {
  continuous_scale(
    "colour",
    palette = wsj_gradient_pal(palette, "diverging"),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(midpoint),
    ...
  )
}

#' @rdname scale_colour_gradient2_wsj
#' @export
scale_color_gradient2_wsj <- scale_colour_gradient2_wsj

#' @rdname scale_colour_gradient2_wsj
#' @export
scale_fill_gradient2_wsj <- function(
  palette = "blue_orange",
  ...,
  midpoint = 0,
  na.value = "grey50",
  guide = "colourbar"
) {
  continuous_scale(
    "fill",
    palette = wsj_gradient_pal(palette, "diverging"),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(midpoint),
    ...
  )
}

#' Wall Street Journal axis labels
#'
#' Labels a continuous axis the way published Wall Street Journal charts do:
#' the unit symbol is printed once, on the topmost break, and every other break
#' is left bare. A y axis then reads `$120`, `110`, `100` rather than repeating
#' the symbol on every tick.
#'
#' The symbol is applied to the largest break, not the last element of
#' `breaks`, so the result is correct for a reversed scale.
#'
#' The charts right-align the y labels on their numbers and let the unit hang
#' outside the column: `8%` over `6` puts the `8` above the `6` and the `%`
#' out toward the plot, and `$120` over `100` hangs the `$` to the left.
#' [theme_wsj()] right-aligns the labels, which hangs a prefix by itself; with
#' `hang = TRUE` every other label carries an invisible copy of the suffix, so
#' the suffix hangs too.
#'
#' @param prefix Symbol placed before the topmost label, such as `"$"`.
#' @param suffix Symbol placed after the topmost label, such as `"%"`.
#' @param drop_lowest Blank the lowest break. Some WSJ charts omit it where the
#'   axis meets the panel edge; most print it, so this defaults to `FALSE`.
#' @param hang Hang the suffix past the right edge of the other labels. The
#'   labels are then returned as plotmath expressions, so use `hang = FALSE`
#'   for text that is not an axis label, or on an x axis.
#' @param ... Passed to [scales::label_comma()], for example `accuracy`.
#' @return A function suitable for a scale's `labels` argument. It returns a
#'   character vector, or an expression vector when `hang` is `TRUE` and there
#'   is a `suffix`.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' p <- ggplot(economics, aes(date, psavert)) +
#'   geom_line() +
#'   theme_wsj()
#' p + scale_y_continuous(labels = wsj_label(suffix = "%"))
#' @export
wsj_label <- function(prefix = "", suffix = "", drop_lowest = FALSE, hang = TRUE, ...) {
  force(prefix)
  force(suffix)
  force(drop_lowest)
  force(hang)
  format_break <- scales::label_comma(...)

  function(breaks) {
    labels <- format_break(breaks)
    usable <- which(is.finite(breaks))
    if (!length(usable)) {
      return(labels)
    }
    top <- usable[which.max(breaks[usable])]
    labels[top] <- paste0(prefix, labels[top], suffix)
    if (drop_lowest) {
      bottom <- usable[which.min(breaks[usable])]
      if (!identical(bottom, top)) {
        labels[bottom] <- ""
      }
    }
    if (!hang || !nzchar(suffix)) {
      return(labels)
    }
    # phantom() takes the suffix's width without drawing it.
    as.expression(lapply(seq_along(labels), function(i) {
      if (is.na(labels[i]) || i == top) labels[i] else bquote(.(labels[i]) * phantom(.(suffix)))
    }))
  }
}

#' Wall Street Journal year labels
#'
#' Labels a time axis the way Wall Street Journal charts do: the first year in
#' full and the rest abbreviated with an apostrophe, so an axis reads `2011`,
#' `'12`, `'13`.
#'
#' WSJ charts usually set each label just right of a tick that marks the start
#' of the year, rather than centered under it. Get that with
#' `theme(axis.text.x = element_text(hjust = 0))`.
#'
#' @return A function suitable for a scale's `labels` argument. It accepts
#'   `Date` and `POSIXt` breaks, or years as numbers.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' ggplot(economics, aes(date, unemploy / 1000)) +
#'   geom_line(color = wsj_pal()(1)) +
#'   scale_x_date(
#'     breaks = as.Date(paste0(seq(1970, 2010, by = 10), "-01-01")),
#'     labels = wsj_year_label()
#'   ) +
#'   theme_wsj() +
#'   theme(axis.text.x = element_text(hjust = 0))
#' @export
wsj_year_label <- function() {
  function(x) {
    year <- if (inherits(x, c("Date", "POSIXt"))) {
      as.integer(format(x, "%Y"))
    } else {
      as.integer(round(x))
    }
    labels <- ifelse(is.na(year), NA_character_, sprintf("'%02d", year %% 100L))
    if (any(!is.na(year))) {
      first <- which.min(year)
      labels[first] <- as.character(year[first])
    }
    labels
  }
}

#' Wall Street Journal alternating bands
#'
#' Shades every other interval between the y-axis breaks, starting from the
#' lowest, as Wall Street Journal charts of 2011 and 2012 did in place of
#' dotted reference rules. Add it before the data layers so it draws behind
#' them, and drop the rules with `theme(panel.grid.major.y = element_blank())`.
#'
#' The bands follow the breaks of the y scale, so set the breaks on the scale
#' rather than on the layer. Only Cartesian coordinates are supported.
#'
#' The charts shade a recession or another period behind the data in the same
#' tint. Draw such a band with `annotate("rect", ...)` and
#' `fill = ggthemes_data$wsj$bands[["ivory"]]`, or `[["gray"]]` on the gray field.
#'
#' @param paper The field the bands sit on, which sets the band color:
#'   `"ivory"` (`#efe4c9`) or `"gray"` (`#dddddd`), both measured on published
#'   charts.
#' @param fill Band color. Overrides `paper`.
#' @return A ggplot2 layer.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' ggplot(economics, aes(date, psavert)) +
#'   wsj_bands() +
#'   geom_line(color = wsj_pal()(1)) +
#'   scale_y_continuous(labels = wsj_label(suffix = "%")) +
#'   theme_wsj() +
#'   theme(panel.grid.major.y = element_blank())
#' @export
wsj_bands <- function(paper = c("ivory", "gray"), fill = NULL) {
  if (is.null(fill)) {
    paper <- rlang::arg_match(paper)
    fill <- ggthemes::ggthemes_data$wsj$bands[[paper]]
  }
  ggplot2::layer(
    data = data.frame(x = NA),
    mapping = NULL,
    stat = ggplot2::StatIdentity,
    geom = GeomWsjBands,
    position = ggplot2::PositionIdentity,
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(fill = fill)
  )
}

GeomWsjBands <- ggplot2::ggproto(
  "GeomWsjBands",
  ggplot2::Geom,
  draw_panel = function(data, panel_params, coord, fill = "#efe4c9") {
    y <- wsj_break_positions(panel_params)
    y <- sort(y[is.finite(y)])
    if (length(y) < 2L) {
      return(grid::nullGrob())
    }
    lower <- y[seq(1L, length(y) - 1L, by = 2L)]
    upper <- y[seq(2L, length(y), by = 2L)]
    grid::rectGrob(
      x = 0,
      width = 1,
      y = lower,
      height = upper - lower,
      just = c("left", "bottom"),
      gp = grid::gpar(fill = fill, col = NA)
    )
  }
)

# Positions of the major y breaks in [0, 1] panel units.
wsj_break_positions <- function(panel_params) {
  if (is.function(panel_params$y$break_positions)) {
    panel_params$y$break_positions()
  } else {
    panel_params$y.major
  }
}

#' Wall Street Journal number callouts
#'
#' Marks a value the way Wall Street Journal charts do: the value, often with
#' its date, in bold type inside a filled box or circle, with a triangular tail
#' pointing at the data point. Of 84 charts with callouts in 2011--2014, 83
#' marked the latest value and 83 had a tail; 48 were black with white type and
#' 29 yellow with black type. They are rare after mid-2013.
#'
#' The callout sits `nudge_x` and `nudge_y` points from the data point, so the
#' tail keeps its length whatever the scales. A callout near the edge of the
#' panel is clipped unless the coordinate system is set with
#' `coord_cartesian(clip = "off")`.
#'
#' @param x,y Position of the data point the tail points at, in data units.
#' @param label Text of the callout. Use `"\n"` for a second line, as in
#'   `"2Q:\n0.7%"`.
#' @param fill Fill of the callout: `"black"`, `"yellow"` (`#ffe03d`, measured
#'   on published charts) or any color. The few callouts in neither take the
#'   color of the series they mark or another shade of the palette, such as
#'   the mid steel blue `wsj_pal("blues")(3)[2]`.
#' @param colour Color of the text. By default white on a dark fill and black
#'   on a light one.
#' @param shape `"rectangle"`, `"rounded"` (a box with slightly rounded
#'   corners) or `"circle"`.
#' @param nudge_x,nudge_y Offset of the callout's center from the data point, in
#'   points.
#' @param size Text size, in mm, as for [ggplot2::geom_text()].
#' @param family Font family of the text.
#' @param padding Space between the text and the edge of the shape, in points.
#' @param tail_width Half the width of the tail where it leaves the shape, in
#'   points.
#' @param facets A named list of faceting-variable values, to draw the callout
#'   in one panel only, as in `facets = list(panel = "Taiwan")`. `NULL`, the
#'   default, draws it in every panel. If the faceting variable is a factor,
#'   pass a factor with the same levels: a plain string makes ggplot2 sort the
#'   panels.
#' @return A ggplot2 layer.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' d <- data.frame(quarter = 1:6, change = c(-7.9, -1.3, 6.8, 0.3, 5.2, 0.7))
#' ggplot(d, aes(quarter, change)) +
#'   geom_col(aes(fill = change >= 0), width = 0.95) +
#'   geom_hline(yintercept = 0) +
#'   wsj_callout(6, 0.7, "2Q:\n0.7%", shape = "rounded", nudge_x = -6, nudge_y = 30) +
#'   scale_fill_manual(values = rev(wsj_pal("direction")(2)), guide = "none") +
#'   scale_y_continuous(labels = wsj_label(suffix = "%")) +
#'   coord_cartesian(clip = "off") +
#'   theme_wsj()
#'
#' # A yellow circle on the last point of a line
#' rate <- data.frame(year = 2009:2012, value = c(2, 2, 3.25, 3))
#' ggplot(rate, aes(year, value)) +
#'   geom_step(color = wsj_pal("blues")(1)) +
#'   wsj_callout(2012, 3, "3.0%", fill = "yellow", shape = "circle", nudge_x = -14, nudge_y = -22) +
#'   theme_wsj()
#' @export
#' @importFrom rlang .data
wsj_callout <- function(
  x,
  y,
  label,
  fill = "black",
  colour = NULL,
  shape = c("rectangle", "rounded", "circle"),
  nudge_x = -12,
  nudge_y = 16,
  size = 3.2,
  family = "",
  padding = 3,
  tail_width = 3,
  facets = NULL
) {
  shape <- rlang::arg_match(shape)
  data <- wsj_facet_data(data.frame(x = x, y = y, label = label, stringsAsFactors = FALSE), facets)
  fills <- ggthemes::ggthemes_data$wsj$callout
  if (length(fill) == 1L && fill %in% names(fills)) {
    fill <- fills[[fill]]
  }
  if (is.null(colour)) {
    rgb <- grDevices::col2rgb(fill)[, 1] / 255
    colour <- if (sum(c(0.299, 0.587, 0.114) * rgb) > 0.5) "#000000" else "#ffffff"
  }
  ggplot2::layer(
    data = data,
    mapping = ggplot2::aes(x = .data$x, y = .data$y, label = .data$label),
    stat = ggplot2::StatIdentity,
    geom = GeomWsjCallout,
    position = ggplot2::PositionIdentity,
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      fill = fill,
      colour = colour,
      shape = shape,
      nudge_x = nudge_x,
      nudge_y = nudge_y,
      size = size,
      family = family,
      padding = padding,
      tail_width = tail_width
    )
  )
}

GeomWsjCallout <- ggplot2::ggproto(
  "GeomWsjCallout",
  ggplot2::Geom,
  required_aes = c("x", "y", "label"),
  draw_panel = function(
    data,
    panel_params,
    coord,
    fill = "#000000",
    colour = "#ffffff",
    shape = "rectangle",
    nudge_x = -12,
    nudge_y = 16,
    size = 3.2,
    family = "",
    padding = 3,
    tail_width = 3
  ) {
    coords <- coord$transform(data, panel_params)
    grobs <- lapply(seq_len(nrow(coords)), function(i) {
      wsj_callout_grob(
        coords$x[i],
        coords$y[i],
        coords$label[i],
        fill = fill,
        colour = colour,
        shape = shape,
        nudge_x = nudge_x,
        nudge_y = nudge_y,
        fontsize = size * ggplot2::.pt,
        family = family,
        padding = padding,
        tail_width = tail_width
      )
    })
    grid::gTree(children = do.call(grid::gList, grobs))
  }
)

# One callout: the tail, then the shape over its base, then the text. Positions
# are the data point in npc plus offsets in points, so the callout keeps its
# size and distance when the plot is resized.
wsj_callout_grob <- function(
  x,
  y,
  label,
  fill,
  colour,
  shape,
  nudge_x,
  nudge_y,
  fontsize,
  family,
  padding,
  tail_width
) {
  ax <- grid::unit(x, "npc")
  ay <- grid::unit(y, "npc")
  cx <- ax + grid::unit(nudge_x, "pt")
  cy <- ay + grid::unit(nudge_y, "pt")
  gp_fill <- grid::gpar(fill = fill, col = NA)
  text <- grid::textGrob(
    label,
    x = cx,
    y = cy,
    gp = grid::gpar(col = colour, fontsize = fontsize, fontface = "bold", fontfamily = family, lineheight = 0.9)
  )
  width <- grid::grobWidth(text) + grid::unit(2 * padding, "pt")
  height <- grid::grobHeight(text) + grid::unit(2 * padding, "pt")
  body <- switch(
    shape,
    rectangle = grid::rectGrob(cx, cy, width, height, gp = gp_fill),
    rounded = grid::roundrectGrob(cx, cy, width, height, r = grid::unit(3, "pt"), just = "centre", gp = gp_fill),
    circle = grid::circleGrob(cx, cy, r = 0.5 * max(width, height), gp = gp_fill)
  )
  # The tail's base straddles the center of the shape, at right angles to the
  # line from the center to the data point; the shape covers all but its tip.
  len <- sqrt(nudge_x^2 + nudge_y^2)
  if (len == 0) {
    return(grid::gTree(children = grid::gList(body, text)))
  }
  px <- grid::unit(tail_width * nudge_y / len, "pt")
  py <- grid::unit(-tail_width * nudge_x / len, "pt")
  tail <- grid::polygonGrob(
    x = grid::unit.c(ax, cx + px, cx - px),
    y = grid::unit.c(ay, cy + py, cy - py),
    gp = gp_fill
  )
  grid::gTree(children = grid::gList(tail, body, text))
}

#' Wall Street Journal threshold areas
#'
#' Fills the area between a series and a threshold, in one color above it and
#' another below, as Wall Street Journal charts of purchasing managers' indexes
#' and business sentiment do: green above 50 for expansion and red below for
#' contraction. Where the series crosses the threshold between two
#' observations, the crossing is interpolated, so the two fills meet at the
#' threshold and do not overlap.
#'
#' The layer draws only the fills. Draw the series over it with
#' `geom_line(colour = "black")` and the threshold with `geom_hline()`, and
#' label the two directions with [wsj_direction_bar()].
#'
#' @inheritParams ggplot2::geom_area
#' @param threshold The value that divides the two fills, in data units.
#' @param fill Two colors: above the threshold, then below. The default is
#'   the mid green and mid red that the charts used from 2012.
#' @param alpha Opacity of the fills.
#' @return A ggplot2 layer.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' pmi <- data.frame(
#'   month = seq(as.Date("2011-01-01"), by = "month", length.out = 20),
#'   index = c(54.5, 51.7, 51.8, 51.8, 51.6, 50.1, 49.3, 49.9, 49.9, 51, 47.7,
#'             48.7, 48.8, 49.6, 48.3, 48.7, 48.4, 49.3, 48.5, 47.8)
#' )
#' ggplot(pmi, aes(month, index)) +
#'   geom_wsj_threshold(threshold = 50) +
#'   geom_hline(yintercept = 50) +
#'   geom_line() +
#'   theme_wsj()
#' @export
geom_wsj_threshold <- function(
  mapping = NULL,
  data = NULL,
  threshold = 0,
  fill = c("#65a479", "#d5695d"),
  alpha = 1,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
) {
  if (length(fill) != 2L) {
    cli::cli_abort("{.arg fill} must be two colors, above and then below the threshold.")
  }
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = ggplot2::StatIdentity,
    geom = GeomWsjThreshold,
    position = ggplot2::PositionIdentity,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(threshold = threshold, fill = fill, alpha = alpha, na.rm = na.rm)
  )
}

GeomWsjThreshold <- ggplot2::ggproto(
  "GeomWsjThreshold",
  ggplot2::Geom,
  required_aes = c("x", "y"),
  draw_key = ggplot2::draw_key_rect,
  # Keep missing values until draw time, as geom_area() does, so the fills break at them.
  handle_na = function(self, data, params) {
    data
  },
  draw_group = function(data, panel_params, coord, threshold = 0, fill = c("#65a479", "#d5695d"), alpha = 1) {
    data <- data[order(data$x), , drop = FALSE]
    data <- data[is.finite(data$x), , drop = FALSE]
    # Each run of observations between missing values is filled on its own, not joined across the gap.
    present <- is.finite(data$y)
    runs <- split(data[present, , drop = FALSE], cumsum(!present)[present])
    grobs <- lapply(runs, function(run) {
      if (nrow(run) < 2L) {
        return(NULL)
      }
      xy <- wsj_threshold_crossings(run$x, run$y, threshold)
      side <- function(y, colour) {
        corners <- data.frame(x = c(xy$x, rev(xy$x)), y = c(y, rep(threshold, length(y))))
        corners <- coord$transform(corners, panel_params)
        grid::polygonGrob(
          corners$x,
          corners$y,
          default.units = "native",
          gp = grid::gpar(fill = scales::alpha(colour, alpha), col = NA)
        )
      }
      grid::gList(side(pmax(xy$y, threshold), fill[[1]]), side(pmin(xy$y, threshold), fill[[2]]))
    })
    grobs <- Filter(Negate(is.null), grobs)
    if (!length(grobs)) {
      return(grid::nullGrob())
    }
    do.call(grid::gList, unlist(grobs, recursive = FALSE))
  }
)

# Adds a point at the threshold wherever the series crosses it between two observations.
wsj_threshold_crossings <- function(x, y, threshold) {
  d <- y - threshold
  i <- which(d[-length(d)] * d[-1L] < 0)
  xc <- x[i] + (threshold - y[i]) * (x[i + 1L] - x[i]) / (y[i + 1L] - y[i])
  out_x <- c(x, xc)
  out_y <- c(y, rep(threshold, length(xc)))
  o <- order(out_x)
  list(x = out_x[o], y = out_y[o])
}

#' Wall Street Journal direction bars
#'
#' Labels the two sides of a threshold with arrows beside the panel, as Wall
#' Street Journal charts do: a green arrow pointing up from the threshold,
#' "Expanding", and a red one pointing down, "Contracting", with the words set
#' up the arrows. An optional title, such as "SENTIMENT", sits between them at
#' the threshold.
#'
#' The bar is drawn outside the panel, so the plot needs
#' `coord_cartesian(clip = "off")` and a wide enough margin on that side.
#' On the left it has to clear the y labels: raise `offset` until it does.
#'
#' @param threshold The value that divides the two arrows, in data units.
#' @param labels Two labels: above the threshold, then below.
#' @param title Text set between the arrows at the threshold, or `NULL`.
#' @param side `"left"` or `"right"` of the panel.
#' @param fill Two colors: the upper arrow, then the lower.
#' @param width Width of the bar, in points.
#' @param offset Distance from the edge of the panel to the bar, in points.
#' @param size Text size, in mm, as for [ggplot2::geom_text()].
#' @param family Font family of the text.
#' @param facets A named list of faceting-variable values, to draw the bar
#'   beside one panel only, as in `facets = list(panel = "China")`. Multi-panel
#'   WSJ charts draw it once, beside the first panel. `NULL`, the default, draws
#'   it beside every panel. If the faceting variable is a factor, pass a factor
#'   with the same levels: a plain string makes ggplot2 sort the panels.
#' @return A ggplot2 layer.
#' @family themes wsj
#' @examples
#' library("ggplot2")
#' pmi <- data.frame(
#'   month = seq(as.Date("2011-01-01"), by = "month", length.out = 20),
#'   index = c(54.5, 51.7, 51.8, 51.8, 51.6, 50.1, 49.3, 49.9, 49.9, 51, 47.7,
#'             48.7, 48.8, 49.6, 48.3, 48.7, 48.4, 49.3, 48.5, 47.8)
#' )
#' ggplot(pmi, aes(month, index)) +
#'   geom_wsj_threshold(threshold = 50) +
#'   geom_hline(yintercept = 50) +
#'   geom_line() +
#'   wsj_direction_bar(50, side = "left", offset = 22) +
#'   coord_cartesian(clip = "off") +
#'   theme_wsj() +
#'   theme(plot.margin = margin(12, 12, 12, 30))
#' @export
wsj_direction_bar <- function(
  threshold = 0,
  labels = c("Expanding", "Contracting"),
  title = NULL,
  side = c("right", "left"),
  fill = c("#65a479", "#d5695d"),
  width = 11,
  offset = 4,
  size = 2.8,
  family = "",
  facets = NULL
) {
  side <- rlang::arg_match(side)
  if (length(labels) != 2L || length(fill) != 2L) {
    cli::cli_abort("{.arg labels} and {.arg fill} must each have two values, above and then below.")
  }
  ggplot2::layer(
    data = wsj_facet_data(data.frame(y = threshold), facets),
    mapping = ggplot2::aes(y = .data$y),
    stat = ggplot2::StatIdentity,
    geom = GeomWsjDirectionBar,
    position = ggplot2::PositionIdentity,
    show.legend = FALSE,
    inherit.aes = FALSE,
    params = list(
      labels = labels,
      title = title,
      side = side,
      fill = fill,
      width = width,
      offset = offset,
      size = size,
      family = family
    )
  )
}

GeomWsjDirectionBar <- ggplot2::ggproto(
  "GeomWsjDirectionBar",
  ggplot2::Geom,
  required_aes = "y",
  draw_panel = function(
    data,
    panel_params,
    coord,
    labels = c("Expanding", "Contracting"),
    title = NULL,
    side = "right",
    fill = c("#65a479", "#d5695d"),
    width = 11,
    offset = 4,
    size = 2.8,
    family = ""
  ) {
    y0 <- coord$transform(data.frame(x = NA_real_, y = data$y[1]), panel_params)$y
    y0 <- min(max(y0, 0), 1)
    pt <- function(v) grid::unit(v, "pt")
    npc <- function(v) grid::unit(v, "npc")
    # The bar's left edge, in points from the panel edge.
    x0 <- if (side == "left") npc(0) - pt(offset + width) else npc(1) + pt(offset)
    x1 <- x0 + pt(width)
    xc <- x0 + pt(width / 2)
    tip <- width / 2
    fontsize <- size * ggplot2::.pt
    text_gp <- function(col) grid::gpar(col = col, fontsize = fontsize, fontface = "bold", fontfamily = family)
    # Half the gap at the threshold: the title's length, or a hairline.
    half_gap <- if (is.null(title)) {
      pt(1)
    } else {
      0.5 * grid::grobWidth(grid::textGrob(title, gp = text_gp("black"))) + pt(3)
    }
    arrow <- function(from, to, up, colour, label) {
      tip_base <- if (up) to - pt(tip) else to + pt(tip)
      body <- grid::polygonGrob(
        x = grid::unit.c(x0, x1, x1, xc, x0),
        y = grid::unit.c(from, from, tip_base, to, tip_base),
        gp = grid::gpar(fill = colour, col = NA)
      )
      text <- grid::textGrob(
        label,
        x = xc,
        y = 0.5 * (from + tip_base),
        rot = 90,
        gp = text_gp("#ffffff")
      )
      grid::gList(body, text)
    }
    grobs <- grid::gList(
      arrow(npc(y0) + half_gap, npc(1), TRUE, fill[[1]], labels[[1]]),
      arrow(npc(y0) - half_gap, npc(0), FALSE, fill[[2]], labels[[2]])
    )
    if (!is.null(title)) {
      grobs <- grid::gList(grobs, grid::textGrob(title, x = xc, y = npc(y0), rot = 90, gp = text_gp("#000000")))
    }
    grid::gTree(children = grobs)
  }
)

# Adds the values of faceting variables, passed as a named list, to an annotation layer's data, so that ggplot2
# draws the layer in the matching panel only.
wsj_facet_data <- function(data, facets = NULL) {
  if (!length(facets)) {
    return(data)
  }
  if (!is.list(facets) || !rlang::is_named(facets)) {
    cli::cli_abort(
      "{.arg facets} must be a list named by faceting variable, as in {.code facets = list(panel = \"A\")}."
    )
  }
  for (name in names(facets)) {
    value <- facets[[name]]
    if (!length(value) %in% c(1L, nrow(data))) {
      cli::cli_abort("{.code facets${name}} must have length 1 or {nrow(data)}, not {length(value)}.")
    }
    data[[name]] <- value
  }
  data
}
