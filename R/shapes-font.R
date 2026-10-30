#' Register a font that draws the shapes at a common size
#'
#' The shape palettes made with `unicode = TRUE` draw each shape by asking the
#' device font for a Unicode character. Fonts draw those characters at unrelated
#' sizes, so a circle, a triangle and a plus sign from one font can differ by
#' a factor of two in area, and a font may not have the character at all.
#' `register_shapes_font()` registers a font that ships with ggthemes and
#' contains the geometric shapes, arrows, signs and marks used by the palettes,
#' at the same Unicode characters, so the same palettes draw with comparable
#' sizes.
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
#' The simplest way is [geom_point_glyph()] in place of
#' [ggplot2::geom_point()]. It reads the font file itself, needs no font family
#' set anywhere, and works with `ggsave()`.
#'
#' With `geom_point()`, the font must be set on the device font family, because
#' `geom_point()` does not take a `family`. With a graphics device that reads
#' fonts through \pkg{systemfonts}, such as \pkg{ragg} or \pkg{svglite}, set
#' the family on a grid viewport around the plot:
#'
#' ```r
#' family <- register_shapes_font()
#' p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
#'   geom_point() +
#'   scale_shape_tableau(unicode = TRUE)
#' print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
#' ```
#'
#' A palette made with `unicode = TRUE` warns, when the plot is built, if the
#' device's default font lacks its shapes; it cannot see a family set on a
#' viewport. Once `register_shapes_font()` or `geom_point_glyph()` has been
#' called, it warns only about shapes this font does not have. That lasts until
#' ggthemes is unloaded, for example by restarting R or with
#' `unloadNamespace("ggthemes")`, since the setting lives in the package
#' namespace.
#'
#' ggthemes registers the font with \pkg{systemfonts} when it loads, if
#' \pkg{systemfonts} is installed, so the family name `"ggthemes shapes"` works
#' even before `register_shapes_font()` is called.
#'
#' `ggsave()` draws the plot without that viewport, so the font does not apply
#' through it; draw the plot to the device yourself, as above.
#'
#' Devices that look fonts up themselves (`pdf()`, and `png()` with the cairo
#' type) do not see fonts registered this way; install
#' `system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes")` on the
#' system to use the font there. A copy installed on the system is used as it
#' is: `register_shapes_font()` does not register the family a second time.
#'
#' The font is original work distributed under the same license as the package.
#' It is built by `data-raw/shapes-font/build.py`.
#'
#' @return The font family name, `"ggthemes shapes"`, to pass as a `fontfamily`.
#'   As side effects, the font is registered with \pkg{systemfonts} again, in
#'   case the registry was cleared, and the palettes stop warning about shapes
#'   the font has.
#' @family shapes
#' @seealso [tableau_shape_pal()] and [cleveland_shape_pal()] for palettes made
#'   with `unicode = TRUE`.
#' @export
#' @examplesIf rlang::is_installed(c("systemfonts", "ragg")) && interactive()
#' library("ggplot2")
#' family <- register_shapes_font()
#' p <- ggplot(mtcars, aes(mpg, hp, shape = factor(cyl))) +
#'   geom_point(size = 4) +
#'   scale_shape_tableau(unicode = TRUE)
#' png_file <- tempfile(fileext = ".png")
#' ragg::agg_png(png_file, width = 480, height = 360)
#' print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
#' dev.off()
register_shapes_font <- function() {
  path <- check_shapes_font_path()
  check_installed("systemfonts", reason = "to register the shapes font.")
  register_shapes_font_family(path)
  use_shapes_font()
  shapes_font_family
}

