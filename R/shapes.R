# nolint start
#' Shape palettes from Cleveland's "Elements of Graphing Data"
#'
#' Two sets of five plotting symbols from Figure 3.70 of Cleveland (1985): one
#' for data with little overlap and one for data where overlap causes problems.
#' Use each set from the left: the first two symbols for two categories, the
#' first three for three, and so on.
#'
#' @param overlap If `TRUE` (the default), use the symbols for data where
#'   overlap causes problems: an open circle, a plus sign, an S, a triangle and a U.
#'   If `FALSE`, use the symbols for data with little overlap: a solid circle,
#'   an open circle, a circle with a vertical line, a heavy ring, and a circled
#'   dot.
#' @param unicode If `TRUE`, return pch codes derived from Unicode glyphs, which
#'   exist for every shape of the palette. They are drawn by the device font, so
#'   they render as blank boxes in a font without coverage and at unrelated sizes
#'   in most fonts; the font from [register_shapes_font()] has the shapes of
#'   this palette at a common size. If `FALSE`, return base pch codes, which every font can
#'   draw but which exist only for some shapes. The default depends on the
#'   palette.
#' @param edition Which edition of the book to take the symbols from. One of:
#'   - `"1985"` (the default): the first edition, Figure 3.70.
#'   - `"1994"`: the revised (second) edition.
#'
#' @details
#' The symbols for overlapping data are curves and lines with no solid parts, so
#' that points drawn on top of each other keep their identity. All five have a
#' base pch code (the letters are drawn as characters), so with
#' `unicode = FALSE` they need no special font.
#'
#' The two editions draw the sets differently. `edition = "1985"` has, for
#' overlapping data, an open circle, plus sign, S, triangle and U, and, for
#' little overlap, a solid circle, open circle, circle with a vertical line,
#' heavy ring and circled dot. `edition = "1994"` has an open circle, plus
#' sign, `<`, S and W for overlapping data, and an open circle, solid circle,
#' heavy ring, circle with a vertical line and circled dot for little overlap.
#'
#' The symbols for little overlap vary how much of the circle is filled in.
#' Only the solid and the open circle have a base pch code, so with
#' `unicode = FALSE`, `cleveland_shape_pal(overlap = FALSE)` supports two
#' values; `unicode = TRUE` draws all five. The circle with a vertical line
#' (U+233D), the heavy ring (U+2B58) and the circled dot (U+2299) are missing
#' from many fonts and drawn at unrelated sizes in the rest, and even the plain
#' circles are drawn larger or smaller than base pch circles depending on the
#' font. The font that ships with ggthemes has them all at a common size; see
#' [register_shapes_font()] for how to use it.
#'
#' @section Default of `unicode`:
#' `r lifecycle::badge("deprecated")`
#'
#' `unicode` defaults to `FALSE`, as for the other shape palettes, but that
#' default will change to `TRUE` in ggthemes 9.0.0, so that both sets draw all
#' five symbols. Leaving `unicode` unset is deprecated; set it to keep the
#' current behaviour or to adopt the new one.
#'
#' @example inst/examples/ex-cleveland_shape_pal.R
#' @references
#' Cleveland WS (1985). *The Elements of Graphing Data*. Wadsworth Advanced
#' Books and Software, Monterey, CA. Figure 3.70, p. 196.
#'
#' Cleveland WS (1994). *The Elements of Graphing Data*. Revised Edition. Hobart
#' Press, Summit, NJ, pp. 154-164, 234-239.
#'
#' Cleveland WS, McGill R (1984). "The Many Faces of a Scatterplot." *Journal
#' of the American Statistical Association* 79: 807-822. The book cites this
#' paper for the evidence on discriminating circles by fill.
#'
#' @family shapes
#' @returns A palette function. It takes the number of shapes `n` and returns an integer vector of `n`
#'   shape (`pch`) codes, and can be used as the `palette` argument of
#'   [ggplot2::discrete_scale()].
#' @export
# nolint end
cleveland_shape_pal <- function(overlap = TRUE, unicode = NULL, edition = c("1985", "1994")) {
  edition <- rlang::arg_match(edition)
  unicode <- cleveland_unicode(unicode, "cleveland_shape_pal", user_env = rlang::caller_env())
  tables <- if (edition == "1985") {
    ggthemes::ggthemes_data$shapes$cleveland
  } else {
    ggthemes::ggthemes_data$shapes$cleveland_1994
  }
  shapes <- if (overlap[[1]]) tables$overlap else tables$default
  new_shape_pal(shapes, unicode = unicode)
}

#' Shape scales from Cleveland "Elements of Graphing Data"
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams cleveland_shape_pal
#' @returns A ggplot2 scale object.
#' @export
#'
#' @family shapes
#' @seealso [cleveland_shape_pal()] for a description of the palette.
#' @references
#' Cleveland WS. The Elements of Graphing Data. Revised Edition.
#' Hobart Press, Summit, NJ, 1994, pp. 154-164, 234-239.
#'
#' @example inst/examples/ex-scale_shape_cleveland.R
scale_shape_cleveland <- function(overlap = TRUE, ..., unicode = NULL, edition = c("1985", "1994")) {
  edition <- rlang::arg_match(edition)
  unicode <- cleveland_unicode(unicode, "scale_shape_cleveland", user_env = rlang::caller_env())
  discrete_scale(
    "shape",
    palette = cleveland_shape_pal(overlap, unicode = unicode, edition = edition),
    ...
  )
}

