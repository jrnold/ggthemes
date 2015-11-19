#' @include ggthemes-package.R
NULL

#' Foundation Theme
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation}
#' is a complete theme with only minimal number of elements defined.
#'
#' It is easier to create new themes by extending this one rather
#' than \code{theme_gray} or \code{theme_bw}, because those themes
#' those themes define elements deep in the hierarchy.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @export
theme_foundation <- function(base_size=12, base_family="") {
  thm <- theme_gray(base_size = base_size, base_family = base_family)
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm
}

