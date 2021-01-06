#' 150 Color Palettes from Canva
#'
#' 150 four-color palettes by the
#' \href{https://www.canva.com/learn/}{canva.com} design school.
#' These palettes were derived from photos and "impactful websites".
#'
#' @format A named \code{list} of character vector.
#' The names are the palette names. The values of the character vectors
#' are hex colors, e.g. \code{"#f98866"}.
#'
#' @references
#' \itemize{
#' \item{Janie Kliever, \href{https://www.canva.com/learn/100-color-combinations/}{100 Brilliant Color Combinations and How to Apply Them to Your Designs},
#'   \emph{Canva.com}, June 20, 2015.}
#' \item{Mary Stribley, \href{https://www.canva.com/learn/website-color-schemes/}{Website Color Schemes: The Palettes of 50 Visually Impactful Websites to Inspire You},
#'   \emph{Canva.com}, January 26, 2016.}
#' \item{Schwabish, Jonathan.
#'    \href{https://policyviz.com/2017/01/12/150-color-palettes-for-excel/}{150+ Color Palettes for Excel},
#'     \emph{PolicyViz}, January 12, 2017.}
#' }
#' @example inst/examples/ex-canva_pal.R
"canva_palettes"

#' Canva.com color palettes
#'
#' 150+ color palettes from canva.com. See \code{\link{canva_palettes}()}.
#'
#' @param palette Palette name. See the names of \code{\link{canva_palettes}()}
#'   for valid names.
#' @return A function that takes a single value, the number of colors to use.
#' @export
#' @example inst/examples/ex-canva_pal.R
canva_pal <- function(palette = "Fresh and bright") {
  if (!palette %in% names(ggthemes::canva_palettes)) {
    stop("Palette ", sQuote(palette), " not a valid name.", call. = FALSE)
  }
  manual_pal(unname(ggthemes::canva_palettes[[palette]]))
}

#' Discrete color scale using canva.com color palettes
#'
#' Color scale for canva.com color palettes described in
#' \code{\link{canva_palettes}()}.
#'
#' @param ... Arguments passed to \code{\link{discrete_scale}()}.
#' @inheritParams canva_pal
#' @export
scale_colour_canva <- function(..., palette = "Fresh and bright") {
  discrete_scale("colour", "canva", canva_pal(palette), ...)
}

#' @export
#' @rdname scale_colour_canva
scale_color_canva <- scale_colour_canva

#' @export
#' @rdname scale_colour_canva
scale_fill_canva <- function(..., palette = "Fresh and bright") {
  discrete_scale("fill", "canva", canva_pal(palette), ...)
}
