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

rd_optlist <- function(x) {
  paste0("\\code{\"", as.character(x), "\"}", collapse = ", ")
}

#' Warn about shape palettes using pch codes derived from Unicode symbols
#'
#' Some shape palettes use pch codes generated from Unicode glyphs (see
#' `data-raw/build.R`'s `utf_8_to_pch()`), identifiable as pch < -255 (the
#' base R negative-pch encoding). These can fail to render with a
#' low-level, hard-to-diagnose error (e.g. "conversion failure ... in
#' 'mbcsToSbcs'") on a non-UTF-8 locale, or with a font/device that lacks
#' the glyph. Warn early with an actionable message instead.
#' @noRd
warn_unicode_pch <- function(pch) {
  if (any(pch < -255, na.rm = TRUE) && !isTRUE(l10n_info()[["UTF-8"]])) {
    warning(
      "This shape palette uses pch codes derived from Unicode symbols, ",
      "and your R session's locale is not UTF-8. Rendering may fail with ",
      "a low-level error (e.g. \"conversion failure ... in 'mbcsToSbcs'\"). ",
      "Try a UTF-8 locale, or a Cairo-based graphics device ",
      "(e.g. grDevices::cairo_pdf(), ragg::agg_png())."
    )
  }
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
