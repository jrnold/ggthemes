##' Theme with nothing other than a background color
##'
##' Theme that removes all non-geom elements (lines, text, etc),
##' This theme is when only the geometric objects are desired.
##'
##' @param fill Background color of the plot.
##' @family themes
##' @examples
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point()
##'  + theme_solid("white"))
##' @export
theme_solid <- function(fill = NA) {
    base_size <- 12
    theme(line = element_blank(),
          text = element_blank(),
          rect = element_rect(fill = fill, size = base_size, colour = NA, linetype = 0),
          # Maybe a bug. panel.background doesn't seem to inherit from geom_rect
          panel.background = element_rect(fill = fill),
          complete = TRUE)
}

