#' Excel color palette (discrete)
#'
#' Color palettes from Excel, both current and the pre-2007 ugly
#' palettes.
#'
#' The color palettes are
#' \describe{
#' \item{line}{Excel 2003 default color palette.}
#' \item{fill}{Excel 2003 bar chart color palette.}
#' \item{new}{Color palette from newer Excel versions.}
#' }
#'
#' @param palette One of \code{'old'}, \code{'fill'}, or \code{'new'}.
#' @family colour excel
#' @export
#' @examples
#' library("scales")
#' show_col(excel_pal()(8))
#' show_col(excel_pal('fill')(8))
#' show_col(excel_pal('new')(10))
excel_pal <- function(palette = "line") {
  if (palette == "new") {
    manual_pal(ggthemes_data$excel$new)
  } else if (palette == "fill") {
    manual_pal(ggthemes_data$excel$fill)
  } else {
    manual_pal(ggthemes_data$excel$line)
  }
}

#' Excel color scales
#'
#' Color scales from both old and new Excel.
#'
#' @inheritParams excel_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour excel
#' @rdname scale_excel
#' @export
#' @seealso See \code{\link{theme_excel}} for examples.
scale_fill_excel <- function(palette = "fill", ...) {
  discrete_scale("fill", "excel", excel_pal(palette), ...)
}

#' @export
#' @rdname scale_excel
scale_colour_excel <- function(palette = "line", ...) {
  discrete_scale("colour", "excel", excel_pal(palette), ...)
}

#' @export
#' @rdname scale_excel
scale_color_excel <- scale_colour_excel

#' ggplot color theme based on old Excel plots
#'
#' Theme to replicate the ugly monstrosity that was the old
#' gray-background Excel chart. Please never use this.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal \code{logical}. Horizontal axis lines?
#' @return An object of class \code{\link{theme}}.
#' @export
#' @family themes excel
#' @examples
#' library("ggplot2")
#' # Old line color
#' p <- ggplot(mtcars) +
#'      geom_point(aes(x = wt, y = mpg, colour=factor(gear))) +
#'      facet_wrap(~am)
#' p + theme_excel() + scale_colour_excel()
#'
#' # Old fill color palette
#' ggplot(mpg, aes(x = class, fill = drv)) +
#'   geom_bar() +
#'   scale_fill_excel('fill') +
#'   theme_excel()
#'
theme_excel <- function(base_size = 12, base_family = "", horizontal = TRUE) {
  gray <- "#C0C0C0"
  ret <- (theme_bw() +
            theme(panel.background = element_rect(fill = gray),
                  panel.border = element_rect(colour = "black",
                                              linetype = 1),
                  panel.grid.major = element_line(colour = "black"),
                  panel.grid.minor = element_blank(),
                  legend.key = element_rect(colour = NA),

    legend.background = element_rect(colour = "black", linetype = 1),
 strip.background = element_rect(fill = "white",
      colour = NA, linetype = 0)))
  if (horizontal) {
    ret <- ret + theme(panel.grid.major.x = element_blank())
  } else {
    ret <- ret + theme(panel.grid.major.y = element_blank())
  }
  ret
}
