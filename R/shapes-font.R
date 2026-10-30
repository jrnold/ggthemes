#' A font whose shapes are drawn at a common size
#'
#' The shape palettes made with `unicode = TRUE` draw each shape by asking the
#' device font for a Unicode character. Fonts draw those characters at unrelated
#' sizes, so a circle, a triangle and a plus sign from one font can differ by
#' a factor of two in area, and a font may not have the character at all.
#' `shapes_font()` registers a font that ships with ggthemes and contains the
#' geometric shapes, arrows, signs and marks used by the palettes, at the same
#' Unicode characters, so the same palettes draw with comparable sizes.
#'
#' # Size
#'
#' Each glyph is scaled until the convex hull of its outline has the area of
#' one reference circle. That keeps hollow, filled and rotated shapes
#' comparable, and it is the convention R's own `pch` symbols follow (circle,
#' square, diamond and triangle have equal area). Stroke widths are fixed. The
#' exclamation mark is too narrow to reach the reference area without outgrowing
#' the em box, so it is drawn smaller.
#'
#' # Coverage
#'
#' The font covers every shape the `unicode = TRUE` palettes draw, so they need
#' no other font: [calc_shape_pal()], [cleveland_shape_pal()],
#' [stata_shape_pal()] and [tableau_shape_pal()]. It also covers the Tableau
#' `"kpi"`, `"arrows"` and `"thin-arrows"` palettes and the sign shapes of
#' `"gender"` (see [tableau_shape_pal()]). It does not cover the pictograph
#' shapes: the Tableau `"weather"` and `"bug-tracking"` palettes and the
#' restroom signs of `"gender"`. Those characters still come from the
#' device font. Palettes with no `unicode` argument, such as
#' [tremmel_shape_pal()], use base `pch` symbols and need no font.
#'
#' # Using the font
#'
#' The font must be set on the device font family, because `geom_point()` does
#' not take a `family`. With a graphics device that reads fonts through
#' \pkg{systemfonts}, such as \pkg{ragg} or \pkg{svglite}, set the family on a
#' grid viewport around the plot:
#'
#' ```r
#' family <- shapes_font()
#' p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
#'   geom_point() +
#'   scale_shape_tableau(unicode = TRUE)
#' print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
#' ```
#'
#' Call `shapes_font()` before building the scale. A palette made with
#' `unicode = TRUE` warns when the device's default font lacks its shapes, and
#' it cannot see a family set on a viewport later. Once the font is registered,
#' it warns only about shapes this font does not have.
#'
#' `ggsave()` draws the plot without that viewport, so the font does not apply
#' through it; draw the plot to the device yourself, as above.
#'
#' Devices that look fonts up themselves (`pdf()`, and `png()` with the cairo
#' type) do not see fonts registered this way; install
#' `system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes")` on the
#' system to use the font there.
#'
#' The font is original work distributed under the same license as the package.
#' It is built by `data-raw/shapes-font/build.py`.
#'
#' @return The font family name, `"ggthemes shapes"`, to pass as a `fontfamily`.
#'   The font is registered with \pkg{systemfonts} as a side effect.
#' @family shapes
#' @seealso [tableau_shape_pal()] and [cleveland_shape_pal()] for palettes made
#'   with `unicode = TRUE`.
#' @export
#' @examplesIf rlang::is_installed(c("systemfonts", "ragg")) && interactive()
#' library("ggplot2")
#' family <- shapes_font()
#' p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
#'   geom_point(size = 4) +
#'   scale_shape_tableau(unicode = TRUE)
#' png_file <- tempfile(fileext = ".png")
#' ragg::agg_png(png_file, width = 480, height = 360)
#' print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
#' dev.off()
shapes_font <- function() {
  path <- shapes_font_path()
  if (!nzchar(path)) {
    cli::cli_abort(c(
      "Can't find the shapes font in the installed {.pkg ggthemes}.",
      "x" = "{.file fonts/ggthemes-shapes.ttf} is missing from the package directory.",
      "i" = "Reinstall {.pkg ggthemes}."
    ))
  }
  check_installed("systemfonts", reason = "to register the shapes font.")
  systemfonts::register_font(name = shapes_font_family, plain = path)
  shapes_font_family
}

shapes_font_family <- "ggthemes shapes"

shapes_font_path <- function() {
  system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes")
}

shapes_font_registered <- function() {
  shapes_font_family %in% systemfonts::registry_fonts()[["family"]]
}
