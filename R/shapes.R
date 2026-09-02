# nolint start
#' Shape palette from Cleveland "Elements of Graphing Data" (discrete).
#'
#' Shape palettes for overlapping and non-overlapping points.
#'
#' @param overlap \code{logical} Use the scale for overlapping points?
#' @param unicode If \code{TRUE}, return pch codes derived from Unicode
#'   glyphs, as this palette did before ggthemes 6.1.0. Glyph shapes are drawn
#'   by the device font, so they render as blank boxes in a font without
#'   coverage; the default returns base pch codes, which every font can draw.
#'
#' @note
#'
#' In the \emph{Elements of Graphing Data}, W.S. Cleveland suggests
#' two shape palettes for scatter plots: one for overlapping data and
#' another for non-overlapping data. The symbols for overlapping data
#' rely on pattern discrimination, while the symbols for
#' non-overlapping data vary the amount of fill.
#'
#' Following Tremmel (1995), the circle with a vertical line is replaced by
#' an encircled plus sign.
#'
#' \code{cleveland_shape_pal(overlap = TRUE)} supports four values on either
#' branch.
#'
#' \code{cleveland_shape_pal(overlap = FALSE)} supports three values by
#' default and five with \code{unicode = TRUE}. Its five source symbols encode
#' \emph{fill fraction}, which base pch cannot express, so the two
#' partially filled circles are dropped rather than approximated by a
#' different shape. To encode a proportion, map \code{alpha} or \code{fill}
#' instead; to restore the five glyphs, use \code{unicode = TRUE} with a font
#' that covers Mathematical Operators, such as STIX Two Text.
#'
#' The truncation is arguably an improvement. Tremmel (1995) Experiment 2
#' tested exactly this five-symbol set and found the fill-graded circles the
#' worst performers measured, with the encircled plus and encircled dot the
#' slowest pair and the one producing the most errors. The three shapes that
#' survive are the better-separating subset.
#'
#' @example inst/examples/ex-cleveland_shape_pal.R
#' @references
#' Cleveland WS. \emph{The Elements of Graphing Data}. Revised Edition. Hobart Press, Summit, NJ, 1994, pp. 154-164, 234-239.
#'
#' Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in Scatterplots", \emph{Journal of Computational and Graphical Statistics},
#' \url{https://www.jstor.org/stable/1390760}
#'
#' @family shapes
#' @export
# nolint end
cleveland_shape_pal <- function(overlap = TRUE, unicode = FALSE) {
  shapes <- if (overlap[[1]]) {
    ggthemes::ggthemes_data$shapes$cleveland$overlap
  } else {
    ggthemes::ggthemes_data$shapes$cleveland$default
  }
  new_shape_pal(shapes, unicode = unicode)
}

#' Shape scales from Cleveland "Elements of Graphing Data"
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @inheritParams cleveland_shape_pal
#' @export
#'
#' @family shapes
#' @seealso \code{\link{cleveland_shape_pal}()} for a description of the palette.
#' @references
#' Cleveland WS. The Elements of Graphing Data. Revised Edition.
#' Hobart Press, Summit, NJ, 1994, pp. 154-164, 234-239.
#'
scale_shape_cleveland <- function(overlap = TRUE, ..., unicode = FALSE) {
  discrete_scale(
    "shape",
    palette = cleveland_shape_pal(overlap, unicode = unicode),
    ...
  )
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
#' the American Statistical Association, \url{https://www.jstor.org/stable/2289649}
#' @family shapes
#' @importFrom lifecycle deprecate_warn
#' @export
circlefill_shape_pal <- function() {
  deprecate_warn("5.0.0", "circlefill_shape_pal()")
  # `pch_unicode`, not `pch`: this palette grades circles by fill fraction,
  # which base pch cannot express at all, so it has no font-independent form.
  new_shape_pal(
    ggthemes::ggthemes_data[["shapes"]][["circlefill"]],
    unicode = TRUE
  )
}

#' Filled Circle Shape palette (discrete)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @export
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @family shapes
#' @importFrom lifecycle deprecate_warn
#' @seealso
#' \code{\link{circlefill_shape_pal}()} for a description of the palette.
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
#' @param overlap use an empty circle instead of a solid circle when
#' \code{n == 2}.
#' @param alt If \code{TRUE}, then when \code{n == 3},
#'   use a solid circle, plus sign and
#'   empty triangle. Otherwise use a solid circle, empty circle, and empty
#'   triangle. Defaults to \code{FALSE}, the triple Tremmel's Experiment 1
#'   actually measured; the \code{TRUE} triple is argued on feature-dimension
#'   grounds that Tremmel flags as not directly supported by the experiments.
#' @family shapes
#' @references
#' Tremmel, Lothar, (1995) "The Visual Separability of Plotting Symbols in Scatterplots"
#' Journal of Computational and Graphical Statistics,
#' \url{https://www.jstor.org/stable/1390760}
#' @export
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
#' @seealso \code{\link{tremmel_shape_pal}()} for a description of the palette.
#' @example inst/examples/ex-scale_shape_tremmel.R
#' @family shapes
#' @export
scale_shape_tremmel <- function(overlap = FALSE, alt = FALSE, ...) {
  discrete_scale(
    "shape",
    palette = tremmel_shape_pal(
      overlap = overlap,
      alt = alt
    ),
    ...
  )
}
