#' The symbolstyles `stata_shape_pal()` selects from Stata's catalogue
#'
#' Stata's shape table in `ggthemes_data` is the full 22-row catalogue, of
#' which the palette uses ten: from scheme s1mono, ignoring the small variants.
#' This vector is the single source of truth for which ten, and in what order.
#'
#' `data-raw/build.R` `source()`s this file rather than keeping its own copy,
#' for the same reason it sources `R/shape-names.R`. The build checks that no
#' two shapes in a palette share a pch, and for stata it must run that check
#' over these ten rather than the whole catalogue -- the catalogue legitimately
#' collapses `smcircle` onto the same pch as `circle`, because pch encodes
#' symbol identity and delegates size to the `size` aesthetic. A second copy of
#' the list would let the duplicate check run over a stale set and pass while
#' the palette emitted the same pch twice.
#' @noRd
stata_palette_shapes <- c(
  "circle",
  "diamond",
  "square",
  "triangle",
  "X",
  "plus",
  "circle_hollow",
  "diamond_hollow",
  "square_hollow",
  "triangle_hollow"
)
