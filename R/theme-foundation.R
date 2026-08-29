#' Foundation Theme
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation()}
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than \code{\link[ggplot2]{theme_gray}()} or \code{\link[ggplot2]{theme_bw}()},
#' because those themes define elements deep in the hierarchy.
#'
#' This theme takes \code{\link[ggplot2]{theme_gray}()} and sets all
#' \code{colour} and \code{fill} values to \code{NULL}, except for the top-level
#' elements (\code{line}, \code{rect}, and \code{title}), which have
#' \code{colour = ink}, and \code{fill = paper}. This leaves the spacing
#' and-non colour defaults of the default \pkg{ggplot2} themes in place.
#'
#' Unlike \code{theme_foundation()}, the other themes in this package (e.g.
#' \code{\link{theme_economist}()}, \code{\link{theme_excel}()},
#' \code{\link{theme_hc}()}) intentionally replicate a fixed, published
#' visual style, so they do not expose \code{ink}/\code{paper}/\code{accent}
#' arguments.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey
theme_foundation <- function(base_size = 12, base_family = "", ink = "black", paper = "white", accent = "#3366FF") {
  if (all(c("ink", "paper", "accent") %in% names(formals(theme_grey)))) {
    thm <- theme_grey(base_size = base_size, base_family = base_family, ink = ink, paper = paper, accent = accent)
  } else {
    thm <- theme_grey(base_size = base_size, base_family = base_family)
  }
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm +
    theme(
      panel.border = element_rect(fill = NA),
      legend.background = element_rect(colour = NA),
      line = element_line(colour = ink),
      rect = element_rect(fill = paper, colour = ink),
      text = element_text(colour = ink)
    )
}
