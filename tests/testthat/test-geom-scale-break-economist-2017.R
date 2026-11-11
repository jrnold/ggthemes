## geom_scale_break_economist_2017() draws the styleguide's broken-scale mark (guide p.25):
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
    geom_scale_break_economist_2017(...) +
    ggplot2::scale_y_continuous(limits = c(30, 80))
}

test_that("geom_scale_break_economist_2017 returns a layer", {
  expect_s3_class(geom_scale_break_economist_2017(), "LayerInstance")
})

test_that("geom_scale_break_economist_2017 rejects an unknown side", {
  expect_error(geom_scale_break_economist_2017(side = "top"))
})

test_that("geom_scale_break_economist_2017 needs no data of its own", {
  # The layer supplies a dummy row and reads its position from the panel, so
  # it must build against a plot whose own data it never touches.
  expect_no_error(ggplot2::ggplot_build(truncated_plot()))
})

test_that("geom_scale_break_economist_2017 draws one polyline in the panel", {
  built <- ggplot2::layer_grob(truncated_plot(), i = 2)[[1]]
  expect_s3_class(built, "polyline")
  # Six points: a flat run, one up-down zigzag, then a flat run.
  expect_length(built$x, 6)
})

test_that("geom_scale_break_economist_2017 sits between the baseline and the lowest break", {
  # The guide centres the symbol between the two, so its height must fall
  # below the lowest gridline rather than on or above it.
  built <- ggplot2::layer_grob(truncated_plot(), i = 2)[[1]]
  centre <- as.numeric(grid::convertY(built$y[1], "npc"))
  breaks <- ggplot2::ggplot_build(truncated_plot())$layout$panel_params[[1]]$y$break_positions()
  lowest <- min(breaks[is.finite(breaks) & breaks > 0])
  expect_gt(centre, 0)
  expect_lt(centre, lowest)
})

test_that("geom_scale_break_economist_2017 rests on the baseline when the lowest break is on it", {
  # With no expansion the lowest break, 30, is the baseline, so there is no
  # gap below it; the symbol sits on the baseline, not between 30 and 40.
  p <- truncated_plot() + ggplot2::coord_cartesian(expand = FALSE)
  built <- ggplot2::layer_grob(p, i = 2)[[1]]
  expect_equal(as.numeric(grid::convertY(built$y[1], "pt")), 4 / 2)
})

test_that("geom_scale_break_economist_2017 draws at the requested side", {
  right <- ggplot2::layer_grob(truncated_plot(side = "right"), i = 2)[[1]]
  left <- ggplot2::layer_grob(truncated_plot(side = "left"), i = 2)[[1]]
  expect_gt(
    as.numeric(grid::convertX(right$x[1], "npc")),
    as.numeric(grid::convertX(left$x[1], "npc"))
  )
})

test_that("geom_scale_break_economist_2017 draws correctly", {
  expect_doppelganger(
    "geom_scale_break_economist_2017",
    truncated_plot() + theme_economist_2017(base_family = "sans", base_size = 7)
  )
})

test_that("geom_scale_break_economist_2017 draws in every panel when a facet variable is named x", {
  d <- data.frame(x = rep(1:4, each = 2), y = c(30, 80))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    geom_scale_break_economist_2017() +
    ggplot2::facet_wrap(~x)
  expect_equal(as.vector(table(ggplot2::layer_data(p, 2)$PANEL)), rep(1, 4))
})

test_that("geom_scale_break_economist_2017 asks for a Cartesian coord", {
  p <- truncated_plot() + ggplot2::coord_polar()
  expect_error(ggplot2::ggplotGrob(p), "Cartesian")
})
