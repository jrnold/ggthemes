selenized_variants <- c("light", "dark", "black", "white")

# The data for one Selenized variant, after checking its name.
selenized_data <- function(variant, call = rlang::caller_env()) {
  variant <- rlang::arg_match(variant, selenized_variants, error_call = call)
  ggthemes::ggthemes_data[["selenized"]][[variant]]
}

#' Selenized color palette (discrete)
#'
#' Qualitative color palette from the accent colors of Jan Warchoł's
#' Selenized color scheme, <https://github.com/jan-warchol/selenized>. Each
#' variant has its own eight accent colors, balanced in lightness against that
#' variant's background, so use the same `variant` here as in
#' [theme_selenized()]. This palette supports up to eight values.
#'
#' @note
#'
#' For a given starting color and number of colors in the palette, the other
#' colors are the combination of colors that maximizes the total Euclidean
#' distance between colors in L*a*b space, as in [solarized_pal()].
#'
#' @param accent A string, the name of the starting color: one of `"red"`,
#'   `"green"`, `"yellow"`, `"blue"`, `"magenta"`, `"cyan"`, `"orange"` or
#'   `"violet"`.
#' @param variant A string, the Selenized variant: `"light"`, `"dark"`,
#'   `"black"` or `"white"`.
#' @returns A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @family color selenized
#' @example inst/examples/ex-selenized_pal.R
selenized_pal <- function(accent = "blue", variant = "light") {
  palettes <- selenized_data(variant)[["palettes"]]
  accent <- rlang::arg_match(accent, names(palettes))
  palettes <- palettes[[accent]]
  max_n <- length(palettes)
  f <- function(n) {
    check_pal_n(n, max_n)
    if (n == 0L) {
      return(character())
    }
    if (n > max_n) {
      return(c(palettes[[max_n]], rep(NA_character_, n - max_n)))
    }
    palettes[[n]]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Selenized color scales
#'
#' See [selenized_pal()] for details.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams selenized_pal
#' @rdname scale_selenized
#' @family color selenized
#' @returns A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_selenized.R
scale_colour_selenized <- function(..., accent = "blue", variant = "light") {
  discrete_scale("colour", palette = selenized_pal(accent, variant), ...)
}

#' @export
#' @rdname scale_selenized
scale_color_selenized <- scale_colour_selenized

#' @export
#' @rdname scale_selenized
scale_fill_selenized <- function(..., accent = "blue", variant = "light") {
  discrete_scale("fill", palette = selenized_pal(accent, variant), ...)
}

#' Theme based on the Selenized color scheme
#'
#' Theme using the colors of Jan Warchoł's Selenized color scheme,
#' <https://github.com/jan-warchol/selenized>. Selenized is a successor to
#' Solarized (see [theme_solarized()]) with higher contrast and accent colors
#' of balanced lightness. It has four variants: `"light"` and `"dark"`, on
#' tinted backgrounds like Solarized, and `"black"` and `"white"`, on neutral
#' ones.
#'
#' Text uses the scheme's foreground, `fg_0`, and titles its bold foreground,
#' `fg_1`. Grid lines use `bg_1`, and axis lines and ticks the dim foreground,
#' `dim_0`. Geoms default to the foreground and
#' background colors, so that they show on the dark variants. Use
#' [scale_colour_selenized()] with the same `variant` for matching data colors.
#'
#' @inheritParams ggplot2::theme_grey
#' @inheritParams selenized_pal
#' @returns A ggplot2 theme object (class `theme`).
#' @section Palettes:
#' The theme sets [selenized_pal()], for the same `variant`, for discrete colour
#' and fill as the default palettes, so a plot draws in the theme's colours
#' without a matching scale. A `scale_*()` added to the plot still takes
#' precedence.
#' @export
#' @family themes selenized
#' @example inst/examples/ex-theme_selenized.R
theme_selenized <- function(base_size = 12, base_family = "", variant = "light") {
  data <- selenized_data(variant)
  base <- deframe(data[["base"]])
  accents <- deframe(data[["accents"]])
  theme_foundation(
    base_size = base_size,
    base_family = base_family,
    ink = base[["fg_0"]],
    paper = base[["bg_0"]],
    accent = accents[["blue"]]
  ) +
    theme(
      text = element_text(colour = base[["fg_0"]]),
      plot.title = element_text(colour = base[["fg_1"]], face = "bold"),
      line = element_line(colour = base[["dim_0"]]),
      rect = element_rect(fill = base[["bg_0"]], colour = NA),
      axis.text = element_text(colour = base[["fg_0"]]),
      axis.ticks = element_line(colour = base[["dim_0"]]),
      axis.line = element_line(colour = base[["dim_0"]]),
      legend.background = element_rect(fill = NA, colour = NA),
      legend.key = element_rect(fill = NA, colour = NA),
      panel.background = element_rect(fill = base[["bg_0"]], colour = NA),
      panel.border = element_blank(),
      panel.grid = element_line(colour = base[["bg_1"]]),
      panel.grid.minor = element_line(linewidth = rel(0.5)),
      strip.background = element_rect(fill = base[["bg_1"]], colour = NA),
      strip.text = element_text(colour = base[["fg_1"]]),
      plot.background = element_rect(fill = base[["bg_0"]], colour = NA)
    ) +
    theme_palettes(selenized_pal(variant = variant))
}
