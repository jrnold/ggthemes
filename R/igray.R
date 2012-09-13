##' Inverse gray theme
##'
##' Inverts the colors in the \code{\link{theme_gray}}, a white panel
##' and a light gray area around it. This keeps a white background,
##' but with more gray, it keeps the plot closer to the typographical
##' color of the document, which was the motivation for using a gray
##' background in \code{theme_gray}. This is also the style of plots
##' in Stata and Tableau.
##'
##' @param base_size base font size
##' @param base_family base font family
##' @export
##' @family themes
##' @examples
##' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
##' (d <- qplot(carat, price, data=dsamp, colour=clarity)
##'                + theme_igray())
theme_igray <- function(base_size=12, base_family="") {
    (theme_gray(base_size=base_size, base_family=base_family)
     + theme(rect = element_rect(fill="gray90"),
             legend.key = element_rect(fill="white"),
             panel.background = element_rect(fill="white"),
             panel.grid.major = element_line(colour="gray90"),
             plot.background = element_rect(fill="gray90")))
}

