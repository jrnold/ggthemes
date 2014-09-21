#' A ggplot theme originated from the pander package
#'
#' The \pkg{pander} ships with a default theme when the "unify plots" option is enabled via \code{panderOptions}, which is now also available outside of \pkg{pander} internals, like \code{evals}, \code{eval.msgs} or \code{Pandoc.brew}.
#' @param gc grid color (name or hexa code)
#' @export
#' @importFrom pander panderOptions
#' @examples \dontrun{
#' p <- qplot(mpg, wt, data = mtcars)
#' p + theme_pander()
#' panderOptions('graph.grid.color', 'red')
#' p + theme_pander()
#' }
theme_pander <- function(gc = 'grey') {

    ## load currently stored values from `panderOptions` if available
    if (require(pander)) {
        if (missing(gc))
            gc <- panderOptions('graph.grid.color')
    }

    ## return
    theme(
        panel.grid       = element_line(colour = gc),
        panel.grid.major = element_line(colour = gc),
        panel.grid.minor = element_line(colour = gc)
    )

}
