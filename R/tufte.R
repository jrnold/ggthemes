#' Tufte Maximal Data, Minimal Ink Theme
#'
#' Theme based on Chapter 6 'Data-Ink Maximization and Graphical
#' Design' of Edward Tufte *The Visual Display of Quantitative
#' Information*. No border, no axis lines, no grids. This theme works
#' best in combination with \code{\link{geom_rug}} or
#' \code{\link{geom_rangeframe}}.
#'
#' @note
#' The default font family is set to 'serif' as he uses serif fonts
#' for labels in 'The Visual Display of Quantitative Information'.
#' The serif font used by Tufte in his books is a variant of Bembo,
#' while the sans serif font is Gill Sans. If these fonts are
#' installed on your system, then you can use them with the package
#' \bold{extrafont}.
#'
#' @inheritParams ggplot2::theme_grey
#' @param ticks \code{logical} Show axis ticks?
#'
#' @references Tufte, Edward R. (2001) The Visual Display of
#' Quantitative Information, Chapter 6.
#'
#' @family themes tufte
#' @examples
#' library("ggplot2")
#' # with ticks and range frames
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point() + geom_rangeframe()
#'  + theme_tufte())
#' # with geom_rug
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point() + geom_rug()
#'  + theme_tufte(ticks=FALSE))
#' \dontrun{
#' ## Using the Bembo serif family
#' library(extrafont)
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point() + geom_rangeframe()
#'  + theme_tufte(base_family='BemboStd'))
#' ## Using the Gill Sans sans serif family
#' (ggplot(mtcars, aes(wt, mpg))
#'  + geom_point() + geom_rangeframe()
#'  + theme_tufte(base_family='GillSans'))
#' }
#' @export
theme_tufte <- function(base_size = 11, base_family = "serif", ticks = TRUE) {
  ## TODO: start with theme_minimal
  ret <- theme_bw(base_family = base_family, base_size = base_size) +
    theme(legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          axis.line = element_blank(),
          panel.grid = element_blank())
  if (!ticks) {
    ret <- ret + theme(axis.ticks = element_blank())
  }
  ret
}
