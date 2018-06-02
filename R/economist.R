#' Economist color palette (discrete)
#'
#' The hues in the palette are blues, grays, and greens. Red is not
#' included in these palettes and should be used to indicate
#' important data.
#'
#' @param fill Use the fill palette.
#' @family colour economist
#' @export
#' @example inst/examples/ex-economist_pal.R
economist_pal <- function(fill=TRUE) {
  colors <- deframe(ggthemes::GGTHEMES[["economist"]][["fg"]])
  max_n <- length(colors)
  if (fill) {
    function(n) {
      assert_that(n < max_n)
      assert_that(n > 0)
      if (n == 1) {
        i <- "blue_dark"
      } else if (n == 2) {
        i <- c("blue_mid", "blue_dark")
      } else if (n == 3) {
        i <- c("blue_gray", "blue_dark", "blue_mid")
      } else if (n == 4) {
        i <- c("blue_gray", "blue_dark", "blue_mid", "gray")
      } else if (n %in% 5:6) {
        ## 20120901_woc904
        i <- c("blue_gray", "blue_dark", "blue_light", "blue_mid",
               "green_light", "green_dark")
      } else if (n == 7) {
        # 20120818_AMC820
        i <- c("blue_gray", "blue_dark", "blue_mid", "blue_light",
               "green_dark", "green_light", "gray")
      } else if (n >= 8) {
        # 20120915_EUC094
        i <- c("blue_gray", "blue_dark", "blue_mid", "blue_light",
               "green_dark", "green_light", "red_dark", "red_light",
               "gray")
      }
      unname(colors[i][seq_len(n)])
    }
  } else {
    function(n) {
      assert_that(n > 0)
      assert_that(n <= max_n)
      if (n <= 3) {
        # 20120818_AMC20
        # 20120901_FBC897
        i <- c("blue_dark", "blue_mid", "blue_light")
      } else if (n %in% 4:5) {
        # i <- c("blue_dark", "blue_mid", "blue_light", "red", "gray")
        i <- c("blue_dark", "blue_mid", "blue_light", "blue_gray", "gray")
      } else if (n == 6) {
        # 20120825_IRC829
        i <- c("green_light", "green_dark", "gray",
               "blue_gray", "blue_light", "blue_dark")
      } else if (n > 6) {
        # 20120825_IRC829
        i <- c("green_light", "green_dark", "gray",
               "blue_gray", "blue_light", "blue_dark", "red_dark",
               "red_light", "brown")

      }
      unname(colors[i][seq_len(n)])
    }
  }
}


#' Economist color scales
#'
#' Color scales using the colors in the Economist graphics.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams economist_pal
#' @family colour economist
#' @rdname scale_economist
#' @seealso \code{\link{theme_economist}} for examples.
#' @export
scale_colour_economist <- function(...) {
  discrete_scale("colour", "economist", economist_pal(), ...)
}

#' @rdname scale_economist
#' @export
scale_color_economist <- scale_colour_economist

#' @rdname scale_economist
#' @export
scale_fill_economist <- function(...) {
  discrete_scale("fill", "economist", economist_pal(), ...)
}

