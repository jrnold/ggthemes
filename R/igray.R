#' Inverse gray theme
#'
#' Theme with white panel and gray background.
#'
#' @section Details:
#'
#' This theme inverts the colors in the \code{\link[ggplot2]{theme_gray}()}, a
#' white panel and a light gray area around it. This keeps a white
#' background for the color scales like \code{\link[ggplot2]{theme_bw}()}. But
#' by using a gray background, the plot is closer to the
#' typographical color of the document, which is the motivation for
#' using a gray panel in \code{\link[ggplot2]{theme_gray}()}. This is
#' similar to the style of plots in Stata and Tableau.
#'
#' @inheritParams ggplot2::theme_grey
#' @export
#' @family themes
#' @seealso \code{\link[ggplot2]{theme_gray}()},
#'   \code{\link[ggplot2]{theme_bw}()}
#' @example inst/examples/ex-theme_igray.R
#' @importFrom ggplot2 theme_gray
theme_igray <- function(base_size = 12, base_family = "") {
  (theme_gray(base_size = base_size, base_family = base_family) +
     theme(rect = element_rect(fill = "gray90"),
           legend.key = element_rect(fill = "white"),
           panel.background = element_rect(fill = "white"),
           panel.grid.major = element_line(colour = "gray90"),
           plot.background = element_rect(fill = "gray90")))
}
