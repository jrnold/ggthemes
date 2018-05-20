#' Color Palettes from Few's "Practical Rules for Using Color in Charts"
#'
#' Qualitative color palettes from Stephen Few,
#'
#' Use the light palette for filled areas, such as bar charts.
#' The medium palette should be used for points and lines.
#' The dark palette should be used for either highlighting specific points,
#' or if the lines and points are small or thin.
#' All these palettes contain nine colors.
#'
#' @references
#' Few, S. (2012) \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten}.
#' 2nd edition. Analytics Press.
#'
#' \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical Rules for Using Color in Charts"}.
#'
#' @export
#' @param palette One of \code{c("medium", "dark", "light")}.
#' @family colour few
#' @example inst/examples/ex-few_pal.R
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
scale_colour_few <- function(palette = "medium", ...) {
    discrete_scale("colour", "few", few_pal(palette), ...)
}

#' @export
#' @rdname scale_few
scale_color_few <- scale_colour_few

#' @export
#' @rdname scale_few
scale_fill_few <- function(palette = "light", ...) {
    discrete_scale("fill", "few", few_pal(palette), ...)
}

#' Theme based on Few's "Practical Rules for Using Color in Charts"
#'
#' Theme based on the rules and examples from Stephen Few's
#' \emph{Show Me the Numbers} and "Practical Rules for Using Color in Charts".
#'
#' @references
#' Few, S. (2012) \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten}.
#' 2nd edition. Analytics Press.
#'
#' Stephen Few, "Practical Rules for Using Color in Charts",
#' \url{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}.
#'
#' @inheritParams ggplot2::theme_bw
#' @family themes few
#' @export
#' @example inst/examples/ex-theme_few.R
theme_few <- function(base_size = 12, base_family="") {
    colors <- ggthemes_data$few
    gray <- colors$medium["Gray"]
    black <- colors$dark["Gray"]
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

#' Shape palette from "Show Me the Numbers" (discrete)
#'
#' Shape palette from Stephen Few's, "Show Me the Numbers".
#' It consists of five shapes: circle, square, triangle, plus, times.
#'
#' @references Few, S. (2012)
#'   \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten},
#'   Analytics Press, p. 208.
#'
#' @export
few_shape_pal <- function() {
  max_n <- 5
  f <- function(n) {
    msg <- paste("The shape palette can deal with a maximum of ", max_n,
                 "discrete values;",
                 "you have ", n, ".",
                 " Consider specifying shapes manually if you ",
                 "must have them.", sep = "")
    if (n > max_n) {
      stop(msg, call. = FALSE)
    }
    # circle, square, triangle, plus, cross
    c(1, 0, 2, 3, 4)[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Scales for shapes from "Show Me the Numbers"
#'
#' \code{scale_shape_few} maps discrete variables to five easily
#' discernible shapes. It is based on the shape palette suggested in
#' Few (2012).
#'
#' @param ... Common \code{discrete_scale} parameters. See
#'   \code{\link[ggplot2]{discrete_scale}} for more details.
#'
#' @references Few, S. (2012)
#'   \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten},
#'   Analytics Press, p. 208.
#' @seealso \code{\link{scale_shape_few}} for the shape palette that this
#'   scale uses.
#' @export
scale_shape_few <- function(...) {
  discrete_scale("shape", "few", few_shape_pal(), ...)
}