# The default is resolved here, rather than in the palette alone, so that a
# call to the scale warns as the scale: lifecycle only shows a soft
# deprecation to the code that called the function directly.
cleveland_unicode <- function(unicode, fn, user_env) {
  if (!is.null(unicode)) {
    return(unicode)
  }
  deprecate_soft(
    "8.0.0",
    I(sprintf("Calling `%s()` without `unicode`", fn)),
    details = c(
      "i" = "`unicode` defaults to `FALSE`, and will default to `TRUE` in ggthemes 9.0.0.",
      "i" = "Set `unicode = FALSE` to keep base pch shapes, or `unicode = TRUE` to draw all five symbols."
    ),
    user_env = user_env
  )
  FALSE
}

#' Filled Circle Shape palette (discrete)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function was deprecated because unicode glyphs used for the circles
#' vary in size, making them unusable for plotting.
#'
#' Shape palette with circles varying by amount of fill. This uses
#' the set of 3 circle fill values in Lewandowsky and Spence (1989):
#' solid, hollow, half-filled, with two additional fill amounts:
#' three-quarters, and one-quarter.
#'
#' This palette supports up to five values.
#'
#' @references
#' Lewandowsky, Stephan and Ian Spence (1989)
#' "Discriminating Strata in Scatterplots", Journal of
#' the American Statistical Association, <https://www.jstor.org/stable/2289649>
#' @family shapes
#' @importFrom lifecycle deprecate_warn
#' @returns A palette function. It takes the number of shapes `n` and returns an integer vector of `n`
#'   shape (`pch`) codes, and can be used as the `palette` argument of
#'   [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-circlefill_shape_pal.R
circlefill_shape_pal <- function() {
  deprecate_warn("5.0.0", "circlefill_shape_pal()")
  # `pch_unicode`, not `pch`: this palette grades circles by fill fraction,
  # which base pch cannot express at all, so it has no font-independent form.
  new_shape_pal(
    ggthemes::ggthemes_data[["shapes"]][["circlefill"]],
    unicode = TRUE
  )
}

#' Filled circle shape scale (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This scale has no direct replacement. For circles that vary by amount of
#' fill, use `scale_shape_tableau(palette = "proportions", unicode = TRUE)`;
#' see [scale_shape_tableau()].
#'
#' @returns A ggplot2 scale object.
#' @export
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shapes
#' @importFrom lifecycle deprecate_warn
#' @seealso
#' [circlefill_shape_pal()] for a description of the palette.
#' @example inst/examples/ex-scale_shape_circlefill.R
scale_shape_circlefill <- function(...) {
  deprecate_warn("5.0.0", "scale_shape_circlefill()")
  discrete_scale("shape", palette = circlefill_shape_pal(), ...)
}

#' Shape palette from Tremmel (1995) (discrete)
#'
#' Based on experiments Tremmel (1995) suggests the following shape palettes:
#'
#' If two symbols, then use a solid circle and plus sign.
#'
#' If three symbols, then use a solid circle, empty circle, and an
#' empty triangle. However, that set of symbols does not satisfy the
#' requirement that each symbol should differ from the other symbols
#' in the same feature dimension. A set of three symbols that
#' satisfies this is a circle (curvature), plus sign (number of
#' terminators), triangle (line orientation).
#'
#' This palette supports up to three values.
#' If more than three groups of data, then separate the groups into
#' different plots.
#'
#' @param overlap Use an empty circle instead of a solid circle when
#' `n == 2`.
#' @param alt If `TRUE`, then when `n == 3`,
#'   use a solid circle, plus sign and
#'   empty triangle. Otherwise use a solid circle, empty circle, and empty
#'   triangle. Defaults to `FALSE`, the triple Tremmel's Experiment 1
#'   actually measured; the `TRUE` triple is argued on feature-dimension
#'   grounds that Tremmel flags as not directly supported by the experiments.
#' @family shapes
#' @references
#' Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in Scatterplots"
#' Journal of Computational and Graphical Statistics,
#' <https://www.jstor.org/stable/1390760>
#' @returns A palette function. It takes the number of shapes `n` and returns an integer vector of `n`
#'   shape (`pch`) codes, and can be used as the `palette` argument of
#'   [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-tremmel_shape_pal.R
tremmel_shape_pal <- function(overlap = FALSE, alt = FALSE) {
  max_n <- 3L
  palettes <- ggthemes::ggthemes_data$shapes$tremmel
  f <- function(n) {
    check_pal_n(n, max_n)
    if (n == 1) {
      palettes[["1"]]$pch
    } else if (n == 2) {
      if (overlap[[1]]) {
        palettes[["2-overlap"]]$pch
      } else {
        palettes[["2"]]$pch
      }
    } else if (n >= 3) {
      out <- rep(NA_integer_, n)
      out[1:3] <- if (alt) {
        palettes[["3-alternate"]]$pch
      } else {
        palettes[["3"]]$pch
      }
      out
    }
  }
  attr(f, "max_n") <- max_n
  f
}

#' Shape scales from Tremmel (1995)
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams tremmel_shape_pal
#'
#' @seealso [tremmel_shape_pal()] for a description of the palette.
#' @example inst/examples/ex-scale_shape_tremmel.R
#' @family shapes
#' @returns A ggplot2 scale object.
#' @export
scale_shape_tremmel <- function(overlap = FALSE, ..., alt = FALSE) {
  check_dots_named(...)
  discrete_scale(
    "shape",
    palette = tremmel_shape_pal(
      overlap = overlap,
      alt = alt
    ),
    ...
  )
}
