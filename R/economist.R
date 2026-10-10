#' Economist color palette (discrete)
#'
#' The classic *The Economist* chart palette: blues, grays, and
#' greens, chosen and ordered for the number of colors requested. Red is
#' not included in these palettes; *The Economist* reserves it to
#' mark important data.
#'
#' The fill palette gives the colour sets that the print charts of 2012 to
#' 2015 use most for series of equal emphasis: dark blue for one series;
#' blue and dark blue for two; blue-gray, dark blue and blue for three, with
#' gray added for four; light blue and gray added for five; and light green
#' for a sixth. Stacks run
#' from the baseline outwards in the same order. The charts drew an "other"
#' category in gray, after the other series: give it the last level of the
#' factor and set its colour with [ggplot2::scale_fill_manual()].
#'
#' The colors are the print specs of the palette, inferred as CMYK, rendered
#' through US Web Coated SWOP, as the web images of the print charts usually
#' showed them. The CMYK are in `ggthemes_data$economist$palette` (see
#' [ggthemes_data]).
#'
#' @param fill Use the fill palette. The fill palette (the default) and the
#'   line palette choose and order the colors differently.
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
        # The commonest sets in the print charts of 2012 to 2015: gray is the
        # fifth colour (9 of 25 five-series panels) and light green the sixth.
        i <- c(
          "blue-gray",
          "dark blue",
          "light blue",
          "blue",
          "gray",
          "light green"
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
#' @param hue `character`. One of `"blue"`, `"cyan"`,
#'   `"green"`, `"yellow"`, `"olive"`, `"purple"`,
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
#' @param guide Type of legend. Use `"colourbar"` for continuous
#'   color bars, or `"legend"` for discrete color legends.
#' @param ... Other arguments passed on to the underlying scale.
#' @family color economist
#' @rdname scale_economist_seq
#' @return A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_economist_seq.R
scale_colour_economist_c <- function(hue = "blue", guide = "colourbar", ...) {
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
scale_fill_economist_c <- function(hue = "blue", guide = "colourbar", ...) {
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
#' `theme_economist` implements the standard bluish-gray
#' background theme in the print *The Economist* and
#' [economist.com](https://www.economist.com/).
#'
#' `theme_economist_white` implements a variant with a white
#' panel and light gray (or white) background often used by *The Economist*
#' blog [Graphic Detail](https://www.economist.com/topics/graphic-detail).
#'
#' Use [scale_color_economist()] with this theme.
#' The y axis should be displayed on the right hand side.
#'
#' Every size in the theme is in base sizes, so a chart keeps its proportions
#' at any `base_size`. They were measured on the print charts of 2012 to 2018
#' in a corpus of *The Economist*'s charts, whose one-column charts are 160pt
#' wide and set in a base size of about 6.5pt: the title is 1.45 base sizes, the
#' subtitle 1.15 and the source line 0.95, all flush left with the chart; the
#' margins at the sides are 1.9 base sizes; and the white gridlines are 0.08
#' base sizes wide. Ticks and the margins around axis titles are those of the
#' 2017 style guide, in base sizes (see [theme_economist_2017()]), but the ticks
#' point into the panel. Use `base_size = 6.5` for a chart 160pt (2.2in) across
#' and scale it up in proportion for a larger one.
#'
#' *The Economist* uses "ITC Officina Sans" as its font for graphs. If
#' you have access to this font, you can use it with the
#' extrafont package. "Verdana" is a good substitute.
#'
#' @inheritParams ggplot2::theme_grey
#' @param horizontal `logical` Horizontal axis lines?
#' @param dkpanel `logical` Darker background for panel region? The panels
#'   and strips are a darker blue-gray than the plot's ground, as in the
#'   charts with panels of 2012 to mid-2015.
#' @param lightpanel `logical` Lighter background for panel region? The plot's
#'   ground is a deeper blue-gray and the panels are paler than it, as in the
#'   charts with panels from the second half of 2015, which replaced the
#'   darker panels of `dkpanel`: the same two colors, swapped. The panel headings (strips) stay on the
#'   ground. Use at most one of `dkpanel` and `lightpanel`.
#' @param gray_bg `logical` If `TRUE`, use gray background, else
#'   use white background.
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
theme_economist <- function(
  base_size = 10,
  base_family = "sans",
  horizontal = TRUE,
  dkpanel = FALSE,
  lightpanel = FALSE
) {
  if (isTRUE(dkpanel) && isTRUE(lightpanel)) {
    cli::cli_abort(c(
      "{.arg dkpanel} and {.arg lightpanel} cannot both be {.code TRUE}.",
      "i" = "A panel is either darker ({.arg dkpanel}) or lighter ({.arg lightpanel}) than the ground."
    ))
  }
  bgcolors <- deframe(ggthemes::ggthemes_data[["economist"]][["bg"]])
  # The panel and strips share the plot's blue-gray. Before 7.0.0 they asked
  # for an "ebg" color the data never defined, so their fill was NA and the
  # plot background showed through; naming the color draws the same thing.
  #
  # Sizes and weights follow the chart corpus of 2012 to 2018, measured on the
  # one-column charts, which are 160pt wide, set in a base size of 6.5pt (so
  # the axis text is 6.5pt and the chart is 24.6 base sizes across). Everything
  # below is in base sizes, so a chart at another size keeps its proportions:
  # * title cap height 6.3pt, about 9.5pt type: 1.45 base sizes; subtitle 5.0pt
  #   cap height, about 7.6pt type: 1.15; source line about 6.3pt: 0.95;
  # * title, subtitle and source start 12.2pt from the chart's left edge and
  #   the axis labels end 12.2pt from its right edge: 1.9 base sizes;
  # * white gridlines 0.53pt: 0.08 base sizes; the black axis rule about 0.3pt.
  # Where the corpus does not say (tick length, the size of legend keys) the
  # theme keeps its earlier values, in base sizes.
  lw <- function(pt) pt / (ggplot2::.pt * 0.75)
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
      axis.line = element_line(linewidth = lw(0.046 * base_size)),
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
      # The value axis of most charts is on the right, its labels ranged right,
      # flush with the chart's right margin, and set off from the panel.
      axis.text.y.right = element_text(hjust = 1, margin = margin(l = base_size * 0.6, unit = "pt")),
      ## I cannot figure out how to get ggplot to do 2 levels of ticks
      ## axis.ticks.margin = unit(3 / 72, "in"),
      # Ticks have the size of the 2017 guide's (0.4pt wide, 5pt long beside 7pt
      # axis labels, 3pt for the minor ticks), but point into the panel, as the
      # classic charts' do.
      axis.ticks = element_line(linewidth = lw(0.4 / 7 * base_size)),
      axis.ticks.y = element_blank(),
      axis.ticks.length = unit(-base_size * 5 / 7, "points"),
      axis.minor.ticks.length = rel(0.6),
      # Axis titles are set off from their labels by the 2017 guide's margins,
      # in base sizes: 0.5pt above or below an x axis, 3pt beside a y axis.
      axis.title = element_text(size = rel(1)),
      axis.title.x = element_text(margin = margin(t = base_size * 0.5 / 7, unit = "pt")),
      axis.title.x.top = element_text(margin = margin(b = base_size * 0.5 / 7, unit = "pt")),
      axis.title.y = element_text(angle = 90, margin = margin(r = base_size * 3 / 7, unit = "pt")),
      axis.title.y.right = element_text(angle = -90, margin = margin(l = base_size * 3 / 7, unit = "pt")),
      legend.background = element_rect(linetype = 0),
      legend.spacing = unit(base_size * 1.5, "points"),
      legend.key = element_rect(linetype = 0),
      # Sized in base sizes, not in "lines", which follow the default font and
      # so did not shrink with base_size.
      legend.key.size = unit(base_size, "points"),
      legend.key.height = unit(base_size, "points"),
      legend.key.width = unit(base_size * 1.6, "points"),
      # The key sits close under the subtitle and over the panel, flush with
      # the title, its entries a base size apart, as in the corpus's charts.
      legend.margin = margin(0, 0, 0, 0),
      legend.box.spacing = unit(base_size * 0.6, "points"),
      legend.key.spacing.x = unit(base_size, "points"),
      legend.key.spacing.y = unit(base_size * 0.2, "points"),
      legend.text = element_text(size = rel(1), margin = margin(l = base_size * 0.4, unit = "pt")),
      legend.title = element_text(size = rel(1), hjust = 0),
      legend.position = "top",
      legend.direction = NULL,
      # The key sits under the subtitle, flush with the chart's left margin.
      legend.justification = "left",
      legend.location = "plot",
      ## legend.box = element_rect(fill = palette_economist['bgdk'],
      ## colour=NA, linetype=0),
      ## Economist only uses vertical lines
      panel.background = element_rect(linetype = 0),
      panel.border = element_blank(),
      panel.grid.major = element_line(colour = "white", linewidth = lw(0.08 * base_size)),
      panel.grid.minor = element_blank(),
      panel.spacing = unit(0.25, "lines"),
      strip.background = element_rect(
        fill = unname(bgcolors["blue-gray"]),
        colour = NA,
        linetype = 0
      ),
      # Panel headings are flush left in the charts, as large as the subtitle.
      strip.text = element_text(size = rel(1.15), hjust = 0),
      strip.text.x = element_text(),
      strip.text.y = element_text(angle = -90),
      plot.background = element_rect(
        fill = unname(bgcolors["blue-gray"]),
        colour = NA
      ),
      plot.title = element_text(
        size = rel(1.45),
        hjust = 0,
        face = "bold",
        # Without a margin the subtitle runs into the title.
        margin = margin(b = base_size / 2, unit = "pt")
      ),
      plot.subtitle = element_text(
        size = rel(1.15),
        hjust = 0,
        margin = margin(b = base_size, unit = "pt")
      ),
      plot.caption = element_text(
        size = rel(0.95),
        hjust = 0,
        margin = margin(t = base_size, unit = "pt")
      ),
      # Title, subtitle and source line start at the chart's left margin, not
      # at the panel, which sits further in beside the axis labels.
      plot.title.position = "plot",
      plot.caption.position = "plot",
      plot.margin = unit(c(1.2, 1.9, 1.2, 1.9) * base_size, "points"),
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
  if (lightpanel == TRUE) {
    # A deep ground with paler panels. The strips hold the panel headings, which
    # sit on the ground, not on the panels, so they take the ground's color. So
    # do the legend keys, which would otherwise inherit the panel's fill and sit
    # on pale chips.
    ground <- unname(bgcolors["deep blue-gray"])
    ret <- ret +
      theme(
        rect = element_rect(fill = ground),
        plot.background = element_rect(fill = ground),
        strip.background = element_rect(fill = ground),
        legend.key = element_rect(fill = ground),
        panel.background = element_rect(fill = unname(bgcolors["pale blue-gray"]))
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
