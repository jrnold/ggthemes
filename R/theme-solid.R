#' Theme with nothing other than a background color
#'
#' Theme that removes all non-geom elements (lines, text, etc.). Use it when
#' only the geometric objects are desired. `base_size` and `base_family` set
#' only the default size and font of text geoms, such as [ggplot2::geom_text()],
#' since the theme draws no text of its own.
#'
#' @inheritParams ggplot2::theme_grey
#' @param fill The background color of the plot.
#' @family themes
#' @example inst/examples/ex-theme_solid.R
#' @returns A ggplot2 theme object (class `theme`).
#' @export
theme_solid <- function(base_size = 12, base_family = "", fill = NA) {
  theme_foundation(base_size = base_size, base_family = base_family) +
    theme(
      line = element_blank(),
      text = element_blank(),
      rect = element_rect(fill = fill, colour = NA, linetype = 0)
    )
}
