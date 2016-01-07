#' Color Palletes from Few's "Practical Rules for Using Color in Charts"
#'
#' Qualitative color palettes from Stephen Few,
#' \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical
#' Rules for Using Color in Charts"}.
#'
#' He suggests the following
#' \itemize{
#' \item For bars, use medium.
#' \item For lines and points use dark if small or thin, and medium otherwise.
#' }
#'
#' @export
#' @param palette One of "medium", "dark", or "light"
#' @family colour few
#' @examples
#' library("scales")
#' show_col(few_pal()(7))
#' show_col(few_pal("dark")(7))
#' show_col(few_pal("light")(7))
few_pal <- function(palette="medium") {
    ## The first value, gray, is used for non-data parts.
    values <- ggthemes_data$few[[palette]]
    n <- length(values)
    manual_pal(unname(values[2:n]))
}

#' Color scales from Few's "Practical Rules for Using Color in Charts"
#'
#' See \code{\link{few_pal}}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams few_pal
#' @family colour few
#' @rdname scale_few
#' @export
scale_colour_few <- function(palette="medium", ...) {
    discrete_scale("colour", "few", few_pal(palette), ...)
}

#' @export
#' @rdname scale_few
scale_color_few <- scale_colour_few

#' @export
#' @rdname scale_few
scale_fill_few <- function(palette="light", ...) {
    discrete_scale("fill", "few", few_pal(palette), ...)
}

#' Theme based on Few's "Practical Rules for Using Color in Charts"
#'
#' Theme based on the rules and examples in
#' Stephen Few, "Practical Rules for Using Color in Charts"
#'
#' @references Stephen Few, "Practical Rules for Using Color in Charts",
#' \url{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}.
#'
#' @inheritParams ggplot2::theme_bw
#' @family themes few
#' @export
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars) + geom_point(aes(x = wt, y = mpg,
#'     colour=factor(gear))) + facet_wrap(~am)
#' p + theme_few() + scale_colour_few()
#' p + theme_few() + scale_colour_few("light")
#' p + theme_few() + scale_colour_few("dark")
#'
theme_few <- function(base_size=12, base_family="") {
    colors <- ggthemes_data$few
    gray <- colors$medium["gray"]
    black <- colors$dark["black"]
    theme_bw(base_size = base_size, base_family = base_family) +
        theme(
            line = element_line(colour = gray),
            rect = element_rect(fill = "white", colour = NA),
            text = element_text(colour = black),
            axis.ticks = element_line(colour = gray),
            legend.key = element_rect(colour = NA),
            ## Examples do not use grid lines
            panel.border = element_rect(colour = gray),
            panel.grid = element_blank(),
            strip.background = element_rect(fill = "white", colour = NA)
            )
}
