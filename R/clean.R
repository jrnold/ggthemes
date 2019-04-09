#' @title Clean ggplot theme
#'
#' @description Clean ggplot theme with no panel background, black axis lines
#'   and grey fill colour for chart elements.
#'
#' @author Konrad Zdeb \email{name.surname@@me.com}
#'
#' @param base_size Base font size.
#' @param base_family Base font family.
#'
#' @family themes
#' @export
#'
#' @example inst/examples/ex-theme_clean.R
theme_clean <- function(base_size = 12,
                        base_family = "sans") {
  (
    theme_foundation(base_size = base_size,
                     base_family = base_family) + theme(
                       axis.line.x = element_line(
                         colour = "black",
                         size = 0.5,
                         linetype = "solid"
                       ),
                       axis.line.y = element_line(
                         colour = "black",
                         size = 0.5,
                         linetype = "solid"
                       ),
                       axis.text = element_text(size = ceiling(base_size * 0.7), colour = "black"),
                       axis.title = element_text(size = ceiling(base_size * 0.8)),
                       panel.grid.minor = element_blank(),
                       panel.grid.major.y = element_line(colour = "gray", linetype = "dotted"),
                       panel.grid.major.x = element_blank(),
                       panel.background = element_blank(),
                       panel.border = element_blank(),
                       strip.background = element_rect(linetype = 0),
                       strip.text = element_text(),
                       strip.text.x = element_text(vjust = 0.5),
                       strip.text.y = element_text(angle = -90),
                       legend.text = element_text(size = ceiling(base_size * 0.9), family = "sans"),
                       legend.title = element_text(
                         size = base_size,
                         face = "bold",
                         family = "sans"
                       ),
                       legend.position = "right",
                       legend.key = element_rect(fill = "white", colour = NA),
                       legend.background = element_rect(colour = "black"),
                       plot.background = element_rect(colour = "black"),
                       plot.title = element_text(size = ceiling(base_size * 1.1), face = "bold"),
                       plot.subtitle = element_text(size = ceiling(base_size * 1.05))
                     )
  )
}
