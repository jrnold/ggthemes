#' Magic Number: Points to Millimeters
#' @noRd
PT_TO_MM <- 0.352778 # nolint: object_name_linter

charopts <- function(x) {
  paste(sprintf("\\code{\"%s\"}", x), collapse = ", ")
}

# copied from ggplot2
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

# copied from ggplot2
ggname <- function(prefix, grob) {
  grob$name <- grid::grobName(grob, prefix)
  grob
}

# rescaler for continuous_scale() that maps `mid` to the midpoint of `to`,
# for use with palettes that aren't ggplot2::scale_*_gradient2()'s 3-stop
# low/mid/high palette (e.g. multi-stop diverging gradients)
mid_rescaler <- function(mid) {
  function(x, to = c(0, 1), from = range(x, na.rm = TRUE)) {
    scales::rescale_mid(x, to, from, mid)
  }
}

rd_optlist <- function(x) {
  paste0("\\code{\"", as.character(x), "\"}", collapse = ", ")
}

check_pal_n <- function(n, max_n) {
  if (n > max_n) {
    warning(
      "This palette can handle a maximum of ",
      max_n,
      " values.",
      "You have supplied ",
      n,
      "."
    )
  } else if (n < 0) {
    stop("`n` must be a non-negative integer.")
  }
}

#' Extract colors from ggthemes data
#'
#' @param path A character vector of the path in \code{ggthemes_data}.
#' @param colors A character vector of color names.
#' @noRd
get_colors <- function(path, colors) {
  x <- dplyr::filter(ggthemes::ggthemes_data[[path]], .data$name %in% colors)
  x <- unname(x[["value"]])
}
