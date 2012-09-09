##' Tufte Data-Ink Maximized Theme
##'
##' Theme based on Chapter 6 "Data-Ink Maximization and Graphical
##' Design" of Edward Tufte *The Visual Display of Quantitative
##' Information*. No border, no axis lines, no grids. This theme works
##' best in combination with \code{\link{geom_rug}} or
##' \code{\link{geom_range_frame}}.
##'
##' @param ticks \code{logical} Show axis ticks?
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @seealso \code{\link{theme_minimal}} is a slightly less minimal
##' default theme.
##' @examples
##' # with ticks and range frames
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_range_frame()
##'  + theme_tufte())
##' # with geom_rug
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_rug()
##'  + theme_tufte(ticks=FALSE))
##' @export
theme_tufte <- function(ticks=TRUE) {
    ## TODO: start with theme_minimal
    ret <- theme_bw() +
        theme(
            legend.background = element_blank(),
            legend.key        = element_blank(),
            panel.background  = element_blank(),
            panel.border      = element_blank(),
            strip.background  = element_blank(),
            plot.background   = element_blank(),
            axis.line         = element_blank(),
            panel.grid = element_blank())
    if (!ticks) {
        ret <- ret + theme(axis.ticks = element_blank())
    }
    ret
}

