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
#' @param boxes to render a border around the plot or not
#' @param bc background color (name or hexa code)
#' @param pc panel background color (name or hexa code)
#' @param lp legend position
#' @param axis axis angle as defined in \code{par(les)}
#' @export
#' @importFrom pander panderOptions
#' @examples \dontrun{
#' p <- qplot(mpg, wt, data = mtcars)
#' p + theme_pander()
#' panderOptions('graph.grid.color', 'red')
#' p + theme_pander()
#' }
theme_pander <- function(nomargin = TRUE, ff = 'sans', fc = 'black', fs = 12, gM = TRUE, gm = TRUE, gc = 'grey', gl = 'dashed', boxes = FALSE, bc = 'white', pc = 'transparent', lp = 'right', axis = 1) {

    ## load currently stored values from `panderOptions` if available
    if (require(pander)) {
        if (missing(nomargin))
            nomargin <- panderOptions('graph.nomargin')
        if (missing(ff))
            ff <- panderOptions('graph.fontfamily')
        if (missing(fc))
            fc <- panderOptions('graph.fontcolor')
        if (missing(fs))
            fs <- panderOptions('graph.fontsize')
        if (missing(gM))
            gM <- panderOptions('graph.grid')
        if (missing(gm))
            gm <- panderOptions('graph.grid.minor')
        if (missing(gc))
            gc <- panderOptions('graph.grid.color')
        if (missing(gl))
            gl <- panderOptions('graph.grid.lty')
        if (missing(boxes))
            boxes <- panderOptions('graph.boxes')
        if (missing(bc))
            bc <- panderOptions('graph.background')
        if (missing(pc))
            pc <- panderOptions('graph.panel.background')
        if (missing(lp))
            lp <- panderOptions('graph.legend.position')
        if (missing(axis))
            axis <- panderOptions('graph.axis.angle')
    }

    ## DRY
    tc <- ifelse(pc == 'transparent', bc, pc) # "transparent" color

    ## default colors, font and legend position
    res <- theme(
        plot.background  = element_rect(fill = bc, colour = NA),
        panel.grid       = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.major = element_line(colour = gc, size = 0.2, linetype = gl),
        panel.grid.minor = element_line(colour = gc, size = 0.1, linetype = gl),
        axis.ticks       = element_line(colour = gc, size = 0.2),
        plot.title       = element_text(colour = fc, family = ff, face = "bold", size = fs * 1.2),
        axis.text        = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        axis.text.x      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        axis.text.y      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        legend.text      = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8),
        legend.title     = element_text(colour = fc, family = ff, face = 'italic', size = fs),
        axis.title.x     = element_text(colour = fc, family = ff, face = 'plain', size = fs),
        strip.text.x     = element_text(colour = fc, family = ff, face = 'plain', size = fs),
        axis.title.y     = element_text(colour = fc, family = ff, face = 'plain', size = fs, angle = 90),
        strip.text.y     = element_text(colour = fc, family = ff, face = 'plain', size = fs, angle = -90),
        legend.key       = element_rect(colour = gc, fill = 'transparent'),
        strip.background = element_rect(colour = gc, fill = 'transparent'),
        panel.border     = element_rect(fill = NA, colour = gc),
        panel.background = element_rect(fill = pc, colour = gc),
        legend.position  = lp
    )

    ## disable box(es) around the plot
    if (!isTRUE(boxes)) {
        res <- res + theme(
            legend.key       = element_rect(colour = 'transparent', fill = 'transparent'),
            strip.background = element_rect(colour = 'transparent', fill = 'transparent'),
            panel.border     = element_rect(fill = NA, colour = tc),
            panel.background = element_rect(fill = pc, colour = tc)
        )
    }

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

    ## axis angle (TODO: DRY with ifelse in the default color etc. section)
    if (axis == 0)
        res <- res + theme(axis.text.y = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8, angle = 90))
    if (axis == 2)
        res <- res + theme(axis.text.x = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8, angle = 90, hjust = 1))
    if (axis == 3)
        res <- res + theme(
            axis.text.y = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8, angle = 90),
            axis.text.x = element_text(colour = fc, family = ff, face = 'plain', size = fs * 0.8, angle = 90, hjust = 1)
        )

    res

}

