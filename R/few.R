#' Color Palettes Few "Show Me the Numbers"
#'
#' Qualitative color palettes from Stephen Few (2012)
#' \emph{Show Me the Numbers}. There are three palettes:
#' Light, Medium, and Dark. Each palette comprises nine colors:
#' gray, blue, orange, green, pink, brown, purple, yellow, red.
#' For \code{n = 1}, gray is used. For \code{n > 1}, the eight non-gray
#' colors are used.
#'
#'
#' Use the light palette for filled areas, such as bar charts.
#' Use the medium palette for points and lines.
#' Use the dark palette for highlighting specific points
#' or for small and thin lines and points.
#'
#' @references
#' Few, S. (2012) \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten}.
#' 2nd edition. Analytics Press.
#'
#' \href{https://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical Rules for Using Color in Charts"}.
#'
#' @export
#' @param palette One of \Sexpr[results=rd]{names(ggthemes:::rd_optlist(ggthemes::ggthemes_data$few$colors))}
#' @family colour few
#' @example inst/examples/ex-few_pal.R
few_pal <- function(palette = "Medium") {
  palette <- ggthemes::ggthemes_data$few$colors[[palette]]
  if (is.null(palette)) {
    stop("palette must be one of: ",
         paste0("\"", names(ggthemes::ggthemes_data$few$colors),
                "\"", collapse = ", "), call. = FALSE)
  }
  ## The first value, gray, is used for non-data parts.
  values <- palette[["value"]]
  max_n <- length(values) - 1L
  f <- function(n) {
    check_pal_n(n, max_n)
    if (n == 1L) {
      values[[1L]]
    } else {
      unname(values[2L:(n + 1L)])
    }
  }
  attr(f, "max_n") <- length(values) - 1L
  f
}

#' Color scales from Few's "Practical Rules for Using Color in Charts"
#'
#' See \code{\link{few_pal}()}.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams few_pal
#' @family colour few
#' @rdname scale_few
#' @export
scale_colour_few <- function(palette = "Medium", ...) {
    discrete_scale("colour", "few", few_pal(palette), ...)
}

#' @export
#' @rdname scale_few
scale_color_few <- scale_colour_few

#' @export
#' @rdname scale_few
scale_fill_few <- function(palette = "Light", ...) {
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
#' \url{https://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}.
#'
#' @inheritParams ggplot2::theme_bw
#' @family themes few
#' @export
#' @example inst/examples/ex-theme_few.R
theme_few <- function(base_size = 12, base_family="") {
    gray <- "#4D4D4D"
    black <- "#000000"
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
#' The shape palette consists of five shapes: circle, square, triangle, plus,
#' times.
#'
#' @references Few, S. (2012)
#'   \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten},
#'   Analytics Press, p. 208.
#'
#' @export
few_shape_pal <- function() {
  shapes <- ggthemes::ggthemes_data[["few"]][["shapes"]]
  max_n <- nrow(shapes)
  f <- function(n) {
    check_pal_n(n, max_n)
    shapes[["pch"]][seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' Scales for shapes from "Show Me the Numbers"
#'
#' \code{scale_shape_few()} maps discrete variables to up to five easily
#' discernible shapes. It is based on the shape palette suggested in
#' Few (2012).
#'
#' @param ... Common \code{\link[ggplot2]{discrete_scale}()} parameters.
#' @references Few, S. (2012)
#'   \emph{Show Me the Numbers: Designing Tables and Graphs to Enlighten},
#'   Analytics Press, p. 208.
#' @seealso \code{\link{scale_shape_few}()} for the shape palette that this
#'   scale uses.
#' @export
scale_shape_few <- function(...) {
  discrete_scale("shape", "few", few_shape_pal(), ...)
}
