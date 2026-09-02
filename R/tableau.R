# Palette names that ggthemes used before they were corrected to match the
# names Tableau itself uses. Mapping is deprecated-name -> canonical name.
tableau_deprecated_palettes <- c(
  "Red-Blue-Brown" = "Blue-Red-Brown",
  "Classic Area-Brown" = "Classic Area Brown"
)

# Resolve a possibly-deprecated palette name to its canonical name, warning when
# a deprecated name is used.
tableau_resolve_palette <- function(palette) {
  if (length(palette) == 1L && palette %in% names(tableau_deprecated_palettes)) {
    canonical <- unname(tableau_deprecated_palettes[[palette]])
    cli::cli_warn(
      "Tableau palette {.val {palette}} is deprecated; use {.val {canonical}} instead."
    )
    return(canonical)
  }
  palette
}

# nolint start
#' Tableau Color Palettes (discrete)
#'
#' Color palettes used in \href{https://www.tableau.com/}{Tableau}.
#'
#' @details Tableau provides three types of color palettes:
#' \code{"regular"} (discrete, qualitative categories),
#' \code{"ordered-sequential"}, and \code{"ordered-diverging"}.
#'
#' \describe{
#' \item{\code{"regular"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["regular"]]))}}
#' \item{\code{"ordered-diverging"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-diverging"]]))}}
#' \item{\code{"ordered-sequential"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]]))}}
#' }
#'
#' @export
#' @param palette Palette name. See Details for available palettes.
#' @param type Type of palette. One of \code{"regular"}, \code{"ordered-diverging"}, or \code{"ordered-sequential"}.
#' @param direction If 1, the default, then use the original order of
#'   colors. If -1, then reverse the order.
#'
#' @references
#' \url{http://vis.stanford.edu/color-names/analyzer/}
#'
#' Maureen Stone, 'Designing Colors for Data' (slides), at the
#' International Symposium on Computational Aesthetics in Graphics,
#' Visualization, and Imaging, Banff, AB, Canada, June 22, 2007.
#'
#' Heer, Jeffrey and Maureen Stone, 2012 'Color Naming Models for
#' Color Selection, Image Editing and Palette Design', ACM Human
#' Factors in Computing Systems (CHI)
#' \url{http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf}.
#'
#' @family colour tableau
#' @example inst/examples/ex-tableau_color_pal.R
# nolint end
tableau_color_pal <- function(
  palette = "Tableau 10",
  type = c(
    "regular",
    "ordered-sequential",
    "ordered-diverging"
  ),
  direction = 1
) {
  type <- match.arg(type)
  palette <- tableau_resolve_palette(palette)
  palettes <- ggthemes::ggthemes_data[["tableau"]][["color-palettes"]][[type]]
  if (!palette %in% names(palettes)) {
    cli::cli_abort("{.arg palette} must be one of {.val {names(palettes)}}, not {.val {palette}}.")
  }
  values <- palettes[[palette]][["value"]]
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    values <- values[seq_len(n)]
    if (direction < 0) {
      values <- rev(values)
    }
    values
  }
  attr(f, "max_n") <- length(values)
  f
}

