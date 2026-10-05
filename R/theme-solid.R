#' Theme with nothing other than a background color
#'
#' Theme that removes all non-geom elements (lines, text, etc.). Use it when
#' only the geometric objects are desired. The `base_family` argument is
#' ignored; it is kept for consistency with [ggplot2::theme_grey()].
#'
#' @inheritParams ggplot2::theme_grey
#' @param fill The background color of the plot.
#' @family themes
#' @example inst/examples/ex-theme_solid.R
#' @return A ggplot2 theme object (class `theme`).
#' @export
theme_solid <- function(base_size = 12, base_family = "", fill = NA) {
  theme_foundation() +
    theme(
      line = element_blank(),
      text = element_blank(),
      rect = element_rect(
        fill = fill,
        linewidth = base_size,
        colour = NA,
        linetype = 0
      )
    )
}
