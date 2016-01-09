#' Shape palette from Cleveland "Elements of Graphing Data" (discrete).
#'
#' Shape palettes for overlapping and non-overlapping points.
#'
#' @param overlap \code{logical} Use the scale for overlapping points?
#'
#' @note
#'
#' In the \emph{Elements of Graphing Data}, W.S. Cleveland suggests
#' two shape palettes for scatter plots: one for overlapping data and
#' another for non-overlapping data. The symbols for overlapping data
#' relies on pattern discrimination, while the symbols for
#' non-overlapping data vary the amount of fill. This palatte
#' attempts to create these palettes. However, I found that these
#' were hard to replicate. Using the R shapes and unicode fonts: the
#' symbols can vary in size, they are dependent of the fonts used,
#' and there does not exist a unicode symbol for a circle with a
#' vertical line. If someone can improve this palette, please let me
#' know.
#'
#' Following Tremmel (1995), I replace the circle with a vertical
#' line with an encircled plus sign.
#'
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, shape = factor(gear))) +
#'      facet_wrap(~am) +
#'      theme_bw()
#' # overlapping symbol palette
#' p + scale_shape_cleveland()
#' # non-overlapping symbol palette
#' p + scale_shape_cleveland(overlap=FALSE)
#'
#' @references
#' Cleveland WS. \emph{The Elements of Graphing Data}. Revised Edition. Hobart Press, Summit, NJ, 1994, pp. 154-164, 234-239.
#'
#' Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in Scatterplots", \emph{Journal of Computational and Graphical Statistics},
#' \url{http://www.jstor.org/stable/1390760}
#'
#' @family shapes
#' @export
cleveland_shape_pal <- function(overlap=TRUE) {
    function(n) {
        maxshapes <- 5
        if (n > maxshapes) {
            msg <- sprintf(paste("The shape palette can deal with a maximum of %d discrete ",
                                 "values because more than %d becomes difficult to discriminate; ",
                                 "you have ", n, ". Consider specifying shapes manually. if you ",
                                 "must have them.", sep = ""),
                           maxshapes, maxshapes)
            warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
        }
        if (overlap) {
        c(1, ## empty circle
          3, ## plus
          60, # <
          87, # S
          83  # W
          )[seq_len(n)]
        } else {
            c(1, ## empty circle
              19, ## solid circle
              10, ## encircled plus sign
              -0x2299, ##
              -0x229A ##
              )[seq_len(n)]
        }
    }
}

#' Shape scales from Cleveland "Elements of Graphing Data"
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams cleveland_shape_pal
#' @export
#'
#' @family shapes
#' @seealso \code{\link{cleveland_shape_pal}} for a description of the palette.
#' @references
#' Cleveland WS. The Elements of Graphing Data. Revised Edition. Hobart Press, Summit, NJ, 1994,
#' pp. 154-164, 234-239.
#'
scale_shape_cleveland <- function(overlap=TRUE, ...) {
    discrete_scale("shape", "cleveland", cleveland_shape_pal(overlap), ...)
}

#' Filled Circle Shape palette (discrete)
#'
#' Shape palette with circles varying by amount of fill. This uses
#' the set of 3 circle fill values in Lewandowsky and Spence (1989):
#' solid, hollow, half-filled, with two additional fill amounts:
#' three-quarters, and one-quarter.
#'
#'
#'
#' @references
#' Lewandowsky, Stephan and Ian Spence (1989)
#' "Discriminating Strata in Scatterplots", Journal of
#' the American Statistical Assocation, \url{http://www.jstor.org/stable/2289649}
#' @examples
#' library("ggplot2")
#' (ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
#'  + geom_point() + scale_shape_tremmel())
#' @family shapes
#' @export
circlefill_shape_pal <- function() {
    maxshapes <- 5
    types <- c(16, 1, -0x25D3, -0x25D5, -0x25D4)
    function (n) {
        if (n > maxshapes) {
            msg <- sprintf(paste("The shape palette can deal with a maximum of %d discrete ",
                                 "values because more than %d becomes difficult to discriminate; ",
                                 "you have ", n, ". Consider specifying shapes manually. if you ",
                                 "must have them.", sep = ""),
                           maxshapes, maxshapes)
            warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
        }
        types[seq_len(n)]
    }
}

#' Filled Circle Shape palette (discrete)
#'
#' @export
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shapes
#' @seealso
#' \code{\link{circlefill_shape_pal}} for a description of the palette.
scale_shape_circlefill <- function(...) {
    discrete_scale("shape", "circlefill", circlefill_shape_pal(), ...)
}

#' Shape palette from Tremmel (1995) (discrete)
#'
#' Based on experiments Tremmel (1995) suggests the following shape palettes:
#'
#' If two symbols, then use a solid circle and plus sign.
#'
#' If three symbols, then use a solid circle, empty circle, and an
#' empty triangle. However, that set of symbols does not satisfy the
#' requirement that each symbol should differ from the other symbols
#' in the same feature dimension. A set of three symbols that
#' satisfies this is a circle (curvature), plus sign (number of
#' terminators), triangle (line orientation).
#'
#' If more than three groups of data, then separate the groups into
#' different plots.
#'
#' @param overlap use an empty circle instead of a solid circle when
#' \code{n == 2}.
#' @param n3alt If \code{TRUE} then use a solid circle, plus sign and
#' empty triangle, else use a solid circle, empty circle, and empty
#' triangle.
#' @family shapes
#' @references
#' Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in Scatterplots"
#' Journal of Computational and Graphical Statistics,
#' \url{http://www.jstor.org/stable/1390760}
#' @export
tremmel_shape_pal <- function(overlap=FALSE, n3alt=TRUE) {
    maxshapes <- 3
    function (n) {
        if (n == 1)  {
            16 # solid circle
        } else if (n == 2) {
            c(ifelse(overlap, 1, 16), # hollow or solid circle
              3) # plus sign
        } else if (n == 3) {
            if (n3alt) {
                c(16, # solid circle,
                  3, # plus
                  2) # hollow triangle
            } else {
                c(16, # solid circle,
                  1, # hollow circle
                  2) # triangle
            }
        } else if (n > maxshapes) {
            msg <- sprintf(paste("The shape palette can deal with a maximum of %d discrete ",
                                 "values because more than %d becomes difficult to discriminate; ",
                                 "you have ", n, ". Consider specifying shapes manually. if you ",
                                 "must have them.", sep = ""),
                           maxshapes, maxshapes)
            warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
        }
    }
}

#' Shape scales from Tremmel (1995)
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams tremmel_shape_pal
#'
#'
#' @seealso \code{\link{tremmel_shape_pal}} for a description of the palette.
#' @examples
#' library("ggplot2")
#' (ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
#'  + geom_point() + scale_shape_tremmel())
#' (ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(cyl)))
#'  + geom_point() + scale_shape_tremmel(n3alt=FALSE))
#' (ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(am)))
#'  + geom_point() + scale_shape_tremmel())
#' (ggplot(mtcars, aes(x=mpg, y=hp, shape=factor(am)))
#'  + geom_point() + scale_shape_tremmel(overlap=TRUE))
#' @family shapes
#' @export
scale_shape_tremmel <- function(overlap=FALSE, n3alt=TRUE, ...) {
    discrete_scale("shape", "tremmel", tremmel_shape_pal(overlap=overlap, n3alt=n3alt), ...)
}
