#' A ggplot theme originated from the pander package
#'
#' The pander package ships with a default theme when the 'unify plots' option is
#' enabled via `panderOptions`, which is now also available outside of pander internals, like `evals`,
#' `eval.msgs` or `Pandoc.brew`.
#' @inheritParams ggplot2::theme_bw
#' @param nomargin Whether to suppress the white space around the plot.
#' @param ff Font family, like `"sans"`. `r lifecycle::badge("deprecated")` Use `base_family` instead.
#' @param fc Font color, as a name or hex code.
#' @param fs Font size (integer). `r lifecycle::badge("deprecated")` Use `base_size` instead.
#' @param gM Whether to draw the major grid.
#' @param gm Whether to draw the minor grid.
#' @param gc Grid color, as a name or hex code.
#' @param gl Grid line type (`lty`).
#' @param boxes Whether to draw a border around the plot.
#' @param bc Background color, as a name or hex code.
#' @param pc Panel background color, as a name or hex code.
#' @param lp Legend position.
#' @param axis Axis label angle, as defined by `par("las")`.
#' @return A ggplot2 theme object (class `theme`).
#' @export
#' @family themes pander
#' @example inst/examples/ex-theme_pander.R
theme_pander <- function(
  base_size = 12, # nolint: cyclocomp_linter
  base_family = "sans",
  nomargin = TRUE,
  ff = NULL,
  fc = "black",
  fs = NULL,
  gM = TRUE, # nolint: object_name_linter
  gm = TRUE,
  gc = "grey",
  gl = "dashed",
  boxes = FALSE,
  bc = "white",
  pc = "transparent",
  lp = "right",
  axis = 1
) {
  if (hasArg(ff)) {
    base_family <- ff
    lifecycle::deprecate_warn("2.0.0", "theme_pander(ff)", "theme_pander(base_family)")
  }
  if (hasArg(fs)) {
    base_size <- fs
    lifecycle::deprecate_warn("2.0.0", "theme_pander(fs)", "theme_pander(base_size)")
  }

  if (requireNamespace("pander", quietly = TRUE)) {
    if (missing(nomargin)) {
      nomargin <- pander::panderOptions("graph.nomargin")
    }
    if (missing(base_family)) {
      base_family <- pander::panderOptions("graph.fontfamily")
    }
    if (missing(fc)) {
      fc <- pander::panderOptions("graph.fontcolor")
    }
    if (missing(base_size)) {
      base_size <- pander::panderOptions("graph.fontsize")
    }
    if (missing(gM)) {
      gM <- pander::panderOptions("graph.grid") # nolint: object_name_linter
    }
    if (missing(gm)) {
      gm <- pander::panderOptions("graph.grid.minor")
    }
    if (missing(gc)) {
      gc <- pander::panderOptions("graph.grid.color")
    }
    if (missing(gl)) {
      gl <- pander::panderOptions("graph.grid.lty")
    }
    if (missing(boxes)) {
      boxes <- pander::panderOptions("graph.boxes")
    }
    if (missing(bc)) {
      bc <- pander::panderOptions("graph.background")
    }
    if (missing(pc)) {
      pc <- pander::panderOptions("graph.panel.background")
    }
    if (missing(lp)) {
      lp <- pander::panderOptions("graph.legend.position")
    }
    if (missing(axis)) {
      axis <- pander::panderOptions("graph.axis.angle")
    }
  }

  ## DRY
  tc <- ifelse(pc == "transparent", bc, pc) # 'transparent' color

  ## default colors, font and legend position
  res <- theme(
    text = element_text(family = base_family),
    plot.background = element_rect(fill = bc, colour = NA),
    panel.grid = element_line(
      colour = gc,
      linewidth = 0.2,
      linetype = gl
    ),
    panel.grid.minor = element_line(linewidth = 0.1),
    axis.ticks = element_line(
      colour = gc,
      linewidth = 0.2
    ),
    plot.title = element_text(
      colour = fc,
      face = "bold",
      size = base_size * 1.2
    ),
    axis.text = element_text(
      colour = fc,
      face = "plain",
      size = base_size * 0.8
    ),
    legend.text = element_text(
      colour = fc,
      face = "plain",
      size = base_size * 0.8
    ),
    legend.title = element_text(
      colour = fc,
      face = "italic",
      size = base_size
    ),
    axis.title.x = element_text(
      colour = fc,
      face = "plain",
      size = base_size
    ),
    strip.text.x = element_text(
      colour = fc,
      face = "plain",
      size = base_size
    ),
    axis.title.y = element_text(
      colour = fc,
      face = "plain",
      size = base_size,
      angle = 90
    ),
    strip.text.y = element_text(
      colour = fc,
      face = "plain",
      size = base_size,
      angle = -90
    ),
    legend.key = element_rect(colour = gc, fill = "transparent"),
    strip.background = element_rect(
      colour = gc,
      fill = "transparent"
    ),
    panel.border = element_rect(fill = NA, colour = gc),
    panel.background = element_rect(fill = pc, colour = gc),
    legend.position = lp
  )

  ## disable box(es) around the plot
  if (!isTRUE(boxes)) {
    res <- res +
      theme(
        legend.key = element_rect(
          colour = "transparent",
          fill = "transparent"
        ),
        strip.background = element_rect(
          colour = "transparent",
          fill = "transparent"
        ),
        panel.border = element_rect(
          fill = NA,
          colour = tc
        ),
        panel.background = element_rect(
          fill = pc,
          colour = tc
        )
      )
  }

  ## disable grid
  if (!isTRUE(gM)) {
    res <- res +
      theme(
        panel.grid = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      )
  }
  ## disable minor grid
  if (!isTRUE(gm)) {
    res <- res + theme(panel.grid.minor = element_blank())
  }

  ## margin
  if (nomargin) {
    res <- res + theme(plot.margin = unit(c(0.1, 0.1, 0.1, 0), "lines"))
  }

  ## axis angle (TODO: DRY with ifelse in the default color etc. section)
  if (axis == 0) {
    res <- res +
      theme(
        axis.text.y = element_text(
          colour = fc,
          family = base_family,
          face = "plain",
          size = base_size * 0.8,
          angle = 90
        )
      )
  }

  if (axis == 2) {
    res <- res +
      theme(
        axis.text.x = element_text(
          colour = fc,
          family = base_family,
          face = "plain",
          size = base_size * 0.8,
          angle = 90,
          hjust = 1
        )
      )
  }

  if (axis == 3) {
    res <- res +
      theme(
        axis.text.y = element_text(
          colour = fc,
          family = base_family,
          face = "plain",
          size = base_size * 0.8,
          angle = 90
        ),
        axis.text.x = element_text(
          colour = fc,
          family = base_family,
          face = "plain",
          size = base_size * 0.8,
          angle = 90,
          hjust = 1
        )
      )
  }

  res
}


