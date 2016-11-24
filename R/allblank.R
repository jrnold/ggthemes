##' All Blank Theme
##'
##' Theme removing all scale elements. This theme is useful
##' when only the geometric objects are desired.
##'
##' @examples
##' (ggplot(mtcars, aes(wt, mpg))
##'  + geom_point() + geom_rangeframe()
##'  + theme_allblank())
##' @export
theme_blank <- function() {
   ret <- theme_bw() +
     theme(
       legend.background = element_blank(),
       legend.key        = element_blank(),
       panel.background  = element_blank(),
       panel.border      = element_blank(),
       strip.background  = element_blank(),
       plot.background   = element_blank(),
       axis.line         = element_blank(),
       panel.grid        = element_blank(),
       axis.text         = element_blank(),
       axis.ticks        = element_blank(),
       axis.title        = element_blank())
   ret
}
