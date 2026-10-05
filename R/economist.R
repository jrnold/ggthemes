#' Economist color palette (discrete)
#'
#' The classic *The Economist* chart palette: blues, grays, and
#' greens, chosen and ordered for the number of colors requested. Red is
#' not included in these palettes; *The Economist* reserves it to
#' mark important data.
#'
#' @param fill If `TRUE` (the default), use the fill palette; otherwise, use
#'   the line palette. The two palettes choose and order the colors
#'   differently.
#' @family color economist
#' @return A palette function. It takes the number of colors `n` and returns a character vector of `n`
#'   hex colors, and can be used as the `palette` argument of [ggplot2::discrete_scale()].
#' @export
#' @example inst/examples/ex-economist_pal.R
economist_pal <- function(fill = TRUE) {
  colors <- deframe(ggthemes::ggthemes_data[["economist"]][["fg"]])
  if (fill) {
    max_n <- 9
    f <- function(n) {
      check_pal_n(n, max_n)
      if (n == 0L) {
        return(character(0))
      } else if (n == 1L) {
        i <- "dark blue"
      } else if (n == 2L) {
        i <- c("blue", "dark blue")
      } else if (n == 3L) {
        i <- c("blue-gray", "dark blue", "blue")
      } else if (n == 4L) {
        i <- c("blue-gray", "dark blue", "blue", "gray")
      } else if (n %in% 5:6) {
        ## 20120901_woc904
        i <- c(
          "blue-gray",
          "dark blue",
          "light blue",
          "blue",
          "light green",
          "dark green"
        )
      } else if (n == 7L) {
        # 20120818_AMC820
        i <- c(
          "blue-gray",
          "dark blue",
          "blue",
          "light blue",
          "dark green",
          "light green",
          "gray"
        )
      } else if (n >= 8L) {
        # 20120915_EUC094
        i <- c(
          "blue-gray",
          "dark blue",
          "blue",
          "light blue",
          "dark green",
          "light green",
          "dark red",
          "pink",
          "gray"
        )
      }
      unname(colors[i][seq_len(n)])
    }
  } else {
    max_n <- 9
    f <- function(n) {
      check_pal_n(n, max_n)
      if (n <= 3) {
        # 20120818_AMC20
        # 20120901_FBC897
        i <- c("dark blue", "blue", "light blue")
      } else if (n %in% 4:5) {
        # i <- c("dark blue", "blue", "light blue", "red", "gray")
        i <- c("dark blue", "blue", "light blue", "blue-gray", "gray")
      } else if (n == 6) {
        # 20120825_IRC829
        i <- c(
          "light green",
          "dark green",
          "gray",
          "blue-gray",
          "light blue",
          "dark blue"
        )
      } else if (n > 6) {
        # 20120825_IRC829
        i <- c(
          "light green",
          "dark green",
          "gray",
          "blue-gray",
          "light blue",
          "dark blue",
          "dark red",
          "pink",
          "brown"
        )
      }
      unname(colors[i][seq_len(n)])
    }
  }
  attr(f, "max_n") <- max_n
  f
}

#' Economist color scales
#'
#' Color scales using the colors in the Economist graphics.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams economist_pal
#' @family color economist
#' @rdname scale_economist
#' @seealso [theme_economist()] for examples.
#' @return A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_economist.R
scale_colour_economist <- function(...) {
  discrete_scale("colour", palette = economist_pal(), ...)
}

#' @rdname scale_economist
#' @export
scale_color_economist <- scale_colour_economist

#' @rdname scale_economist
#' @export
scale_fill_economist <- function(...) {
  discrete_scale("fill", palette = economist_pal(), ...)
}

#' Economist sequential color palettes
#'
#' The "equal lightness colour scales" of *The Economist visual
#' styleguide* (v1.2, 4 May 2017): six ordered steps for each of nine hues,
#' running darkest to lightest. Use them for ordered data. They come from
#' the paper's 2017 chart design, not the classic design of
#' [economist_pal()] and [theme_economist()].
#'
#' `economist_seq_pal()` returns the six steps themselves, for
#' discrete ordered data. `economist_gradient_pal()` interpolates
#' between them, for continuous data.
#'
#' @param hue A string, the hue of the color scale. One of `"blue"` (the
#'   default), `"cyan"`, `"green"`, `"yellow"`, `"olive"`, `"purple"`,
#'   `"gold"`, `"gray"`, or `"red"`.
#' @family color economist
#' @rdname economist_seq_pal
#' @return `economist_seq_pal()` returns a palette function that takes the number of colors `n` and
#'   returns the first `n` of the six hex colors for `hue`, for use with
#'   [ggplot2::discrete_scale()]. `economist_gradient_pal()` returns a palette function that
#'   takes a numeric vector `x` of values between 0 and 1 and returns hex colors interpolated between
#'   those steps, for use with [ggplot2::continuous_scale()].
#' @export
#' @example inst/examples/ex-economist_seq_pal.R
economist_seq_pal <- function(hue = "blue") {
  colors <- economist_scale_colors(hue)
  max_n <- length(colors)
  f <- function(n) {
    check_pal_n(n, max_n)
    colors[seq_len(n)]
  }
  attr(f, "max_n") <- max_n
  f
}

