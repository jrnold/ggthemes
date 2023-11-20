#' Theme with nothing other than a background color
#'
#' Theme that removes all non-geom elements (lines, text, etc),
#' This theme is when only the geometric objects are desired.
#'
#' @param base_size Base font size.
#' @param base_family Ignored, kept for consistency with \code{\link{theme}()}.
#' @param fill Background color of the plot.
#' @family themes
#' @example inst/examples/ex-theme_solid.R
#' @export
theme_solid <- function(base_size = 12, base_family = "", fill = NA) {
  theme_foundation() +
  theme(line = element_blank(),
        text = element_blank(),
        rect = element_rect(fill = fill, linewidth = base_size, colour = NA,
                            linetype = 0))
}
