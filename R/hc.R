#' Chart styling for each Highcharts theme
#'
#' Values are taken from Highcharts 13's `css/themes/<style>.css`, falling back
#' to `css/highcharts.css` for the two `default` styles. Highcharts resolves
#' `.highcharts-axis-labels` and `.highcharts-title` to
#' `--highcharts-neutral-color-80`, `.highcharts-axis-title` to
#' `--highcharts-neutral-color-60`, and `.highcharts-grid-line` to
#' `--highcharts-neutral-color-10`; `bg` is `--highcharts-background-color`.
#'
#' A `NULL` colour means the style does not override ggplot2's default, which
#' is the case for the light styles.
#' @noRd
hc_theme_styles <- list(
  "default" = list(
    bg = "#FFFFFF",
    grid = "#e6e6e6",
    text = NULL,
    title = NULL,
    axis_title = NULL,
    legend_bg = NULL,
    x_grid = FALSE
  ),
  "default_dark" = list(
    bg = "#141414",
    grid = "#2c2c2c",
    text = "#d0d0d0",
    title = "#d0d0d0",
    axis_title = "#a1a1a1",
    legend_bg = NULL,
    x_grid = FALSE
  ),
  "darkunica" = list(
    bg = "#2a2a2b",
    grid = "#707073",
    text = "#E0E0E3",
    title = "#E0E0E3",
    axis_title = "#E0E0E3",
    legend_bg = NULL,
    x_grid = FALSE
  ),
  # `grid-light` is the one Highcharts theme that draws vertical grid lines
  # (`xAxis.gridLineWidth = 1`), and it puts the legend on a filled box.
  "grid_light" = list(
    bg = "#FFFFFF",
    grid = "#e6e6e6",
    text = NULL,
    title = NULL,
    axis_title = NULL,
    legend_bg = "#f2f2f2",
    x_grid = TRUE
  ),
  "sand_signika" = list(
    bg = "#F7F7F7",
    grid = "#e6e6e6",
    text = "#6E6E70",
    title = "black",
    axis_title = NULL,
    legend_bg = NULL,
    x_grid = FALSE
  )
)

#' Highcharts Theme
#'
#' Themes based on \href{https://www.highcharts.com/}{Highcharts} plots.
#'
#' @details
#'
#' Only the Highcharts themes that restyle the chart itself get a \code{style}
#' here. The \code{"high-contrast"}, \code{"avocado"} and \code{"sunset"}
#' themes shipped with Highcharts 13 change nothing but the series colours, so
#' they are available through \code{\link{hc_pal}()} alone; combine them with
#' \code{theme_hc("default")} or \code{theme_hc("default_dark")}.
#'
#' Highcharts pairs several of these themes with a web font
#' (\code{darkunica} with Unica One, \code{grid_light} with Dosis,
#' \code{sand_signika} with Signika). Those are not requested here, since the
#' font may not be installed; pass \code{base_family} to use one.
#'
#' @references
#'
#' \url{https://www.highcharts.com/demo/highcharts/line-chart}
#'
#' @inheritParams ggplot2::theme_bw
#' @param style The Highcharts theme to use. One of
#'   \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes:::hc_theme_styles))}.
#' @param bgcolor Deprecated
#' @example inst/examples/ex-theme_hc.R
#' @family themes hc
#' @export
theme_hc <- function(
  base_size = 12,
  base_family = "sans",
  style = c("default", "default_dark", "darkunica", "grid_light", "sand_signika"),
  bgcolor = NULL
) {
  if (!is.null(bgcolor)) {
    cli::cli_warn("{.arg bgcolor} is deprecated. Use {.arg style} instead.")
    style <- bgcolor
  }
  style <- match.arg(style)
  spec <- hc_theme_styles[[style]]

  ret <- theme(
    rect = element_rect(fill = spec$bg, linetype = 0, colour = NA),
    text = element_text(size = base_size, family = base_family),
    title = element_text(hjust = 0.5),
    axis.title.x = element_text(hjust = 0.5),
    axis.title.y = element_text(hjust = 0.5),
    panel.grid.major.y = element_line(colour = spec$grid),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = if (spec$x_grid) element_line(colour = spec$grid) else element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    legend.position = "bottom",
    legend.key = element_rect(fill = "#FFFFFF00")
  )

  # `theme() + theme()` copies over only the non-NULL properties of the new
  # elements, so these keep the sizes and justifications set above.
  if (!is.null(spec$text)) {
    ret <- ret +
      theme(
        text = element_text(colour = spec$text),
        # `axis.text` must be set explicitly: `theme_hc()` is a partial theme,
        # and the `theme_grey()` it is added to sets `axis.text` to "grey30",
        # which would otherwise beat the inherited `text` colour and leave the
        # axis labels near-invisible on the dark backgrounds.
        axis.text = element_text(colour = spec$text),
        legend.title = element_text(colour = spec$text)
      )
  }
  if (!is.null(spec$title)) {
    ret <- ret + theme(title = element_text(colour = spec$title))
  }
  if (!is.null(spec$axis_title)) {
    ret <- ret +
      theme(
        axis.title.x = element_text(colour = spec$axis_title),
        axis.title.y = element_text(colour = spec$axis_title)
      )
  }
  if (!is.null(spec$legend_bg)) {
    ret <- ret + theme(legend.background = element_rect(fill = spec$legend_bg))
  }
  ret
}


#' Highcharts color palette (discrete)
#'
#' Highcharts uses many different color palettes in its plots. This collects
#' the palettes shipped with Highcharts 13, plus the default Highcharts used
#' before v11.
#'
#' \code{"default"} and \code{"default_dark"} are the light- and dark-mode
#' forms of the palette Highcharts has used by default since v11.0.0; they
#' differ only in positions 2 and 3. \code{"classic"} is the default
#' Highcharts used from v5.0.0 through v10.x. The remaining palettes come
#' from the themes bundled with Highcharts.
#'
#' Note that \code{"avocado"} and \code{"sunset"} have only four colors.
#'
#' @param palette \code{character} The name of the Highcharts palette to use.
#'   One of \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$hc))}.
#'
#' @family colour hc
#' @export
hc_pal <- function(palette = "default") {
  # Match on the name rather than indexing directly, so that a non-character
  # `palette` (e.g. `hc_pal(1)`) is rejected instead of silently positionally
  # indexing the palette list.
  if (!palette %in% names(ggthemes::ggthemes_data$hc)) {
    cli::cli_abort(
      "{.arg palette} must be one of {.val {names(ggthemes::ggthemes_data$hc)}}, not {.val {palette}}."
    )
  }
  values <- unname(ggthemes::ggthemes_data$hc[[palette]])
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    values[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Highcharts color and fill scales
#'
#' Colour and fill scales which use the palettes in
#' \code{\link{hc_pal}()} and are meant for use with
#' \code{\link{theme_hc}()}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams hc_pal
#' @family colour hc
#' @rdname scale_hc
#' @export
scale_colour_hc <- function(palette = "default", ...) {
  discrete_scale("colour", palette = hc_pal(palette), ...)
}

#' @rdname scale_hc
#' @export
scale_color_hc <- scale_colour_hc

#' @rdname scale_hc
#' @export
scale_fill_hc <- function(palette = "default", ...) {
  discrete_scale("fill", palette = hc_pal(palette), ...)
}
