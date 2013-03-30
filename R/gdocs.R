#' Theme with Google Docs Chart defaults
#'
#' Theme similar to the default look of charts in Google Docs.
#'
#' @param base_size base font size
#' @param base_family base font family
#' @export
#' @family themes google
#' @examples
#' dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
#' (d <- qplot(carat, price, data=dsamp, colour=clarity)
#'             + theme_gdocs() + ggtitle("Diamonds"))
theme_gdocs <- function(base_size=12, base_family="sans") {
  (theme_foundation(base_size=base_size, base_family=base_family)
   + theme(plot.title = element_text(face = "bold",
             size = rel(1.33), hjust = 0), # 16 pt, bold, align left
           panel.background = element_rect(colour = NA),
           panel.border = element_rect(colour = NA),
           axis.title = element_text(face = "italic"), # 12 pt
           axis.text = element_text(), # 12 pt
           axis.line = element_line(colour="black"),
           axis.ticks = element_blank(),
           panel.grid.major = element_line(colour = "#CCCCCC"),
           panel.grid.minor = element_blank(),
           legend.key = element_rect(colour = NA),
           legend.position = "right",
           legend.direction = "vertical"))
}
