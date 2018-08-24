#' Show shapes
#'
#' A quick and dirty way to show shapes.
#'
#' @export
#' @param shapes A numeric or character vector of shapes. See
#'   \code{\link[graphics]{par}()}.
#' @param labels Include the plotting character value of the symbol.
#' @seealso \code{\link[scales]{show_col}()}, \code{\link{show_linetypes}()}
#' @return This function called for the side effect of creating a plot.
#'   It returns \code{shapes}.
#' @example inst/examples/ex-show_shapes.R
show_shapes <- function(shapes, labels = TRUE) {
  n <- length(shapes)
  ncol <- ceiling(sqrt(n))
  nrow <- ceiling(n / ncol)
  x <- c(shapes, rep(NA, nrow * ncol - length(shapes)))
  x <- matrix(x, ncol = ncol, byrow = TRUE)
  x <- x[nrow(x):1, ]
  plot(0, 0, xlim = c(1, ncol(x)), ylim = c(1, nrow(x)), type = "n",
       xlab = "", ylab = "", axes = FALSE)
  for (i in seq_len(ncol(x))) {
    for (j in seq_len(nrow(x))) {
      points(i, j, pch = x[j, i])
      if (labels) {
        text(i, j, x[j, i], pos = 1, col = "gray70")
      }
    }
  }
  invisible(shapes)
}

#' Show linetypes
#'
#' A quick and dirty way to show linetypes.
#'
#' @export
#' @param linetypes A character vector of linetypes. See
#' \code{\link{par}()}.
#' @param labels Label each line with its linetype (lty) value.
#'
#' @seealso \code{\link[scales]{show_col}()}, \code{\link{show_linetypes}()}
#'
#' @example inst/examples/ex-show_linetypes.R
#' @return This function called for the side effect of creating a plot.
#'   It returns \code{linetypes}.
#' @importFrom graphics plot
show_linetypes <- function(linetypes, labels = TRUE) {
  n <- length(linetypes)
  plot(0, 0, xlim = c(0, 1), ylim = c(n, 1), type = "n", xlab = "",
       ylab = "", axes = FALSE)
  for (i in seq_along(linetypes)) {
    abline(h = i, lty = linetypes[i])
  }
  if (labels) {
    axis(side = 2, at = seq_len(n), tick = FALSE, labels = linetypes, las = 2)
  } else {
    axis(side = 2, at = seq_len(n), tick = FALSE, labels = seq_len(n), las = 2)
  }
  invisible(linetypes)
}
