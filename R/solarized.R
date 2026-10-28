#' Base colors for Solarized light and dark themes
#'
#' Creates the base colors for a light or dark solarized theme. See
#' <https://ethanschoonover.com/solarized/>. This function is a port
#' of the CSS style example.
#'
#' @param light If `TRUE` (the default), use the light theme; otherwise, use
#'   the dark theme.
#' @keywords internal
#' @returns A named character vector of eight hex colors, named `rebase03` to `rebase3`.
solarized_rebase <- function(light = TRUE) {
  basecolors <- deframe(ggthemes::ggthemes_data$solarized$Base)
  rebase <- if (light) {
    basecolors[c(paste0("base", 3:0), paste0("base0", 0:3))]
  } else {
    basecolors[c(paste0("base0", 3:0), paste0("base", 0:3))]
  }
  names(rebase) <- paste0("rebase", c(paste0("0", 3:0), 0:3))
  rebase
}

#' Solarized color palette (discrete)
#'
#' Qualitative color palette based on Ethan Schoonover's Solarized
#' palette, <https://ethanschoonover.com/solarized/>. This palette supports
#' up to eight values.
#'
#' @note
#'
#' For a given starting color and number of colors in the palette,
#' the other colors are the combination of colors that maximizes the
#' total Euclidean distance between colors in L*a*b space.
#'
#' @param accent A string, the name of the starting color: one of `"yellow"`,
#'   `"orange"`, `"red"`, `"magenta"`, `"violet"`, `"blue"`, `"cyan"` or
#'   `"green"`.
#' @returns A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @family color solarized
#' @example inst/examples/ex-solarized_pal.R
solarized_pal <- function(accent = "blue") {
  accents <- names(ggthemes::ggthemes_data[["solarized"]][["palettes"]])
  if (!is.character(accent) || length(accent) != 1L || !accent %in% accents) {
    cli::cli_abort("{.arg accent} must be one of {.val {accents}}, not {.val {accent}}.")
  }
  palettes <- ggthemes::ggthemes_data[["solarized"]][["palettes"]][[accent]]
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

#' Solarized color scales
#'
#' See [solarized_pal()] for details.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams solarized_pal
#' @rdname scale_solarized
#' @family color solarized
#' @returns A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_solarized.R
scale_fill_solarized <- function(accent = "blue", ...) {
  discrete_scale("fill", palette = solarized_pal(accent), ...)
}

#' @export
#' @rdname scale_solarized
scale_colour_solarized <- function(accent = "blue", ...) {
  discrete_scale("colour", palette = solarized_pal(accent), ...)
}
#' @export
#' @rdname scale_solarized
scale_color_solarized <- scale_colour_solarized

#' ggplot color themes based on the Solarized palette
#'
#' See <https://ethanschoonover.com/solarized/> for a
#' description of the Solarized palette.
#'
#' Plots made with this theme integrate seamlessly with the Solarized
#' Beamer color theme.
#' <https://github.com/jrnold/beamercolorthemesolarized>.
#' There are two variations: [theme_solarized()] is similar
#' to [ggplot2::theme_bw()], while `theme_solarized_2()` is
#' similar to [ggplot2::theme_gray()].
#'
#' @rdname theme_solarized
#' @inheritParams ggplot2::theme_grey
#' @param light If `TRUE` (the default), use the light theme; otherwise, use
#'   the dark theme.
#' @returns A ggplot2 theme object (class `theme`).
#' @section Palettes:
#' The theme sets [solarized_pal()] for discrete colour and fill as the default
#' palettes, so a plot draws in the theme's colours without a matching scale. A
#' `scale_*()` added to the plot still takes precedence.
#' @export
#' @family themes solarized
#' @example inst/examples/ex-theme_solarized.R
theme_solarized <- function(base_size = 12, base_family = "", light = TRUE) {
  rebase <- solarized_rebase(light)
  ret <- (theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      # Unmapped geoms draw in the body text colour, so they stay visible on
      # the dark variant's background.
      geom = ggplot2::element_geom(ink = unname(rebase["rebase0"]), paper = unname(rebase["rebase03"])),
      text = element_text(colour = rebase["rebase01"]),
      title = element_text(color = rebase["rebase0"]),
      line = element_line(color = rebase["rebase01"]),
      rect = element_rect(
        fill = rebase["rebase03"],
        color = rebase["rebase01"]
      ),
      axis.ticks = element_line(color = rebase["rebase01"]),
      axis.line = element_line(
        color = rebase["rebase01"],
        linetype = 1
      ),
      legend.background = element_rect(fill = NULL, color = NA),
      legend.key = element_blank(),
      panel.background = element_rect(
        fill = rebase["rebase03"],
        colour = rebase["rebase01"]
      ),
      panel.border = element_blank(),
      panel.grid = element_line(color = rebase["rebase02"]),
      panel.grid.major = element_line(color = rebase["rebase02"]),
      panel.grid.minor = element_line(color = rebase["rebase02"]),
      plot.background = element_rect(
        fill = NULL,
        colour = NA,
        linetype = 0
      )
    ))
  ret +
    theme_palettes(solarized_pal())
}

#' @rdname theme_solarized
#' @export
theme_solarized_2 <- function(base_size = 12, base_family = "", light = TRUE) {
  rebase <- solarized_rebase(light)
  ret <- (theme_foundation(base_size = base_size, base_family = base_family) +
    theme(
      # Unmapped geoms draw in the body text colour, so they stay visible on
      # the dark variant's background.
      geom = ggplot2::element_geom(ink = unname(rebase["rebase0"]), paper = unname(rebase["rebase03"])),
      text = element_text(color = rebase["rebase01"]),
      title = element_text(color = rebase["rebase0"]),
      line = element_line(color = rebase["rebase01"]),
      rect = element_rect(
        fill = rebase["rebase03"],
        color = NA
      ),
      axis.ticks = element_line(color = rebase["rebase01"]),
      axis.line = element_line(
        color = rebase["rebase01"],
        linetype = 1
      ),
      axis.title.y = element_text(angle = 90),
      legend.background = element_rect(fill = NULL, color = NA),
      legend.key = element_rect(
        fill = NULL,
        colour = NULL,
        linetype = 0
      ),
      panel.background = element_rect(
        fill = rebase["rebase02"],
        colour = NA
      ),
      panel.border = element_blank(),
      panel.grid = element_line(color = rebase["rebase03"]),
      panel.grid.major = element_line(color = rebase["rebase03"]),
      panel.grid.minor = element_line(
        color = rebase["rebase03"],
        linewidth = 0.25
      ),
      plot.background = element_rect(
        fill = NULL,
        colour = NULL,
        linetype = 0
      )
    ))
  ret +
    theme_palettes(solarized_pal())
}
