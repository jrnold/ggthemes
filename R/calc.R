##' Theme Calc
##'
##' Theme similar to the default settings of LibreOffice Calc charts.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes calc
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'   + theme_calc())
theme_calc <- function(base_size = 10, base_family = "sans") {
  (theme_foundation(base_family = base_family, base_size = base_size)
   + theme(rect = element_rect(colour = NA),
           line = element_line(colour = "gray70"),
           plot.title = element_text(size = rel(1.3)), # 13 pt
           legend.title = element_text(size = rel(1)),
           legend.text = element_text(size = rel(1)),
           axis.title = element_text(size = rel(1)),
           axis.line = element_blank(),
           panel.border = element_rect(colour = "gray70"),
           panel.grid.minor = theme_blank(),
           panel.grid.major.x = theme_blank(),
           legend.position = "right",
           legend.direction = "vertical"))
           
}
