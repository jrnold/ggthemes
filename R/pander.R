#' A ggplot theme originated from the pander package
#'
#' The \pkg{pander} ships with a default theme when the "unify plots" option is enabled via \code{panderOptions}, which is now also available outside of \pkg{pander} internals, like \code{evals}, \code{eval.msgs} or \code{Pandoc.brew}.
#' @param nomargin suppress the white space around the plot (boolean)
#' @param gM major grid (boolean)
#' @param gm minor grid (boolean)
#' @param gc grid color (name or hexa code)
#' @param gl grid line type (\code{lty})
#' @export
#' @importFrom pander panderOptions
#' @examples \dontrun{
#' p <- qplot(mpg, wt, data = mtcars)
#' p + theme_pander()
#' panderOptions('graph.grid.color', 'red')
#' p + theme_pander()
#' }
theme_pander <- function(nomargin = TRUE, gM = TRUE, gm = TRUE, gc = 'grey', gl = 'dashed') {

    ## load currently stored values from `panderOptions` if available
    if (require(pander)) {
        if (missing(nomargin))
            nomargin <- panderOptions('graph.nomargin')
        if (missing(gM))
            gM <- panderOptions('graph.grid')
        if (missing(gm))
            gm <- panderOptions('graph.grid.minor')
        if (missing(gc))
            gc <- panderOptions('graph.grid.color')
        if (missing(gl))
            gl <- panderOptions('graph.grid.lty')
    }

    ## default colors
    res <- theme(
        panel.grid       = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.major = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.minor = element_line(colour = gc, size = 0.1, linetype = gl)
    )

    ## disable grid
    if (!isTRUE(gM)) {
        res <- res + theme(
            panel.grid       = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()
        )
    }
    ## disable minor grid
    if (!isTRUE(gm))
        res <- res + theme(
            panel.grid.minor = element_blank()
        )

    ## margin
    if (nomargin)
        res <- res + theme(plot.margin = unit(c(0.1, 0.1, 0.1, 0), "lines"))

    res

}
