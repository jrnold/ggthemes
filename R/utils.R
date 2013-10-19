## copied from ggplot2
aesthetics <- function (x) {
    req_aes <- x$required_aes
    def_aes <- names(x$default_aes())
    def_aes <- setdiff(def_aes, req_aes)
    if (length(req_aes) == 0) {
        return(suppressWarnings(sort(names(x$default_aes()))))
    }
    if (length(def_aes) == 0) {
        return(paste("\\strong{", sort(x$required_aes), "}", 
            sep = ""))
    }
    return(c(paste("\\strong{", sort(x$required_aes), "}", sep = ""), 
        sort(def_aes)))
}


## altered from same function from ggplot2
rd_aesthetics <- function(name, geom) {
    aes <- aesthetics(geom)
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


##' Show shapes
##'
##' A quick and dirty way to show shapes.
##'
##' @export
##' @param shapes A numeric or character vector of shapes. See
##' \code{\link{par}}.
##' @param labels Include the plotting character value of the symbol.
##' @seealso \code{\link[scales]{show_col}}, \code{\link{show_linetypes}}
##'
##' @examples
##' library(scales)
##' show_shapes(shape_pal()(5))
##' show_shapes(shape_pal()(3), labels=TRUE)
##'
show_shapes <- function(shapes, labels=TRUE) {
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
            points(i, j, pch=shapes[j, i])
            if (labels) {
                text(i, j, shapes[j, i], pos=1, col="gray70")
            }
        }
    }
}

##' Show linetypes
##'
##' A quick and dirty way to show linetypes.
##'
##' @export
##' @param linetypes A character vector of linetypes. See
##' \code{\link{par}}.
##' @param labels Label each line with its linetype (lty) value.
##'
##' @seealso \code{\link[scales]{show_col}}, \code{\link{show_linetypes}}
##'
##' @examples
##' library(scales)
##' show_linetypes(linetype_pal()(3))
##' show_linetypes(linetype_pal()(3), labels=TRUE)
show_linetypes <- function(linetypes, labels=TRUE) {
    n <- length(linetypes)
    plot(0, 0, xlim=c(0, 1), ylim=c(n, 1),
         type="n", xlab="", ylab="", axes=FALSE)
    for (i in seq_along(linetypes)) {
        abline(h=i, lty=linetypes[i])
    }
    if (labels) {
        axis(side=2, at=seq_len(n), tick=FALSE, labels=linetypes, las=2)
    } else {
        axis(side=2, at=seq_len(n), tick=FALSE, labels=seq_len(n), las=2)
    }
}


charopts <- function(x) {
  paste(sprintf("\\code{\"%s\"}", x), collapse=", ")
}

