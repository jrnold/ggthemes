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
    cli::cli_warn(c(
      "This shape palette uses pch codes derived from Unicode symbols, and your R session's locale is not UTF-8.",
      "i" = "Rendering may fail with a low-level error (e.g. \"conversion failure ... in 'mbcsToSbcs'\").",
      "i" = "Try a UTF-8 locale, or a Cairo-based graphics device (e.g. cairo_pdf(), agg_png())."
    ))
  }
}

# `call` is forwarded so the error names the palette the caller invoked rather
# than this helper.
check_pal_n_negative <- function(n, call = rlang::caller_env()) {
  if (n < 0) {
    cli::cli_abort("{.arg n} must be a non-negative integer, not {n}.", call = call)
  }
}

check_pal_n <- function(n, max_n) {
  check_pal_n_negative(n, call = rlang::caller_env())
  if (n > max_n) {
    cli::cli_warn("This palette can handle a maximum of {max_n} values. You have supplied {n}.")
  }
}

#' `scales::manual_pal()` with the package's own check on `n`
#'
#' `manual_pal()` selects its values with `seq_len(n)`, which fails for a
#' negative `n` with "argument must be coercible to non-negative integer" --- a
#' message that names nothing the caller passed. Palettes written around
#' `check_pal_n()` already reject a negative `n` by naming the argument, so
#' wrap `manual_pal()` to report the same thing. The maximum-`n` warning is
#' left to `manual_pal()`.
#'
#' @noRd
manual_pal_checked <- function(values, type = NULL) {
  f <- manual_pal(values, type = type)
  fun <- function(n) {
    check_pal_n_negative(n)
    f(n)
  }
  scales::new_discrete_palette(fun, attr(f, "type"), attr(f, "nlevels"))
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
