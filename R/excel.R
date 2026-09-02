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
    manual_pal_checked(ggthemes::ggthemes_data$excel$classic$line)
  } else {
    manual_pal_checked(ggthemes::ggthemes_data$excel$classic$fill)
  }
}

# Excel theme names that ggthemes used before Microsoft renamed the built-in
# themes. Each maps to its current name; the old names keep working silently.
excel_theme_aliases <- c(
  "Office Theme" = "Office 2013",
  "Office 2007-2010" = "Office 2007"
)

# Resolve a possibly-superseded theme name to its current name.
excel_resolve_theme <- function(theme) {
  if (length(theme) == 1L && theme %in% names(excel_theme_aliases)) {
    return(unname(excel_theme_aliases[[theme]]))
  }
  theme
}

#' Excel (current versions) color palettes (discrete)
#'
#' Color palettes used by current versions of Microsoft Office and Excel.
#'
#' @details In 2023 Microsoft replaced the long-standing Office theme with a new
#' default and renamed the old one. The default here, \code{"Office"}, is the
#' current palette; \code{"Office 2013"} is the palette Excel used from 2013
#' until 2022. The former ggthemes names \code{"Office Theme"} and
#' \code{"Office 2007-2010"} still work, and select \code{"Office 2013"} and
#' \code{"Office 2007"} respectively.
#'
#' @param theme The name of the Office theme or color theme
#'   (not to be confused with ggplot2 themes) from which to derive the color
#'   palette. Available themes include:
#'   \Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$excel$themes))}
#' @family colour excel
#' @example inst/examples/ex-excel_new_pal.R
#' @export
excel_new_pal <- function(theme = "Office") {
  allthemes <- ggthemes::ggthemes_data$excel$themes
  theme <- excel_resolve_theme(theme)
  if (!theme %in% names(allthemes)) {
    cli::cli_abort("{.arg theme} must be one of {.val {names(allthemes)}}.")
  }
  values <- unname(allthemes[[theme]][["accents"]])
  f <- manual_pal_checked(values)
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
  discrete_scale("fill", palette = excel_pal(line = FALSE), ...)
}

#' @export
#' @rdname scale_excel
scale_colour_excel <- function(...) {
  discrete_scale("colour", palette = excel_pal(line = TRUE), ...)
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
scale_colour_excel_new <- function(theme = "Office", ...) {
  discrete_scale("colour", palette = excel_new_pal(theme), ...)
}

#' @export
#' @rdname scale_excel_new
scale_color_excel_new <- scale_colour_excel_new

#' @export
#' @rdname scale_excel_new
scale_fill_excel_new <- function(theme = "Office", ...) {
  discrete_scale("fill", palette = excel_new_pal(theme), ...)
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
theme_excel <- function(base_size = 12, base_family = "", horizontal = TRUE) {
  gray <- "#C0C0C0"
  ret <- (theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      panel.background = element_rect(fill = gray),
      panel.border = element_rect(
        colour = "black",
        linetype = 1
      ),
      panel.grid.major = element_line(colour = "black"),
      panel.grid.minor = element_blank(),
      legend.key = element_rect(colour = NA),
      legend.background = element_rect(colour = "black", linetype = 1),
      strip.background = element_rect(
        fill = "white",
        colour = NA,
        linetype = 0
      )
    ))
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
#' @details Excel derives its chart greys from the theme's \code{tx1} colour
#' by luminance transform rather than hardcoding them. Since \code{tx1} is
#' black in every built-in Office theme, these greys---\code{"#D9D9D9"}
#' gridlines, \code{"#BFBFBF"} axis lines, \code{"#595959"} text---are the
#' same whichever theme \funclink{scale_colour_excel_new} is set to.
#'
#' Since 2023 the default font in Excel has been Aptos, but \code{base_family}
#' defaults to \code{"sans"} because Aptos is rarely installed outside of
#' Office. Pass \code{base_family = "Aptos Narrow"} for a closer match if you
#' do have it.
#'
#' @inheritParams ggplot2::theme_grey
#' @return An object of class \code{\link[ggplot2]{theme}()}.
#' @export
#' @family themes excel
#' @example inst/examples/ex-theme_excel_new.R
#'
theme_excel_new <- function(base_size = 9, base_family = "sans") {
  # Excel does not hardcode chart chrome; it derives each grey from tx1
  # (black) by luminance transform, so the greys are the same in every Office
  # theme. Decoded from xl/charts/style1.xml and xl/charts/chart1.xml in
  # data-raw/excel/mtcars.xlsx, written by Microsoft Excel 16.03.
  colorlist <- list(
    gridline = "#D9D9D9", # tx1 lumMod 15% / lumOff 85%
    axis = "#BFBFBF", # tx1 lumMod 25% / lumOff 75%
    label = "#595959" # tx1 lumMod 65% / lumOff 35%
  )
  theme_bw(
    base_family = base_family,
    base_size = base_size
  ) +
    theme(
      text = element_text(
        colour = colorlist$label,
        size = base_size
      ),
      line = element_line(
        linetype = "solid",
        colour = colorlist$axis
      ),
      rect = element_rect(
        linetype = 0,
        colour = "white"
      ),
      panel.grid.major = element_line(
        linetype = "solid",
        colour = colorlist$gridline,
        linewidth = 0.75 * PT_TO_MM
      ),
      panel.grid.minor = element_blank(),
      axis.line = element_line(
        linetype = "solid",
        colour = colorlist$axis,
        linewidth = 0.75 * PT_TO_MM
      ),
      axis.text = element_text(
        colour = colorlist$label,
        size = base_size
      ),
      # Excel sets axis titles one point larger than axis labels.
      axis.title = element_text(
        size = rel(10 / 9)
      ),
      strip.background = element_rect(
        fill = NA
      ),
      strip.text = element_text(
        colour = colorlist$label,
        size = base_size
      ),
      axis.ticks = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(colour = NA),
      title = element_text(
        face = "plain",
        hjust = 0.5
      ),
      plot.title = element_text(
        size = rel(14 / 9),
        hjust = 0.5
      ),
      plot.subtitle = element_blank(),
      legend.position = "bottom",
      legend.text = element_text(
        size = base_size,
        colour = colorlist$label
      ),
      legend.title = element_blank(),
    )
}