#' Color palette from the pander package
#'
#' The pander package ships with a default colorblind and printer-friendly
#' color palette borrowed from <https://jfly.iam.u-tokyo.ac.jp/color/>.
#'
#' @param n Number of colors. This palette supports up to eight colors.
#' @param random_order Whether to shuffle the palette randomly before
#'   rendering each plot.
#' @return A character vector of `n` hex colors, recycled if `n` exceeds the number of colors available.
#'   Unlike the other `*_pal()` functions, this is itself the palette function.
#' @export
#' @family color pander
#' @example inst/examples/ex-palette_pander.R
palette_pander <- function(n, random_order = FALSE) {
  ## default (colorblind and printer-friendly) colors
  cols <- c(
    "#56B4E9",
    "#009E73",
    "#F0E442",
    "#0072B2",
    "#D55E00",
    "#CC79A7",
    "#999999",
    "#E69F00"
  )

  if (requireNamespace("pander", quietly = TRUE)) {
    cols <- pander::panderOptions("graph.colors")
  }

  if (isTRUE(random_order)) {
    cols <- sample(cols)
  }

  if (length(cols) < n) {
    cols <- rep(cols, length.out = n)
  }

  cols[seq_len(n)]
}


#' Color scale from the pander package
#'
#' The pander package ships with a default colorblind and printer-friendly color
#' palette borrowed from <https://jfly.iam.u-tokyo.ac.jp/color/>.
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams palette_pander
#' @family color pander
#' @rdname scale_pander
#' @seealso [theme_pander()]
#' @return A ggplot2 scale object.
#' @export
#' @example inst/examples/ex-scale_pander.R
scale_color_pander <- function(...) {
  discrete_scale("colour", palette = palette_pander, ...)
}


#' @rdname scale_pander
#' @export
scale_colour_pander <- scale_color_pander


#' @rdname scale_pander
#' @export
scale_fill_pander <- function(...) {
  discrete_scale("fill", palette = palette_pander, ...)
}
