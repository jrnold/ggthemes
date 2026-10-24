#' Palette and theme data
#'
#' `ggthemes_data` is a list of the colors, shapes, and other values used in
#' the themes and palettes of this package. Its structure is internal and
#' subject to change.
#'
#' `ggthemes_data$stata$colors$names` spans both generations of Stata's
#' named colors: the classic set plus the `gs0`--`gs16` gray scale,
#' and the `stc1`--`stc15` colors added in Stata 18. See
#' [stata_pal()].
#'
#' Colors, shapes and linetypes are stored with the theme they belong to. The
#' [Package data](https://jrnold.github.io/ggthemes/articles/data.html)
#' article on the package website draws every one of them. `ggthemes_data`
#' contains no fonts: themes set their typefaces in code.
#'
#' @format A `list` object.
#' @example inst/examples/ex-ggthemes_data.R
"ggthemes_data"
