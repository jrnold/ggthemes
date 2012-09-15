##' Show shapes
##'
##' A quick and dirty way to show shapes for a palette.
##'
##' @export
##' @param shapes A numeric or character vector of shapes. See
##' \code{\link{par}}.
##' @seealso \code{\link{show_col}}, \code{\link{show_linetypes}}
##'
##' @examples
##' show_shapes(shape_pal()(5))
show_shapes <- function(shapes) {
    n <- length(shapes)
    ncol <- ceiling(sqrt(n))
    nrow <- ceiling(n/ncol)
    shapes <- c(shapes, rep(NA, nrow * ncol - length(shapes)))
    shapes <- matrix(shapes, ncol = ncol, byrow = TRUE)
    shapes <- shapes[nrow(shapes):1, ]
    plot(0, 0, xlim=c(1, ncol(shapes)), ylim=c(1, nrow(shapes)),
         type="n", xlab="", ylab="", axes=FALSE)
    for (i in seq_len(ncol(shapes))) {
        for (j in seq_len(nrow(shapes))) {
            print(c(i, j))
            points(i, j, pch=shapes[j, i])
        }
    }
}

##' Show linetypes
##'
##' A quick and dirty way to show linetypes for a palette.
##'
##' @export
##' @param linetypes A character vector of linetypes. See
##' \code{\link{par}}.
##' @seealso \code{\link{show_col}}, \code{\link{show_linetypes}}
##'
##' @examples
##' show_shapes(linetype_pal()(3))
show_linetypes <- function(linetypes) {
    n <- length(linetypes)
    plot(0, 0, xlim=c(0, 1), ylim=c(n, 1),
         type="n", xlab="", ylab="", axes=FALSE)
    for (i in seq_along(linetypes)) {
        abline(h=i, lty=linetypes[i])
    }
    axis(side=2, at=seq_len(n), tick=FALSE, labels=seq_len(n), las=2)
}

## altered from same function from ggplot2
rd_aesthetics <- function(name, geom)
{
    aes <- ggplot2:::aesthetics(geom)
    paste("\\code{", name, "} ", "understands the following aesthetics (required aesthetics are in bold):\n\n",
        "\\itemize{\n", paste("  \\item \\code{", aes, "}", collapse = "\n",
            sep = ""), "\n}\n", sep = "")
}

cpaste <- function(..., sep=", ", collapse=NULL, and=TRUE) {
    arglist <- list(...)
    n <- length(arglist)
    andsep <- ifelse(and, paste0(sep, "and "), sep)
    if (n == 1) {
        arglist
    } else {
        args1 <- arglist[1:(n-1)]
        paste(do.call(paste, c(args1, list(sep=sep, collapse=collapse))),
              arglist[n], sep=andsep)
    }
}


