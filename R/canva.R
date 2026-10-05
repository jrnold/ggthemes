# nolint start
#' 150 color palettes from Canva
#'
#' 150 four-color palettes by the
#' [canva.com](https://www.canva.com/learn/) design school.
#' These palettes were derived from photos and "impactful websites".
#'
#' @format A named `list` of character vectors.
#' The names are the palette names. The values of the character vectors
#' are hex colors, e.g. `"#f98866"`.
#'
#' @references
#' - Janie Kliever, [100 Brilliant Color Combinations and How to Apply Them to Your Designs](https://www.canva.com/learn/100-color-combinations/),
#'   *Canva.com*, June 20, 2015.
#' - Mary Stribley, [Website Color Schemes: The Palettes of 50 Visually Impactful Websites to Inspire You](https://www.canva.com/learn/website-color-schemes/),
#'   *Canva.com*, January 26, 2016.
#' - Schwabish, Jonathan.
#'   [150+ Color Palettes for Excel](https://policyviz.com/2017/01/12/150-color-palettes-for-excel/),
#'   *PolicyViz*, January 12, 2017.
#' @example inst/examples/ex-canva_pal.R
"canva_palettes"
# nolint end

#' Canva.com color palettes
#'
#' 150+ color palettes from canva.com. See [canva_palettes].
#'
#' @param palette Palette name. See the names of [canva_palettes]
#'   for valid names.
#' @return A function that takes a single value, the number of colors to use.
#' @export
#' @family color canva
#' @example inst/examples/ex-canva_pal.R
canva_pal <- function(palette = "Fresh and bright") {
  if (!palette %in% names(ggthemes::canva_palettes)) {
    cli::cli_abort(c(
      "{.val {palette}} is not a valid {.arg palette} name.",
      "i" = "See {.code names(canva_palettes)} for valid names."
    ))
  }
  manual_pal_checked(unname(ggthemes::canva_palettes[[palette]]))
}

#' Discrete color scale using canva.com color palettes
#'
#' Color scale for canva.com color palettes described in
#' [canva_palettes].
#'
#' @param ... Arguments passed to [ggplot2::discrete_scale()].
#' @inheritParams canva_pal
#' @return A ggplot2 scale object.
#' @export
#' @family color canva
#' @example inst/examples/ex-scale_colour_canva.R
scale_colour_canva <- function(..., palette = "Fresh and bright") {
  discrete_scale("colour", palette = canva_pal(palette), ...)
}

#' @export
#' @rdname scale_colour_canva
scale_color_canva <- scale_colour_canva

#' @export
#' @rdname scale_colour_canva
scale_fill_canva <- function(..., palette = "Fresh and bright") {
  discrete_scale("fill", palette = canva_pal(palette), ...)
}
