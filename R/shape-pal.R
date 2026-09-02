#' Build a shape palette from a shape table
#'
#' The shared constructor behind every ggthemes shape palette. A shape table
#' carries two pch columns: `pch`, the font-independent base pch, which is `NA`
#' where the shape has no base equivalent, and `pch_unicode`, the negative
#' glyph pch that asks the device font for a codepoint.
#'
#' Truncation needs no special case. `NA` in `pch` *is* the "no font-independent
#' equivalent" signal, so the safe `max_n` is just the number of shapes that
#' survive the mapping.
#'
#' @param shapes A shape table from `ggthemes_data`.
#' @param unicode If `TRUE`, return the Unicode glyph pch instead of base pch.
#' @noRd
new_shape_pal <- function(shapes, unicode = FALSE) {
  values <- shapes[[if (unicode) "pch_unicode" else "pch"]]
  values <- unname(values[!is.na(values)])
  max_n <- length(values)
  if (unicode) {
    warn_shape_font(shapes)
  }
  f <- function(n) {
    check_pal_n(n, max_n)
    values[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

# Font-coverage probes, keyed by font family and the characters probed. Probing
# costs a font match plus a glyph lookup per character, and a palette may be
# constructed more than once while a single plot is drawn.
shape_font_cache <- new.env(parent = emptyenv())

#' The font family a negative pch will be looked up in
#'
#' `""` means the device default. It is also the answer when no device is open,
#' which is common: a palette is usually constructed before anything is drawn.
#' Querying `grid` would open the default device as a side effect, so the null
#' device is short-circuited instead.
#' @noRd
current_font_family <- function() {
  if (grDevices::dev.cur() == 1L) {
    return("")
  }
  grid::get.gpar("fontfamily")[["fontfamily"]]
}

#' Warn when the device font cannot draw a palette's glyphs
#'
#' R draws a negative pch by asking the font for that codepoint. A font that
#' lacks the glyph renders a blank box with no error, so a plot can be silently
#' wrong. `systemfonts::glyph_info()` reports glyph index 0 for a codepoint the
#' font does not cover, which is a direct measurement rather than the locale
#' guess it replaces.
#'
#' The check runs at palette construction, which usually precedes any device
#' being opened. In that case it probes the default device family: the right
#' guess, but a guess.
#' @noRd
warn_shape_font <- function(shapes) {
  if (!rlang::is_installed("systemfonts")) {
    return(warn_unicode_pch(shapes[["pch_unicode"]]))
  }
  characters <- shapes[["character"]]
  family <- current_font_family()
  key <- paste0(family, "\r", paste(characters, collapse = ""))
  missing <- shape_font_cache[[key]]
  if (is.null(missing)) {
    missing <- missing_glyphs(characters, family)
    shape_font_cache[[key]] <- missing
  }
  if (!length(missing)) {
    return(invisible(NULL))
  }
  cli::cli_warn(c(
    paste0(
      "The current device font ({.val {family}}) lacks glyphs for ",
      "{length(missing)} of {length(characters)} shapes in this palette: ",
      "{paste(missing, collapse = ' ')}"
    ),
    "i" = "These will render as blank boxes.",
    "i" = paste0(
      "Try a font with wider symbol coverage, e.g. ",
      "{.code ragg::agg_png(family = \"DejaVu Sans\")}."
    ),
    "i" = "Or use {.code unicode = FALSE} for font-independent base pch shapes."
  ))
}

#' Characters the font does not cover
#'
#' `systemfonts::glyph_info()` returns glyph index 0 for an uncovered codepoint.
#' @noRd
missing_glyphs <- function(characters, family) {
  font <- systemfonts::match_fonts(family)
  info <- systemfonts::glyph_info(
    characters,
    path = font[["path"]],
    index = font[["index"]]
  )
  characters[is.na(info[["index"]]) | info[["index"]] == 0]
}
