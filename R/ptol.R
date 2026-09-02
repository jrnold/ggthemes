# Shared deprecation details for the ptol palette and its scales, so the four
# exported functions cannot drift apart in what they recommend.
#
# khroma is named in `details` rather than passed as lifecycle's `with`
# argument on purpose: `with` renders as "Use `x` instead", which promises a
# drop-in replacement. It is not one. This palette is Paul Tol's original
# 12-colour qualitative scheme from the 2012 technical note; khroma follows the
# revisions on his current site, where the nearest scheme (`muted`) has nine
# colours.
ptol_deprecation_details <- function() {
  c(
    i = paste(
      "This palette is the 12-colour qualitative scheme from Paul Tol's 2012",
      "technical note. He has revised his schemes since; the current ones are",
      "at <https://sronpersonalpages.nl/~pault/>."
    ),
    i = paste(
      "The khroma package tracks those revisions. The closest successor to",
      'this palette is `khroma::colour("muted")`, or',
      "`khroma::scale_colour_muted()` for a ggplot2 scale."
    )
  )
}

#' Color Palettes from Paul Tol's "Colour Schemes"
#'
#' @md
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `ptol_pal()` was deprecated in ggthemes 7.0.0. Use the
#' [khroma](https://CRAN.R-project.org/package=khroma) package instead, which
#' tracks Paul Tol's colour schemes as he revises them.
#'
#' This palette is the 12-colour qualitative scheme from Tol's 2012 technical
#' note, and has not followed the revisions he has made since. His current
#' schemes are at <https://sronpersonalpages.nl/~pault/>; the closest successor
#' to this palette is `khroma::colour("muted")`.
#'
#' Qualitative color palettes from Paul Tol,
#' \href{https://sronpersonalpages.nl/~pault/}{"Colour Schemes"}.
#'
#' Incorporation of the palette into an R package was originally inspired by
#' Peter Carl's [Paul Tol 21 Gun Salute](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)
#'
#' @export
#' @family colour ptol
#' @references
#' Paul Tol. 2012. "Colour Schemes." SRON Technical Note, SRON/EPS/TN/09-002.
#'  \url{https://sronpersonalpages.nl/~pault/data/colourschemes.pdf}
#' @importFrom lifecycle deprecate_warn
#' @example inst/examples/ex-ptol_pal.R
ptol_pal <- function() {
  deprecate_warn("7.0.0", "ptol_pal()", details = ptol_deprecation_details())
  colors <- ggthemes::ggthemes_data[["ptol"]][["qualitative"]]
  max_n <- length(colors)
  f <- function(n) {
    check_pal_n(n, max_n)
    colors[[n]]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Color Scales from Paul Tol's "Colour Schemes
#'
#' @md
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' These scales were deprecated in ggthemes 7.0.0. Use the
#' [khroma](https://CRAN.R-project.org/package=khroma) package instead, which
#' tracks Paul Tol's colour schemes as he revises them.
#'
#' They draw the 12-colour qualitative scheme from Tol's 2012 technical note,
#' and have not followed the revisions he has made since. His current schemes
#' are at <https://sronpersonalpages.nl/~pault/>; the closest successor is
#' `khroma::scale_colour_muted()`.
#'
#' See \code{\link{ptol_pal}()}. These palettes support up to 12 values.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams ptol_pal
#' @family colour ptol
#' @rdname scale_ptol
#' @export
#' @importFrom lifecycle deprecate_warn
#' @example inst/examples/ex-scale_colour_ptol.R
scale_colour_ptol <- function(...) {
  deprecate_warn("7.0.0", "scale_colour_ptol()", details = ptol_deprecation_details())
  discrete_scale("colour", palette = ptol_pal_quietly(), ...)
}

#' @export
#' @rdname scale_ptol
scale_color_ptol <- scale_colour_ptol

#' @export
#' @rdname scale_ptol
scale_fill_ptol <- function(...) {
  deprecate_warn("7.0.0", "scale_fill_ptol()", details = ptol_deprecation_details())
  discrete_scale("fill", palette = ptol_pal_quietly(), ...)
}

# The scales are deprecated in their own right and have already warned by the
# time they build their palette. Calling `ptol_pal()` normally would warn a
# second time and point the user at a function they never called, so silence
# that inner warning. The palette is forced here rather than left as a promise
# for `discrete_scale()`, so the suppression is guaranteed to be in effect when
# `ptol_pal()` actually runs.
ptol_pal_quietly <- function() {
  rlang::local_options(lifecycle_verbosity = "quiet")
  ptol_pal()
}
