#' Theme with nothing other than a background color
#'
#' Theme that removes all non-geom elements (lines, text, etc),
#' This theme is when only the geometric objects are desired.
#'
#' @param base_size Base font size.
#' @param base_family Ignored, kept for consistency with \code{theme}.
#' @param fill Background color of the plot.
#' @family themes
#' @examples
#' library("ggplot2")
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point()
#'  + theme_solid(fill = "white"))
#' @export
theme_solid <- function(base_size = 12, base_family = "", fill = NA) {
  theme(line = element_blank(),
        text = element_blank(),
        rect = element_rect(fill = fill, size = base_size, colour = NA, linetype = 0),
        # Maybe a bug. panel.background doesn't seem to inherit from geom_rect
        panel.background = element_rect(fill = fill),
        complete = TRUE)
}