#' Embed the shapes font in a PDF file
#'
#' [grDevices::pdf()] draws the glyphs of [geom_point_glyph()] by referring to
#' the shapes font without embedding it, so the file shows the shapes only on a
#' system where the font is installed. `embed_shapes_font()` embeds the shapes
#' it uses, with Ghostscript through [grDevices::embedGlyphs()].
#'
#' Requires R 4.3 or later and Ghostscript (see [tools::find_gs_cmd()]). Only
#' files written by `pdf()` need it: \pkg{ragg} and the other raster devices
#' draw the glyphs into the image.
#'
#' @param file Path to a PDF file written by [grDevices::pdf()].
#' @param outfile Path to write the PDF with the font embedded. The default
#'   overwrites `file`.
#' @returns `outfile`, invisibly. It is `file` unless `outfile` is given, so the
#'   result is always the path of the PDF with the font embedded.
#' @family shapes
#' @seealso [register_shapes_font()] for the font itself.
#' @export
#' @examplesIf rlang::is_installed("systemfonts") && getRversion() >= "4.3.0" && nzchar(tools::find_gs_cmd())
#' library("ggplot2")
#' p <- ggplot(mtcars, aes(wt, mpg, shape = factor(gear))) +
#'   geom_point_glyph(size = 3) +
#'   scale_shape_cleveland(unicode = TRUE)
#' path <- tempfile(fileext = ".pdf")
#' ggsave(path, p, device = pdf, width = 5, height = 4)
#' embed_shapes_font(path)
embed_shapes_font <- function(file, outfile = file) {
  if (!rlang::is_string(file)) {
    cli::cli_abort("{.arg file} must be a single string, not {.obj_type_friendly {file}}.")
  }
  if (!file.exists(file)) {
    cli::cli_abort("Can't find the PDF file {.file {file}}.")
  }
  if (!rlang::is_string(outfile)) {
    cli::cli_abort("{.arg outfile} must be a single string, not {.obj_type_friendly {outfile}}.")
  }
  api <- glyph_api()
  embed <- get0("embedGlyphs", envir = asNamespace("grDevices"), inherits = FALSE)
  if (is.null(api) || is.null(embed)) {
    cli::cli_abort(c(
      "Can't embed glyphs in this version of R.",
      "i" = "Embedding glyphs needs R 4.3.0 or later; this is R {getRversion()}."
    ))
  }
  # Ghostscript embeds every font that the glyph information names, so one
  # glyph of the shapes font is enough to embed whatever the file uses.
  font <- api$font(check_shapes_font_path(), 0L, shapes_font_family, 400, "normal")
  glyphs <- api$info(
    id = 1L,
    x = 0,
    y = 0,
    font = 1L,
    size = 12,
    fontList = api$font_list(font),
    width = 0,
    height = 0,
    hAnchor = api$anchor(0, "left"),
    vAnchor = api$anchor(0, "bottom")
  )
  embed(file, glyphs, outfile = outfile)
  invisible(outfile)
}

shapes_font_family <- "ggthemes shapes"

shapes_font_path <- function() {
  system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes")
}

check_shapes_font_path <- function(call = rlang::caller_env()) {
  path <- shapes_font_path()
  if (!nzchar(path)) {
    cli::cli_abort(
      c(
        "Can't find the shapes font in the installed {.pkg ggthemes}.",
        "x" = "{.file fonts/ggthemes-shapes.ttf} is missing from the package directory.",
        "i" = "Reinstall {.pkg ggthemes}."
      ),
      call = call
    )
  }
  path
}

shapes_font_registered <- function() {
  shapes_font_family %in% systemfonts::registry_fonts()[["family"]]
}

# systemfonts refuses to register a family name an installed font already
# has, and the font file's own family is this name, so a user who installed
# the font, as the docs advise for `pdf()`, would otherwise get an error. The
# installed copy is found by name without registering.
register_shapes_font_family <- function(path) {
  if (!shapes_font_installed()) {
    systemfonts::register_font(name = shapes_font_family, plain = path)
  }
  invisible(path)
}

shapes_font_installed <- function() {
  shapes_font_family %in% systemfonts::system_fonts()[["family"]]
}

# Registering at load makes the family name resolvable without a call to
# `register_shapes_font()`, but must never stop the package from loading: the
# font is an optional extra and systemfonts is only suggested.
try_register_shapes_font <- function() {
  path <- shapes_font_path()
  if (!nzchar(path) || !requireNamespace("systemfonts", quietly = TRUE)) {
    return(invisible(FALSE))
  }
  registered <- tryCatch(
    {
      register_shapes_font_family(path)
      TRUE
    },
    error = function(e) FALSE
  )
  invisible(registered)
}

# Whether the user has asked for the font, by calling `register_shapes_font()`
# or `geom_point_glyph()`. It is never reset; it lasts until the namespace is
# unloaded. Registration at load can't stand in for this:
# `warn_shape_font()` uses it to skip the warning, and a font that is merely
# available says nothing about the font the plot will be drawn with.
shapes_font_state <- new.env(parent = emptyenv())

use_shapes_font <- function() {
  shapes_font_state[["in_use"]] <- TRUE
  invisible(TRUE)
}

shapes_font_in_use <- function() {
  isTRUE(shapes_font_state[["in_use"]])
}