#' ggplot color theme based on the Economist
#'
#' A theme that approximates the style of \emph{The Economist}.
#'
#' \code{theme_economist} implements the standard bluish-gray
#' background theme in the print \emph{The Economist} and
#' \href{http://economist.com}{economist.com}.
#'
#' \code{theme_economist_white} implements a variant with a while
#' panel and light gray (or white) background often used by \emph{The Economist}
#' blog \href{http://www.economist.com/blogs/graphicdetail}{Graphic Detail}.
#'
#' Use \code{\link{scale_color_economist}} with this theme.
#' The x axis should be displayed on the right hand side.
#'
#' \emph{The Economist} uses "ITC Officina Sans" as its font for graphs. If
#' you have access to this font, you can use it with the
#' \pkg{extrafont} package. "Verdana" is a good substitute.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal \code{logical} Horizontal axis lines?
#' @param dkpanel \code{logical} Darker background for panel region?
#' @param gray_bg \code{logical} If \code{TRUE}, use gray background, else
#'    use white
#' background.
#'
#' @return An object of class \code{\link{theme}}.
#'
#' @export
#' @family themes economist
#'
#' @references
#' \itemize{
#' \item \href{http://economist.com}{The Economist}
#' \item \href{http://spiekermann.com/en/itc-officina-display/}{Spiekerblog, "ITC Officina Display", January 1, 2007.}
#' \item \url{http://www.economist.com/help/about-us}
#' }
#'
#' @seealso \code{\link[latticeExtra]{theEconomist.theme}} for an Economist
#' theme for lattice plots.
#'
#' @example inst/examples/ex-theme_economist.R
theme_economist <- function(base_size = 10, base_family = "sans",
                            horizontal = TRUE, dkpanel = FALSE) {
  bgcolors <- deframe(ggthemes::GGTHEMES[["economist"]][["bg"]])
  ## From measurements
  ## Ticks = 1 / 32 in, with margin about 1.5 / 32
  ## Title = 3 / 32 in (6 pt)
  ## Legend Labels = 2.5 / 32 in (5pt)
  ## Axis Labels = 2
  ## Axis Titles and other text ~ 2
  ## Margins: Top / Bottom = 6 / 32, sides = 5 / 32
  ret <-
    theme_foundation(base_size = base_size, base_family = base_family) +
    theme(line = element_line(colour = "black"),
          rect = element_rect(fill = bgcolors["ebg"], colour = NA,
                              linetype = 1),
          text = element_text(colour = "black"),
          ## Axis
          axis.line = element_line(size = rel(0.8)),
          axis.line.y = element_blank(),
          axis.text = element_text(size = rel(1)),
          axis.text.x = element_text(vjust = 0,
                                     margin = margin(t = base_size,
                                                     unit = "pt")),
          axis.text.y = element_text(hjust = 0,
                                     margin = margin(r = base_size,
                                                     unit = "pt")),
          ## I cannot figure out how to get ggplot to do 2 levels of ticks
          ## axis.ticks.margin = unit(3 / 72, "in"),
          axis.ticks = element_line(),
          axis.ticks.y = element_blank(),
          axis.title = element_text(size = rel(1)),
          axis.title.x = element_text(),
          axis.title.y = element_text(angle = 90),
          # axis.ticks.length = unit( -1/32, "in"),
          axis.ticks.length = unit( -base_size * 0.5, "points"),
          legend.background = element_rect(linetype = 0),
          legend.spacing = unit(base_size * 1.5, "points"),
          legend.key = element_rect(linetype = 0),
          legend.key.size = unit(1.2, "lines"),
          legend.key.height = NULL,
          legend.key.width = NULL,
          legend.text = element_text(size = rel(1.25)),
          legend.text.align = NULL,
          legend.title = element_text(size = rel(1),  hjust = 0),
          legend.title.align = NULL,
          legend.position = "top",
          legend.direction = NULL,
          legend.justification = "center",
          ## legend.box = element_rect(fill = palette_economist['bgdk'],
          ## colour=NA, linetype=0),
          ## Economist only uses vertical lines
          panel.background = element_rect(linetype = 0),
          panel.border = element_blank(),
          panel.grid.major = element_line(colour = "white", size = rel(1.75)),
          panel.grid.minor = element_blank(),
          panel.spacing = unit(0.25, "lines"),
          strip.background = element_rect(fill = bgcolors["ebg"],
                                          colour = NA, linetype = 0),
          strip.text = element_text(size = rel(1.25)),
          strip.text.x = element_text(),
          strip.text.y = element_text(angle = -90),
          plot.background = element_rect(fill = bgcolors["ebg"], colour = NA),
          plot.title = element_text(size = rel(1.5),
                                    hjust = 0, face = "bold"),
          plot.margin = unit(c(6, 5, 6, 5) * 2, "points"),
          complete = TRUE)
  if (horizontal) {
    ret <- ret + theme(panel.grid.major.x = element_blank())
  } else {
    ret <- ret + theme(panel.grid.major.y = element_blank())
  }
  if (dkpanel == TRUE) {
    ret <- ret + theme(panel.background =
                         element_rect(fill = bgcolors["edkbg"]),
                       strip.background =
                         element_rect(fill = bgcolors["edkbg"]))
  }
  ret
}

#' @rdname theme_economist
#' @export
theme_economist_white <- function(base_size = 11, base_family = "sans",
                                  gray_bg = TRUE, horizontal = TRUE) {
  if (gray_bg) {
    bgcolor <- ggthemes_data$economist$bg["ltgray"]
  } else {
    bgcolor <- "white"
  }
  (theme_economist(base_family = base_family,
                   base_size = base_size,
                   horizontal = horizontal)
  + theme(rect = element_rect(fill = bgcolor),
          plot.background = element_rect(fill = bgcolor),
          panel.background = element_rect(fill = "white"),
          panel.grid.major =
            element_line(colour = ggthemes_data$economist$bg["dkgray"]),
          strip.background = element_rect(fill = "white")))
}
