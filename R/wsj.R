#' Wall Street Journal theme
#'
#' Theme based on the plots in *The Wall Street Journal*.
#'
#' This theme should be used with [scale_color_wsj()].
#'
#' @references
#'
#' <https://x.com/WSJGraphics>
#'
#' <https://pinterest.com/wsjgraphics/wsj-graphics/>
#'
#' @inheritParams ggplot2::theme_grey
#' @param color The background color of plot. One of `'brown',
#' 'gray', 'green', 'blue'`.
#' @param title_family Plot title font family.
#' @family themes wsj
#' @example inst/examples/ex-theme_wsj.R
#' @return A ggplot2 theme object (class `theme`).
#' @export
#' @importFrom ggplot2 element_line element_rect element_text element_blank rel
theme_wsj <- function(base_size = 12, color = "brown", base_family = "sans", title_family = "mono") {
  bg_names <- names(ggthemes::ggthemes_data$wsj$bg)
  if (!is.character(color) || length(color) != 1L || !color %in% bg_names) {
    cli::cli_abort("{.arg color} must be one of {.val {bg_names}}, not {.val {color}}.")
  }
  colorhex <- ggthemes::ggthemes_data$wsj$bg[color]
  theme_foundation(base_size = base_size, base_family = base_family) +
    theme(
      line = element_line(linetype = 1, colour = "black"),
      rect = element_rect(fill = colorhex, linetype = 0, colour = NA),
      text = element_text(colour = "black"),
      title = element_text(
        family = title_family,
        size = rel(2)
      ),
      axis.title = element_blank(),
      axis.text = element_text(face = "bold", size = rel(1)),
      axis.text.x = element_text(colour = NULL),
      axis.text.y = element_text(colour = NULL),
      axis.ticks = element_line(colour = NULL),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(colour = NULL),
      axis.line = element_line(),
      axis.line.y = element_blank(),
      legend.background = element_rect(),
      legend.position = "top",
      legend.direction = "horizontal",
      legend.box = "vertical",
      panel.grid = element_line(colour = NULL, linetype = 3),
      panel.grid.major = element_line(colour = "black"),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      plot.title = element_text(hjust = 0, face = "bold"),
      plot.margin = unit(c(1, 1, 1, 1), "lines"),
      strip.background = element_rect()
    )
}

#' Wall Street Journal color palette (discrete)
#'
#' The Wall Street Journal uses many different color palettes in its
#' plots. This collects a few of them, but is by no means exhaustive.
#' Collections of these plots can be found on the WSJ Graphics
#' [X (formerly Twitter)](https://x.com/WSJGraphics) feed and
#' [Pinterest](https://pinterest.com/wsjgraphics/wsj-graphics/).
#'
#' @section Palettes:
#'
#' The following palettes are defined:
#'
#' - `"rgby"`: red/green/blue/yellow theme.
#' - `"red_green"`: green/red two-color scale for good/bad.
#' - `"green_black"`: black-green 4-color scale for "very negative",
#'   "somewhat negative", "somewhat positive", "very positive".
#' - `"dem_rep"`: Democrat/Republican/Undecided blue/red/gray scale.
#' - `"colors6"`: red, blue, gold, green, orange, and black palette.
#'
#' @param palette `character` The color palette to use. One of
#'   `r ggthemes:::md_optlist(names(ggthemes::ggthemes_data$wsj$palettes))`.
#'
#' @family color wsj
#' @return A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-wsj_pal.R
wsj_pal <- function(palette = "colors6") {
  palettes <- ggthemes::ggthemes_data[["wsj"]][["palettes"]]
  if (palette %in% names(palettes)) {
    colors <- palettes[[palette]][["value"]]
    max_n <- length(colors)
    f <- manual_pal_checked(unname(colors))
    attr(f, "max_n") <- max_n
    f
  } else {
    cli::cli_abort("{.arg palette} must be one of {.val {names(palettes)}}, not {.val {palette}}.")
  }
}

#' Wall Street Journal color and fill scales
#'
#' Color and fill scales which use the palettes in [wsj_pal()].
#' These scales should be used with [theme_wsj()].
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams wsj_pal
#' @family color wsj
#' @rdname scale_wsj
#' @return A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_wsj.R
scale_colour_wsj <- function(palette = "colors6", ...) {
  discrete_scale("colour", palette = wsj_pal(palette), ...)
}

#' @rdname scale_wsj
#' @export
scale_color_wsj <- scale_colour_wsj

#' @rdname scale_wsj
#' @export
scale_fill_wsj <- function(palette = "colors6", ...) {
  discrete_scale("fill", palette = wsj_pal(palette), ...)
}
