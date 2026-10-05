## geom_scale_break_economist() draws the styleguide's broken-scale mark (guide p.25):
## a zigzag between the baseline and the lowest y-axis tick, declaring that
## the scale is truncated. It transforms nothing -- the axis is truncated by
## the scale's own limits.

# Columns are referenced through the `.data` pronoun; the local binding lets
# lintr's object_usage_linter see where the name comes from.
.data <- rlang::.data

truncated_plot <- function(...) {
  ggplot2::ggplot(
    data.frame(x = 2005:2016, y = c(62, 70, 68, 52, 44, 58, 70, 74, 71, 66, 44, 54)),
    ggplot2::aes(.data$x, .data$y)
  ) +
    ggplot2::geom_line() +
    geom_scale_break_economist(...) +
    ggplot2::scale_y_continuous(limits = c(30, 80))
}

test_that("geom_scale_break_economist returns a layer", {
  expect_s3_class(geom_scale_break_economist(), "LayerInstance")
})

test_that("geom_scale_break_economist rejects an unknown side", {
  expect_error(geom_scale_break_economist(side = "top"))
})

test_that("geom_scale_break_economist needs no data of its own", {
  # The layer supplies a dummy row and reads its position from the panel, so
  # it must build against a plot whose own data it never touches.
  expect_no_error(ggplot2::ggplot_build(truncated_plot()))
})

test_that("geom_scale_break_economist draws one polyline in the panel", {
  built <- ggplot2::layer_grob(truncated_plot(), i = 2)[[1]]
  expect_s3_class(built, "polyline")
  # Six points: a flat run, one up-down zigzag, then a flat run.
  expect_length(built$x, 6)
})

test_that("geom_scale_break_economist sits between the baseline and the lowest break", {
  # The guide centres the symbol between the two, so its height must fall
  # below the lowest gridline rather than on or above it.
  built <- ggplot2::layer_grob(truncated_plot(), i = 2)[[1]]
  centre <- as.numeric(grid::convertY(built$y[1], "npc"))
  breaks <- ggplot2::ggplot_build(truncated_plot())$layout$panel_params[[1]]$y$break_positions()
  lowest <- min(breaks[is.finite(breaks) & breaks > 0])
  expect_gt(centre, 0)
  expect_lt(centre, lowest)
})

test_that("geom_scale_break_economist draws at the requested side", {
  right <- ggplot2::layer_grob(truncated_plot(side = "right"), i = 2)[[1]]
  left <- ggplot2::layer_grob(truncated_plot(side = "left"), i = 2)[[1]]
  expect_gt(
    as.numeric(grid::convertX(right$x[1], "npc")),
    as.numeric(grid::convertX(left$x[1], "npc"))
  )
})

test_that("geom_scale_break_economist draws correctly", {
  expect_doppelganger(
    "geom_scale_break_economist",
    truncated_plot() + theme_economist_2017(base_family = "sans")
  )
})