#' @rdname economist_seq_pal
#' @export
economist_gradient_pal <- function(hue = "blue") {
  scales::gradient_n_pal(colours = economist_scale_colors(hue))
}

economist_scale_colors <- function(hue) {
  scales <- ggthemes::ggthemes_data[["economist"]][["scales"]]
  if (!rlang::is_string(hue) || !hue %in% names(scales)) {
    cli::cli_abort(
      "{.arg hue} must be one of {.val {names(scales)}}, not {.val {hue}}."
    )
  }
  scales[[hue]][["value"]]
}

#' Economist sequential color scales
#'
#' Color scales built from the equal-lightness color scales of *The
#' Economist visual styleguide* (v1.2, 4 May 2017); see
#' [economist_seq_pal()].
#' The `_c` scales are continuous; the `_ordinal` scales are
#' discrete, for ordered factors. See [scale_colour_economist()]
#' for the unordered categorical scales.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams economist_seq_pal
#' @inheritParams ggplot2::continuous_scale
#' @param ... Other arguments passed on to the underlying scale.
#' @family color economist
#' @rdname scale_economist_seq
#' @return A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_economist_seq.R
scale_colour_economist_c <- function(hue = "blue", ..., guide = "colourbar") {
  check_dots_named(...)
  continuous_scale(
    "colour",
    palette = economist_gradient_pal(hue),
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_seq
#' @export
scale_color_economist_c <- scale_colour_economist_c

#' @rdname scale_economist_seq
#' @export
scale_fill_economist_c <- function(hue = "blue", ..., guide = "colourbar") {
  check_dots_named(...)
  continuous_scale(
    "fill",
    palette = economist_gradient_pal(hue),
    guide = guide,
    ...
  )
}

#' @rdname scale_economist_seq
#' @export
scale_colour_economist_ordinal <- function(hue = "blue", ...) {
  discrete_scale("colour", palette = economist_seq_pal(hue), ...)
}

#' @rdname scale_economist_seq
#' @export
scale_color_economist_ordinal <- scale_colour_economist_ordinal

#' @rdname scale_economist_seq
#' @export
scale_fill_economist_ordinal <- function(hue = "blue", ...) {
  discrete_scale("fill", palette = economist_seq_pal(hue), ...)
}

#' ggplot color theme based on the Economist
#'
#' A theme that approximates the style of *The Economist*.
#'
#' [theme_economist()] implements the standard bluish-gray
#' background theme in the print *The Economist* and
#' [economist.com](https://www.economist.com/).
#'
#' [theme_economist_white()] implements a variant with a white
#' panel and light gray (or white) background often used by *The Economist*
#' blog [Graphic Detail](https://www.economist.com/topics/graphic-detail).
#'
#' Use [scale_color_economist()] with this theme.
#' The y axis should be displayed on the right hand side.
#'
#' *The Economist* uses "ITC Officina Sans" as its font for graphs. If
#' you have access to this font, you can use it with the
#' extrafont package. "Verdana" is a good substitute.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal If `TRUE` (the default), draw horizontal grid lines.
#' @param dkpanel If `TRUE`, use a darker background for the panel region. The
#'   default is `FALSE`.
#' @param gray_bg If `TRUE` (the default), use a gray background; otherwise,
#'   use a white background.
#'
#' @return An object of class [ggplot2::theme()].
#'
#' @export
#' @family themes economist
#'
#' @references
#' - [The Economist](https://www.economist.com/)
#' - [Spiekerblog, "ITC Officina Display", January 1, 2007.](https://spiekermann.com/en/itc-officina-display/)
#'
#' @example inst/examples/ex-theme_economist.R
theme_economist <- function(base_size = 10, base_family = "sans", horizontal = TRUE, dkpanel = FALSE) {
  bgcolors <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
  # The panel and strips share the plot's blue-gray. Before 7.0.0 they asked
  # for an "ebg" color the data never defined, so their fill was NA and the
  # plot background showed through; naming the color draws the same thing.
  ## From measurements
  ## Ticks = 1 / 32 in, with margin about 1.5 / 32
  ## Title = 3 / 32 in (6 pt)
  ## Legend Labels = 2.5 / 32 in (5pt)
  ## Axis Labels = 2
  ## Axis Titles and other text ~ 2
  ## Margins: Top / Bottom = 6 / 32, sides = 5 / 32
  ret <-
    theme(
      line = element_line(colour = "black"),
      rect = element_rect(
        fill = unname(bgcolors["blue-gray"]),
        colour = NA,
        linetype = 1
      ),
      text = element_text(colour = "black", family = base_family, size = base_size),
      ## Axis
      axis.line = element_line(linewidth = rel(0.8)),
      axis.line.y = element_blank(),
      axis.text = element_text(size = rel(1)),
      axis.text.x = element_text(
        vjust = 0,
        margin = margin(
          t = base_size,
          unit = "pt"
        )
      ),
      axis.text.x.top = element_text(vjust = 0, margin = margin(b = base_size, unit = "pt")),
      axis.text.y = element_text(
        hjust = 0,
        margin = margin(
          r = base_size,
          unit = "pt"
        )
      ),
      ## I cannot figure out how to get ggplot to do 2 levels of ticks
      ## axis.ticks.margin = unit(3 / 72, "in"),
      axis.ticks = element_line(),
      axis.ticks.y = element_blank(),
      axis.title = element_text(size = rel(1)),
      axis.title.x = element_text(),
      axis.title.y = element_text(angle = 90),
      # axis.ticks.length = unit( -1/32, "in"),
      axis.ticks.length = unit(-base_size * 0.5, "points"),
      legend.background = element_rect(linetype = 0),
      legend.spacing = unit(base_size * 1.5, "points"),
      legend.key = element_rect(linetype = 0),
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = element_text(size = rel(1.25)),
      legend.title = element_text(size = rel(1), hjust = 0),
      legend.position = "top",
      legend.direction = NULL,
      legend.justification = "center",
      ## legend.box = element_rect(fill = palette_economist['bgdk'],
      ## colour=NA, linetype=0),
      ## Economist only uses vertical lines
      panel.background = element_rect(linetype = 0),
      panel.border = element_blank(),
      panel.grid.major = element_line(colour = "white", linewidth = rel(1.75)),
      panel.grid.minor = element_blank(),
      panel.spacing = unit(0.25, "lines"),
      strip.background = element_rect(
        fill = unname(bgcolors["blue-gray"]),
        colour = NA,
        linetype = 0
      ),
      strip.text = element_text(size = rel(1.25)),
      strip.text.x = element_text(),
      strip.text.y = element_text(angle = -90),
      plot.background = element_rect(
        fill = unname(bgcolors["blue-gray"]),
        colour = NA
      ),
      plot.title = element_text(
        size = rel(1.5),
        hjust = 0,
        face = "bold",
        # Without a margin the subtitle runs into the title.
        margin = margin(b = base_size / 2, unit = "pt")
      ),
      plot.margin = unit(c(6, 5, 6, 5) * 2, "points"),
      complete = TRUE
    )
  if (horizontal) {
    ret <- ret + theme(panel.grid.major.x = element_blank())
  } else {
    ret <- ret + theme(panel.grid.major.y = element_blank())
  }
  if (dkpanel == TRUE) {
    ret <- ret +
      theme(
        panel.background = element_rect(
          fill = unname(bgcolors["dark blue-gray"])
        ),
        strip.background = element_rect(
          fill = unname(bgcolors["dark blue-gray"])
        )
      )
  }
  ret
}

#' @rdname theme_economist
#' @export
theme_economist_white <- function(base_size = 11, base_family = "sans", gray_bg = TRUE, horizontal = TRUE) {
  if (gray_bg) {
    bgcolor <- get_colors(c("economist", "bg"), "light gray")
  } else {
    bgcolor <- "white"
  }
  theme_economist(
    base_family = base_family,
    base_size = base_size,
    horizontal = horizontal
  ) +
    theme(
      rect = element_rect(fill = bgcolor),
      plot.background = element_rect(fill = bgcolor),
      panel.background = element_rect(fill = "white"),
      panel.grid.major = element_line(
        colour = get_colors(c("economist", "bg"), "dark gray")
      ),
      strip.background = element_rect(fill = "white")
    )
}
