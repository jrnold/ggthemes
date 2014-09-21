#' A ggplot theme originated from the pander package
#'
#' The \pkg{pander} ships with a default theme when the "unify plots" option is enabled via \code{panderOptions}, which is now also available outside of \pkg{pander} internals, like \code{evals}, \code{eval.msgs} or \code{Pandoc.brew}.
#' @param nomargin suppress the white space around the plot (boolean)
#' @param ff font family, like \code{sans}
#' @param fc font color (name or hexa code)
#' @param fs font size (integer)
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
theme_pander <- function(nomargin = TRUE, ff = 'sans', fc = 'black', fs = 12, gM = TRUE, gm = TRUE, gc = 'grey', gl = 'dashed') {

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

    ## default colors and font
    res <- theme(
        panel.grid       = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.major = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.minor = element_line(colour = gc, size = 0.1, linetype = gl),
        plot.title       = element_text(colour = fc, family = ff, face = "bold", size = fs * 1.2),
        axis.text        = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        axis.text.x      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        axis.text.y      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        legend.text      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        legend.title     = element_text(colour = fc, family = ff, face = 'italic', size = fs),
        axis.title.x     = element_text(colour = fc, family = ff, face = 'plain', size = fs),
        strip.text.x     = element_text(colour = fc, family = ff, face = 'plain', size = fs),
        axis.title.y     = element_text(colour = fc, family = ff, face = 'plain', size = fs, angle = 90),
        strip.text.y     = element_text(colour = fc, family = ff, face = 'plain', size = fs, angle = -90)
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
