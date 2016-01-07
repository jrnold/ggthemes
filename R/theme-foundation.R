#' @include ggthemes-package.R
NULL

#' Foundation Theme
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation}
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than \code{theme_gray} or \code{theme_bw}, because those themes
#' those themes define elements deep in the hierarchy.
#'
#' This theme takes \code{theme_gray} and sets all \code{colour} and \code{fill}
#' values to \code{NULL}, except for the top-level elements
#' (\code{line}, \code{rect}, and \code{title}), which have \code{colour = "black"},
#' and \code{fill = "white"}. This leaves the spacing
#' and-non colour defaults of the default \code{ggplot2} themes in place.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @export
theme_foundation <- function(base_size=12, base_family="") {
  thm <- theme_grey(base_size = base_size, base_family = base_family)
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm + theme(panel.border = element_rect(fill = NA),
              legend.background = element_rect(colour = NA),
              line = element_line(colour = "black"),
              rect = element_rect(fill = "white", colour = "black"),
              text = element_text(colour = "black"))
}
