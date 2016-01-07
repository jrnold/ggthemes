#' Base colors for Solarized light and dark themes
#'
#' @param light \code{logical} Light theme?
#'
#' Creates the base colors for a light or dark solarized theme. See
#' \url{http://ethanschoonover.com/solarized}. This function is a port
#' of the CSS style example.
#'
#' @keywords internal
solarized_rebase <- function(light = TRUE) {
  if (light) {
    rebase <- ggthemes_data$solarized$base[c(paste0("base", 3:0),
                                             paste0("base0", 0:3))]
  } else {
    rebase <- ggthemes_data$solarized$base[c(paste0("base0", 3:0),
                                             paste0("base", 0:3))]
  }
  names(rebase) <- paste0("rebase", c(paste0("0", 3:0), 0:3))
  rebase
}

solarized_accent_list <- function() {
  paste0("\\code{\"", names(ggthemes_data$solarized$accents), "\"}",
         collapse = ",")
}

#' Solarized color palette (discrete)
#'
#' Qualitative color palate based on the Ethan Schoonover's Solarized
#' palette, \url{http://ethanschoonover.com/solarized}.
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
#' @examples
#' library("scales")
#' show_col(solarized_pal()(2))
#' show_col(solarized_pal()(3))
#' show_col(solarized_pal('red')(4))
solarized_pal <- function(accent = "blue") {
  best_colors <- function(color, n = 1) {
    allcolors <- names(ggthemes_data$solarized$accents)
    othercolors <- setdiff(allcolors, color)
    solarized <- as(as(hex2RGB(ggthemes_data$solarized$accents), "LAB")@coords,
                    "matrix")
    rownames(solarized) <- names(ggthemes_data$solarized$accents)
    solarized_dist <- as.matrix(dist(solarized, method = "euclidean"))
    total_dist <- function(i) {
      sum(solarized_dist[i, i][lower.tri(diag(length(i)))])
    }
    if (n == 1) {
      colorlist <- color
    } else if (n >= length(allcolors)) {
      colorlist <- c(color, othercolors)
    } else {
      othercolors <- setdiff(allcolors, color)
      combinations <- combn(othercolors, n - 1)
      maxdist <-
        which.max(apply(combinations, 2, function(x) total_dist(c(color, x))))
      colorlist <- c(color, combinations[, maxdist])
    }
    unname(ggthemes_data$solarized$accents[colorlist])
  }
  function(n) {
    best_colors(accent, n)
  }

}

#' Solarized color scales
#'
#' See \code{\link{solarized_pal}} for details.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams solarized_pal
#' @family colour scales
#' @rdname scale_solarized
#' @family solarized colour
#' @export
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am)
#' p + theme_solarized() + scale_colour_solarized()
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
#' See \url{http://ethanschoonover.com/solarized} for a
#' description of the Solarized palette.
#'
#' Plots made with this theme integrate seamlessly with the Solarized
#' Beamer color theme.
#' \url{https://github.com/jrnold/beamercolorthemesolarized}.
#' There are two variations: \code{theme_solarized} is similar to
#' to \code{\link{theme_bw}}, while \code{theme_solarized_2} is similar to
#' \code{\link{theme_gray}}.
#'
#' @rdname theme_solarized
#' @inheritParams ggplot2::theme_grey
#' @param light \code{logical}. Light or dark theme?
#' @export
#' @family themes solarized
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am)
#' p + theme_solarized() + scale_colour_solarized('blue')
#'
#' ## Dark version
#' p + theme_solarized(light = FALSE) +
#'     scale_colour_solarized('blue')
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
                                                  size = 0.25),
                  plot.background = element_rect(fill = NULL,
                                                 colour = NULL, linetype = 0)))
  ret
}
