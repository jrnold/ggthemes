#' Axis guide with labels sitting on their gridlines
#'
#' A y-axis guide that draws each value label inside the panel, just above
#' its gridline and flush with the panel's edge, as *The Economist*
#' does. The gridlines run underneath the labels to the edge of the chart,
#' so the axis takes up no width of its own and the panel fills it instead.
#'
#' The labels take their font, size and color from the theme's
#' `axis.text.y.left` or `axis.text.y.right` element. Their alignment comes
#' from the guide, so the element's `hjust`, `vjust` and `margin` have no
#' effect. Only the labels are drawn: there are no ticks and no axis line,
#' which the styleguide omits on the value axis.
#'
#' The top label sits above the top gridline, so it extends a little above
#' the panel. Leave room for it, as [theme_economist_2017()] does.
#'
#' Only vertical axes are drawn this way. On an x axis the guide falls back
#' to [ggplot2::guide_axis()], dropping any label that would overprint its
#' neighbour, as when a horizontal bar chart's value axis runs along the top.
#'
#' @param title A character string or expression for the axis title. The
#'   default, [ggplot2::waiver()], takes the title from the scale.
#' @param gap Distance between a label's baseline and its gridline, as a
#'   [grid::unit()]. The default, `NULL`, is one seventh of the label's font
#'   size: the 1pt the styleguide gives 7pt axis labels (p.6).
#' @param order A positive integer giving the order of this guide among
#'   multiple guides, or `0` to let ggplot2 decide.
#' @param position Where the axis is drawn, `"left"` or `"right"`. The
#'   default, [ggplot2::waiver()], uses the scale's position.
#'
#' @return A guide object, for the `guide` argument of a position scale or
#'   for [ggplot2::guides()].
#'
#' @references
#' *The Economist visual styleguide*, v1.2, 4 May 2017 (internal;
#' Matt McLean), pp.6-7.
#'
#' @family economist 2017
#' @export
#' @example inst/examples/ex-guide_axis_economist.R
guide_axis_economist <- function(
  title = ggplot2::waiver(),
  gap = NULL,
  order = 0,
  position = ggplot2::waiver()
) {
  if (!is.null(gap) && !grid::is.unit(gap)) {
    cli::cli_abort("{.arg gap} must be a {.cls unit} or {.code NULL}.")
  }
  ggplot2::new_guide(
    title = title,
    theme = NULL,
    # A horizontal axis falls back to guide_axis(); there, drop a label that
    # would overprint its neighbour rather than draw both.
    check.overlap = TRUE,
    angle = NULL,
    n.dodge = 1,
    minor.ticks = FALSE,
    cap = "none",
    gap = gap,
    available_aes = c("x", "y"),
    order = order,
    position = position,
    name = "axis",
    super = GuideAxisEconomist
  )
}

#' @rdname guide_axis_economist
#' @format NULL
#' @usage NULL
#' @export
# nolint start: object_name_linter
GuideAxisEconomist <- ggplot2::ggproto(
  "GuideAxisEconomist",
  ggplot2::GuideAxis,
  params = c(ggplot2::GuideAxis$params, list(gap = NULL)),

  draw = function(self, theme, position = NULL, direction = NULL, params = self$params) {
    position <- position %||% params$position
    if (!position %in% c("left", "right")) {
      return(ggplot2::ggproto_parent(ggplot2::GuideAxis, self)$draw(
        theme,
        position,
        direction,
        params
      ))
    }
    if (!is.null(params$theme)) {
      theme <- theme + params$theme
    }
    element <- ggplot2::calc_element(paste0("axis.text.y.", position), theme)
    key <- params$key
    if (inherits(element, "element_blank") || NROW(key) == 0) {
      return(ggplot2::zeroGrob())
    }
    gap <- params$gap %||% grid::unit(element$size / 7, "pt")
    # The axis cell sits beside the panel, so x = 0 is the panel's right edge
    # (for a right axis) and x = 1 its left edge (for a left axis). Aligning
    # the labels away from the cell draws them back into the panel.
    right <- position == "right"
    labels <- ggplot2::element_grob(
      element,
      label = key$.label,
      x = grid::unit(if (right) 0 else 1, "npc"),
      y = grid::unit(key$y, "npc") + gap,
      hjust = if (right) 1 else 0,
      vjust = 0,
      margin_x = FALSE,
      margin_y = FALSE
    )
    # Zero width, so the panel extends across the space an axis would take.
    gt <- gtable::gtable(widths = grid::unit(0, "pt"), heights = grid::unit(1, "npc"))
    gtable::gtable_add_grob(gt, labels, t = 1, l = 1, clip = "off", name = "labels")
  }
)
# nolint end
