#' Palette and theme data
#'
#' The `ggthemes` environment contains various values used in
#' themes and palettes. This is undocumented and subject to change.
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
#' `ggthemes_data$economist_2017` contains the colors of *The Economist
#' visual styleguide* (v1.2, 4 May 2017), one complete set per medium
#' (`print` and `web`): the ground, gridline, text, baseline, source and
#' accent colors used by [theme_economist_2017()], the categorical palettes
#' used by [economist_2017_pal()], and the equal-lightness ramps used by
#' [economist_2017_gradient_pal()]. The palettes and ramps are the same for
#' both media. `ggthemes_data$economist_2017$print$swatches` lists every
#' swatch of the guide's print chart palette: its name and group as the guide
#' gives them, the CMYK it specifies (`c`, `m`, `y`, `k`, in percent), and
#' that CMYK converted to sRGB through ISO Coated v2 (FOGRA39), relative
#' colorimetric with black-point compensation. The print colors are drawn
#' from these swatches, except the black text and source text, which convert
#' their K percentage directly. `ggthemes_data$economist_2017$web$swatches`
#' lists the hex swatches of the guide's web palette page, for reference.
#'
#' @format A `list` object.
#' @example inst/examples/ex-ggthemes_data.R
"ggthemes_data"
