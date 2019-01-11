#' Excel 97 ugly color palettes (discrete)
#'
#' The color palettes used in Microsoft Excel 97 (and up until Excel 2007).
#' Use this for that classic ugly look and feel. For ironic purposes only.
#' 3D bars and pies not included. Please never use this color palette.
#'
#' @param line If \code{TRUE}, use the palette for lines and points. Otherwise,
#'    use the palette for area.
#' @family colour excel
#' @export
#' @example inst/examples/ex-excel_pal.R
excel_pal <- function(line = TRUE) {
  if (line[[1]]) {
    manual_pal(ggthemes::ggthemes_data$excel$classic$line)
  } else {
    manual_pal(ggthemes::ggthemes_data$excel$classic$fill)
  }
}

#' Excel (current versions) color palettes (discrete)
#'
#' Color palettes used by current versions of Microsoft Office and Excel.
#'
#' @param theme The name of the Office theme or color theme
#'   (not to be confused with ggplot2 themes) from which to derive the color
#'   palette. Available themes include:
#'   \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$excel$themes))}
#' @family colour excel
#' @example inst/examples/ex-excel_new_pal.R
#' @export
excel_new_pal <- function(theme = "Office Theme") {
  allthemes <- ggthemes::ggthemes_data$excel$themes
  if (!theme %in% names(allthemes)) {
    stop("`theme` must be one of ", paste0(names(allthemes), collapse = ", "))
  }
  values <- unname(allthemes[[theme]][["accents"]])
  f <- manual_pal(values)
  attr(f, "max_n") <- length(values)
  f
}

#' Excel 97 ugly color scales
#'
#' The classic "ugly" color scales from Excel 97.
#'
#' @inheritParams excel_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour excel
#' @rdname scale_excel
#' @export
#' @example inst/examples/ex-theme_excel.R
scale_fill_excel <- function(...) {
  discrete_scale("fill", "excel", excel_pal(line = FALSE), ...)
}

#' @export
#' @rdname scale_excel
scale_colour_excel <- function(...) {
  discrete_scale("colour", "excel", excel_pal(line = TRUE), ...)
}

#' @export
#' @rdname scale_excel
scale_color_excel <- scale_colour_excel

#' Excel (current versions) color scales
#'
#' Discrete color scales used in current versions of Microsoft Office and Excel.
#'
#' @inheritParams excel_new_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour excel
#' @rdname scale_excel_new
#' @example inst/examples/ex-theme_excel_new.R
#' @export
scale_colour_excel_new <- function(theme = "Office Theme", ...) {
  discrete_scale("colour", "excel_new", excel_new_pal(theme), ...)
}

#' @export
#' @rdname scale_excel_new
scale_color_excel_new <- scale_colour_excel_new

#' @export
#' @rdname scale_excel_new
scale_fill_excel_new <- function(theme = "Office Theme", ...) {
  discrete_scale("fill", "excel_new", excel_new_pal(theme), ...)
}

#' ggplot theme based on old Excel plots
#'
#' Theme to replicate the ugly monstrosity that was the old
#' gray-background Excel chart. Please never use this.
#' This theme should be combined with the \code{\link{scale_colour_excel}()}
#' color scale.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal \code{logical}. Horizontal axis lines?
#' @return An object of class \code{\link[ggplot2]{theme}()}.
#' @export
#' @family themes excel
#' @example inst/examples/ex-theme_excel.R
theme_excel <- function(base_size = 12, base_family = "",
                                horizontal = TRUE) {
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

#' ggplot theme similar to current Excel plot defaults
#'
#' Theme for ggplot2 that is similar to the default style of charts in
#' current versions of Microsoft Excel.
#'
#' @inheritParams ggplot2::theme_grey
#' @return An object of class \code{\link[ggplot2]{theme}()}.
#' @export
#' @family themes excel
#' @example inst/examples/ex-theme_excel_new.R
#'
theme_excel_new <- function(base_size = 9,
                        base_family = "sans") {
  colorlist <- list(lt_gray = "#D9D9D9",
                    gray = "#BFBFBF",
                    dk_gray = "#595959")
  theme_bw(base_family = base_family,
           base_size = base_size) +
    theme(
      text = element_text(
        colour = colorlist$dk_gray,
        size = base_size
      ),
      line = element_line(
        linetype = "solid",
        colour = colorlist$gray
      ),
      rect = element_rect(
        linetype = 0,
        colour = "white"
      ),
      panel.grid.major = element_line(
        linetype = "solid",
        colour = colorlist$gray,
        size = 0.75 * PT_TO_MM
      ),
      panel.grid.minor = element_blank(),
      axis.title = element_blank(),
      axis.text = element_text(
        colour = colorlist$dk_gray,
        size = 9
      ),
      strip.background = element_rect(
        fill = NA
      ),
      strip.text = element_text(
        colour = colorlist$dk_gray,
        size = 9
      ),
      axis.ticks = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(colour = NA),
      title = element_text(
        face = "plain",
        hjust = 0.5
      ),
      plot.title = element_text(
        size = 14,
        hjust = 0.5
      ),
      plot.subtitle = element_blank(),
      legend.position = "bottom",
      legend.text = element_text(
        size = 9,
        colour = colorlist$dk_gray
      ),
      legend.title = element_blank(),
    )
}
