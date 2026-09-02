#' Canonical shape names and their font-independent pch codes
#'
#' The single source of truth mapping a shape's canonical name to the base R
#' `pch` that draws it without consulting a font. `data-raw/build.R` `source()`s
#' this file to derive the `pch` column of every shape table in
#' `ggthemes_data`, so the package and the build script share one copy: a second
#' copy would only relocate the drift this table exists to eliminate.
#'
#' The names are ggplot2's own shape vocabulary (see its
#' `translate_shape_string()`), extended with names for the shapes ggthemes
#' needs that ggplot2 has none for. The set is closed — `build.R` aborts on any
#' name not listed here.
#'
#' `NA` means the shape has no font-independent equivalent. Such shapes are
#' dropped from a palette's default output and appear only under
#' `unicode = TRUE`; see `new_shape_pal()`.
#'
#' Solid shapes map to the solid family 15:18 rather than the fill-aware 21:25,
#' because `geom_point()` defaults `fill = NA` and a shape scale has to work
#' without a `fill` aesthetic mapped alongside it. The cost is that R draws
#' pch 18 visibly smaller than 15/16/17; there is no same-size solid diamond in
#' 0:20. Solid circles use `"circle small"` (16), not `"circle"` (19), because
#' 15/16/17/18 are R's size-matched family and 19 is visibly larger.
#' @noRd
shape_pch <- c(
  # ggplot2's vocabulary for pch 0:25.
  "square open" = 0L,
  "circle open" = 1L,
  "triangle open" = 2L,
  "plus" = 3L,
  "cross" = 4L,
  "diamond open" = 5L,
  "triangle down open" = 6L,
  "square cross" = 7L,
  "asterisk" = 8L,
  "diamond plus" = 9L,
  "circle plus" = 10L,
  "star" = 11L,
  "square plus" = 12L,
  "circle cross" = 13L,
  "square triangle" = 14L,
  "square" = 15L,
  "circle small" = 16L,
  "triangle" = 17L,
  "diamond" = 18L,
  "circle" = 19L,
  "bullet" = 20L,
  "circle filled" = 21L,
  "square filled" = 22L,
  "diamond filled" = 23L,
  "triangle filled" = 24L,
  "triangle down filled" = 25L,

  # pch 32:127 draw the ASCII character of that codepoint, which every font
  # covers.
  "exclamation mark" = 33L,
  "hyphen" = 45L,
  "less-than" = 60L,
  "letter S" = 83L,

  # No font-independent equivalent. R has no solid down/left/right triangle in
  # 0:20, no open left/right triangle, no partially filled circle, and nothing
  # for the dingbats and pictographs some source products use.
  "triangle down" = NA_integer_,
  "triangle left" = NA_integer_,
  "triangle right" = NA_integer_,
  "triangle left open" = NA_integer_,
  "triangle right open" = NA_integer_,
  "circle quarter filled" = NA_integer_,
  "circle half filled" = NA_integer_,
  "circle three-quarter filled" = NA_integer_,
  "circle dot" = NA_integer_,
  "circle ring" = NA_integer_,
  "bowtie" = NA_integer_,
  "hourglass" = NA_integer_,
  "four pointed star" = NA_integer_,
  "star filled" = NA_integer_,
  "pentagon" = NA_integer_,
  "hexagon" = NA_integer_,
  "check mark" = NA_integer_,
  "em dash" = NA_integer_,
  "blank" = NA_integer_,
  # Emoji and pictographs, which have no geometric shape identity to name. The
  # Unicode `name` column documents the individual character; there is no pch
  # for it to drift against. Used only by the Tableau pictograph palettes,
  # which no exported palette function reaches.
  "pictograph" = NA_integer_
)
