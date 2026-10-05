#' Show shapes
#'
#' A quick and dirty way to show shapes.
#'
#' @export
#' @param shapes A numeric or character vector of shapes. See
#'   [graphics::par()].
#' @param labels If `TRUE` (the default), label each symbol with its plotting
#'   character value.
#' @seealso [scales::show_col()], [show_linetypes()]
#' @return Called for its side effect of creating a plot; returns `shapes`
#'   invisibly.
#' @example inst/examples/ex-show_shapes.R
show_shapes <- function(shapes, labels = TRUE) {
  n <- length(shapes)
  ncol <- ceiling(sqrt(n))
  nrow <- ceiling(n / ncol)
  x <- c(shapes, rep(NA, nrow * ncol - length(shapes)))
  x <- matrix(x, ncol = ncol, byrow = TRUE)
  x <- x[rev(seq_len(nrow(x))), ]
  plot(0, 0, xlim = c(1, ncol(x)), ylim = c(1, nrow(x)), type = "n", xlab = "", ylab = "", axes = FALSE)
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
#' [graphics::par()].
#' @param labels If `TRUE` (the default), label each line with its linetype
#'   (`lty`) value.
#'
#' @seealso [scales::show_col()], [show_shapes()]
#'
#' @example inst/examples/ex-show_linetypes.R
#' @return Called for its side effect of creating a plot; returns `linetypes`
#'   invisibly.
#' @importFrom graphics plot
show_linetypes <- function(linetypes, labels = TRUE) {
  n <- length(linetypes)
  plot(0, 0, xlim = c(0, 1), ylim = c(n, 1), type = "n", xlab = "", ylab = "", axes = FALSE)
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
