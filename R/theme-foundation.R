#' Foundation theme
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. `theme_foundation()`
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than [ggplot2::theme_gray()] or [ggplot2::theme_bw()],
#' because those themes define elements deep in the hierarchy.
#'
#' This theme takes [ggplot2::theme_gray()] and sets all
#' `colour` and `fill` values to `NULL`, except for the top-level
#' elements (`line`, `rect`, and `title`), which have
#' `colour = ink`, and `fill = paper`. This leaves the spacing
#' and non-color defaults of the default ggplot2 themes in place.
#'
#' Unlike `theme_foundation()`, the other themes in this package (e.g.
#' [theme_economist()], [theme_excel()],
#' [theme_hc()]) intentionally replicate a fixed, published
#' visual style, so they do not expose `ink`/`paper`/`accent`
#' arguments.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @return A ggplot2 theme object (class `theme`).
#' @export
#' @importFrom ggplot2 theme_grey
#' @example inst/examples/ex-theme_foundation.R
theme_foundation <- function(base_size = 12, base_family = "", ink = "black", paper = "white", accent = "#3366FF") {
  if (all(c("ink", "paper", "accent") %in% names(formals(theme_grey)))) {
    thm <- theme_grey(base_size = base_size, base_family = base_family, ink = ink, paper = paper, accent = accent)
  } else {
    thm <- theme_grey(base_size = base_size, base_family = base_family)
  }
  # Clear every element's colour and fill so they inherit from `line`, `rect`
  # and `text` below. Test with `$` rather than names(): ggplot2 >= 4.0.0
  # elements are S7 objects, whose names() is empty.
  for (i in names(thm)) {
    if (!inherits(thm[[i]], "element")) {
      next
    }
    if (!is.null(thm[[i]]$colour)) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if (!is.null(thm[[i]]$fill)) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm +
    theme(
      panel.border = element_rect(fill = NA),
      legend.background = element_rect(colour = NA),
      line = element_line(colour = ink),
      rect = element_rect(fill = paper, colour = ink),
      text = element_text(colour = ink)
    )
}
