#' Theme inspired by fivethirtyeight.com plots
#' @param base_size Base font size.
#' @param color The background color of plot. One of \code{"brown",
#' "gray", "green", "blue"}, the names of values in
#' \code{ggthemes_data$wsj$bg}.
#' @param title_family Plot title font family.
#' @param base_family Plot text font family.
#' @family themes wsj
#' @export
theme_fivethirtyeight <- function(base_size = 12, base_family = "sans") {
    (theme_foundation(base_size = base_size, base_family = base_family)
     + theme(
         line = element_line(linetype = 1, colour = "black"),
         rect = element_rect(fill = ggthemes_data$fivethirtyeight$ltgray, linetype = 0, colour = NA),
         text = element_text(colour = ggthemes_data$fivethirtyeight$dkgray),
         axis.title = element_blank(),
         axis.text = element_blank(),
         axis.ticks = element_blank(),
         axis.line = element_blank(),
         legend.background = element_rect(),
         legend.position = "top",
         legend.direction = "horizontal",
         legend.box = "vertical",
         panel.grid = element_line(colour = NULL, linetype = 3),
         panel.grid.major = element_line(colour = ggthemes_data$fivethirtyeight$medgray),
         panel.grid.minor = element_blank(),
         plot.title = element_text(hjust = 0),
         plot.margin = unit(c(1, 1, 1, 1), "lines"),
         strip.background=element_rect()))
}
## (qplot(hp, mpg, data=mtcars, geom="point")
##  + ggtitle("Diamond Prices")
##  + theme_fivethirtyeight())
