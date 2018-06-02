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