#' Tableau color scales (discrete)
#'
#' Categorical (qualitative) color scales used in Tableau.
#' Use the function \funclink{scale_colour_gradient_tableau} for the sequential
#' and \funclink{scale_colour_gradient2_tableau} for the diverging continuous
#' color scales from Tableu.
#'
#' @param palette Palette name. See \funclink{tableau_color_pal}
#'   for available palettes.
#' @param type Palette type. One of \code{"regular"}, \code{"sequential"},
#'   or \code{"diverging"}. See \funclink{tableau_color_pal}.
#' @inheritParams tableau_color_pal
#' @param ... Other arguments passed on to \code{\link[ggplot2]{discrete_scale}()}.
#' @family colour tableau
#' @rdname scale_color_tableau
#' @export
#' @seealso \code{\link{tableau_color_pal}()} for references.
#' @example inst/examples/ex-scale_color_tableau.R
scale_colour_tableau <- function(palette = "Tableau 10", type = "regular", direction = 1, ...) {
  discrete_scale("colour", palette = tableau_color_pal(palette, type, direction), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_fill_tableau <- function(palette = "Tableau 10", type = "regular", direction = 1, ...) {
  discrete_scale("fill", palette = tableau_color_pal(palette, type, direction), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_color_tableau <- scale_colour_tableau

#' Tableau Shape Palettes (discrete)
#'
#' Shape palettes used by
#' \href{https://www.tableau.com/}{Tableau}.
#'
#' Not all shape palettes in Tableau are supported, and these palettes are not
#' exact.
#'
#' Shape palettes in Tableau are used to expose images for use as markers in
#' charts, and thus are sometimes groupings of closely related symbols.
#'
#' @note
#'
#' Supported values by palette: \code{"default"} eight (ten with
#' \code{unicode = TRUE}), \code{"filled"} six (ten), \code{"proportions"}
#' two (five). Shapes with no base pch equivalent -- the sideways triangles,
#' the solid star, and the partially filled circles -- are dropped rather than
#' approximated by a different shape.
#'
#' \code{"proportions"} encodes \emph{fill fraction}, which base pch cannot
#' express at all, so only its empty and full circles survive; they remain
#' meaningful as a two-value scale. To encode a proportion, map \code{alpha}
#' or \code{fill} instead, or use \code{unicode = TRUE} with a font covering
#' Geometric Shapes, such as DejaVu Sans.
#'
#' @export
#' @param palette Palette name.
#' @inheritParams cleveland_shape_pal
#' @family shapes tableau
#' @example inst/examples/ex-tableau_shape_pal.R
tableau_shape_pal <- function(palette = c("default", "filled", "proportions"), unicode = FALSE) {
  palette <- rlang::arg_match(palette)
  shapes <- ggthemes::ggthemes_data$tableau[["shape-palettes"]][[palette]]
  new_shape_pal(shapes, unicode = unicode)
}

#' Tableau shape scales
#'
#' See \code{\link{tableau_shape_pal}()} for details.
#'
#' @export
#' @inheritParams tableau_shape_pal
#' @inheritParams ggplot2::scale_x_discrete
#' @family shapes tableau
#' @example inst/examples/ex-scale_shape_tableau.R
scale_shape_tableau <- function(palette = "default", ..., unicode = FALSE) {
  discrete_scale(
    "shape",
    palette = tableau_shape_pal(palette, unicode = unicode),
    ...
  )
}

# nolint start
#' Tableau colour gradient palettes (continuous)
#'
#' Gradient color palettes using the diverging and sequential continous color
#' palettes in Tableau. See \funclink{tableau_color_pal} for discrete color
#' palettes.
#'
#' @param palette Palette name.
#'  \describe{
#'  \item{\code{"ordered-sequential"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]]))}}
#'  \item{\code{"ordered-diverging"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-diverging"]]))}}
#'  }
#' @param type Palette type, either \code{"ordered-sequential"} or
#'   \code{"ordered-diverging"}.
#' @param ... Arguments passed to \code{tableau_gradient_pal}.
#' @family colour tableau
#'
#' @export
#' @example inst/examples/ex-tableau_seq_gradient_pal.R
# nolint end
tableau_gradient_pal <- function(palette = "Blue", type = "ordered-sequential") {
  type <- match.arg(type, c("ordered-sequential", "ordered-diverging"))
  palette <- tableau_resolve_palette(palette)
  pal <- ggthemes::ggthemes_data[[c(
    "tableau",
    "color-palettes",
    type,
    palette
  )]]
  scales::gradient_n_pal(colours = pal[["value"]])
}

#' @export
#' @rdname tableau_gradient_pal
tableau_seq_gradient_pal <- function(palette = "Blue", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-sequential", ...)
}

#' @export
#' @rdname tableau_gradient_pal
tableau_div_gradient_pal <- function(palette = "Orange-Blue Diverging", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-diverging", ...)
}

#' Tableau sequential colour scales (continuous)
#'
#' Continuous color scales using the sequential color palettes in Tableau.
#' See \funclink{scale_colour_tableau} for Tableau discrete color scales,
#' and \funclink{scale_colour_gradient2_tableau} for diverging color
#' scales.
#'
#' @export
#' @inheritParams tableau_seq_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @rdname scale_colour_gradient_tableau
#' @example inst/examples/ex-scale_colour_gradient_tableau.R
#' @importFrom ggplot2 continuous_scale
scale_colour_gradient_tableau <- function(
  palette = "Blue",
  ...,
  na.value = "grey50", # nolint: object_name_linter
  guide = "colourbar"
) {
  continuous_scale("colour", palette = tableau_seq_gradient_pal(palette), na.value = na.value, guide = guide, ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_gradient_tableau <- function(
  palette = "Blue",
  ...,
  na.value = "grey50", # nolint: object_name_linter
  guide = "colourbar"
) {
  continuous_scale("fill", palette = tableau_seq_gradient_pal(palette), na.value = na.value, guide = guide, ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_gradient_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_continuous_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_continuous_tableau <- scale_fill_gradient_tableau

#' Tableau diverging colour scales (continuous)
#'
#' Continuous color scales using the diverging color scales in Tableau.
#' See \funclink{scale_colour_tableau} for Tabaleau discrete color scales,
#' and \funclink{scale_colour_gradient_tableau} for sequential color scales.
#'
#' @inheritParams tableau_div_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param midpoint The data value that corresponds to the middle color of the
#'   diverging palette.
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @export
#' @rdname scale_colour_gradient2_tableau
#' @example inst/examples/ex-scale_colour_gradient2_tableau.R
scale_colour_gradient2_tableau <- function(
  palette = "Orange-Blue Diverging",
  ...,
  midpoint = 0,
  na.value = "grey50", # nolint: object_name_linter
  guide = "colourbar"
) {
  continuous_scale(
    "colour",
    palette = tableau_div_gradient_pal(palette),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(mid = midpoint),
    ...
  )
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_fill_gradient2_tableau <- function(
  palette = "Orange-Blue Diverging",
  ...,
  midpoint = 0,
  na.value = "grey50", # nolint: object_name_linter
  guide = "colourbar"
) {
  continuous_scale(
    "fill",
    palette = tableau_div_gradient_pal(palette),
    na.value = na.value,
    guide = guide,
    rescaler = mid_rescaler(mid = midpoint),
    ...
  )
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_color_gradient2_tableau <- scale_colour_gradient2_tableau
