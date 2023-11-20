#' Base colors for Solarized light and dark themes
#'
#' @param light \code{logical} Light theme?
#'
#' Creates the base colors for a light or dark solarized theme. See
#' \url{https://ethanschoonover.com/solarized/}. This function is a port
#' of the CSS style example.
#'
#' @keywords internal
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

solarized_accent_list <- function() {
  paste0("\\code{\"", names(ggthemes::ggthemes_data$solarized$Accents), "\"}",
         collapse = ",")
}

#' Solarized color palette (discrete)
#'
#' Qualitative color palate based on the Ethan Schoonover's Solarized
#' palette, \url{https://ethanschoonover.com/solarized/}. This palette supports
#' up to seven values.
#'
#' @note
#'
#' For a given starting color and number of colors in the palette,
#' the other colors are the combination of colors that maximizes the
#' total Euclidean distance between colors in L*a*b space.
#'
#' @param accent \code{character} Starting color.
#' @export
#' @family solarized colour
#' @example inst/examples/ex-solarized_pal.R
solarized_pal <- function(accent = "blue") {
  palettes <- ggthemes::ggthemes_data[["solarized"]][["palettes"]][[accent]]
  max_n <- length(palettes)
  f <- function(n) {
    check_pal_n(n, max_n)
    palettes[[n]]
  }
  attr(f, "max_n") <- f
  f
}

#' Solarized color scales
#'
#' See \code{\link{solarized_pal}()} for details.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams solarized_pal
#' @family colour scales
#' @rdname scale_solarized
#' @family solarized colour
#' @export
#' @example inst/examples/ex-scale_solarized.R
scale_fill_solarized <- function(accent = "blue", ...) {
  discrete_scale("fill", "solarized", solarized_pal(accent), ...)
}

#' @export
#' @rdname scale_solarized
scale_colour_solarized <- function(accent = "blue", ...) {
  discrete_scale("colour", "solarized", solarized_pal(accent), ...)
}
#' @export
#' @rdname scale_solarized
scale_color_solarized <- scale_colour_solarized

#' ggplot color themes based on the Solarized palette
#'
#' See \url{https://ethanschoonover.com/solarized/} for a
#' description of the Solarized palette.
#'
#' Plots made with this theme integrate seamlessly with the Solarized
#' Beamer color theme.
#' \url{https://github.com/jrnold/beamercolorthemesolarized}.
#' There are two variations: \code{theme_solarized} is similar to
#' to \code{\link[ggplot2]{theme_bw}()}, while \code{theme_solarized_2()} is
#' similar to \code{\link[ggplot2]{theme_gray}()}.
#'
#' @rdname theme_solarized
#' @inheritParams ggplot2::theme_grey
#' @param light \code{logical}. Light or dark theme?
#' @export
#' @family themes solarized
#' @example inst/examples/ex-theme_solarized.R
theme_solarized <- function(base_size = 12, base_family = "", light = TRUE) {
  rebase <- solarized_rebase(light)
  ret <- (theme_bw(base_size = base_size, base_family = base_family) +
            theme(text = element_text(colour = rebase["rebase01"]),
                  title = element_text(color = rebase["rebase0"]),
                  line = element_line(color = rebase["rebase01"]),
                  rect = element_rect(fill = rebase["rebase03"],
                                      color = rebase["rebase01"]),
                  axis.ticks = element_line(color = rebase["rebase01"]),
                  axis.line = element_line(color = rebase["rebase01"],
                                           linetype = 1),
                  legend.background = element_rect(fill = NULL, color = NA),
                  legend.key = element_rect(fill = NULL,
                                            colour = NULL, linetype = 0),
                  panel.background = element_rect(fill = rebase["rebase03"],
                                                  colour = rebase["rebase01"]),
                  panel.border = element_blank(),
                  panel.grid = element_line(color = rebase["rebase02"]),
                  panel.grid.major = element_line(color = rebase["rebase02"]),
                  panel.grid.minor = element_line(color = rebase["rebase02"]),
                  plot.background = element_rect(fill = NULL, colour = NA,
                                                 linetype = 0)))
  ret
}

#' @rdname theme_solarized
#' @export
theme_solarized_2 <- function(base_size = 12, base_family = "", light = TRUE) {
  rebase <- solarized_rebase(light)
  ret <- (theme_foundation(base_size = base_size, base_family = base_family) +
            theme(text = element_text(color = rebase["rebase01"]),
                  title = element_text(color = rebase["rebase0"]),
                  line = element_line(color = rebase["rebase01"]),
                  rect = element_rect(fill = rebase["rebase03"],
                                      color = NA),
                  axis.ticks = element_line(color = rebase["rebase01"]),
                  axis.line = element_line(color = rebase["reabase01"],
                                           linetype = 1),
                  axis.title.y = element_text(angle = 90),
                  legend.background = element_rect(fill = NULL, color = NA),
                  legend.key = element_rect(fill = NULL, colour = NULL,
                                            linetype = 0),
                  panel.background = element_rect(fill = rebase["rebase02"],
                                                  colour = NA),
                  panel.border = element_blank(),
                  panel.grid = element_line(color = rebase["rebase03"]),
                  panel.grid.major = element_line(color = rebase["rebase03"]),
                  panel.grid.minor = element_line(color = rebase["rebase03"],
                                                  linewidth = 0.25),
                  plot.background = element_rect(fill = NULL,
                                                 colour = NULL, linetype = 0)))
  ret
}
