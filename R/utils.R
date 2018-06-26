#' Magic Number: Points to Millimeters
#' @noRd
PT_TO_MM <- 0.352778

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

rd_optlist <- function(x) {
  paste0("\\code{\"", as.character(x), "\"}", collapse = ", ")
}

check_pal_n <- function(n, max_n) {
  if (n > max_n) {
    warning("This palette can handle a maximum of ", max_n, " values.",
            "You have supplied ", n, ".")
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
