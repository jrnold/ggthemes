chart_plot <- function(base_size = 6.5) {
  ggplot2::ggplot(data.frame(x = 1:3, y = c(-1, 0, 2)), ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ggplot2::labs(title = "A title") +
    theme_economist(base_size = base_size)
}
built <- function(chart) grid::makeContent(chart)$children[[1]]
grob_named <- function(gt, name) gt$grobs[[which(gt$layout$name == name)]]

# economist_chart() --------------------------------------------------------

test_that("economist_chart returns a drawable grob and checks its arguments", {
  out <- economist_chart(chart_plot())
  expect_s3_class(out, "ggthemes_economist_classic_chart")
  expect_s3_class(out, "grob")
  expect_error(economist_chart(1), "ggplot")
  expect_error(economist_chart(chart_plot(), number = 1:2), "single value")
  expect_error(economist_chart(chart_plot(), tab = 5), "two non-negative")
})

test_that("economist_chart draws a 5pt by 15pt tab in Economist red at the top left", {
  gt <- built(economist_chart(chart_plot()))
  tab <- grob_named(gt, "economist-tab")
  expect_equal(grid::convertUnit(tab$width, "pt", valueOnly = TRUE), 5)
  expect_equal(grid::convertUnit(tab$height, "pt", valueOnly = TRUE), 15)
  expect_equal(tab$gp$fill, "#e3120b")
  expect_equal(tab$just, c("left", "top"))
  expect_false("economist-number" %in% gt$layout$name)
})

test_that("economist_chart scales the tab with the base size, and can leave it off", {
  tab <- grob_named(built(economist_chart(chart_plot(13))), "economist-tab")
  expect_equal(grid::convertUnit(tab$width, "pt", valueOnly = TRUE), 10)
  expect_false("economist-tab" %in% built(economist_chart(chart_plot(), tab = NULL))$layout$name)
})

test_that("economist_chart draws a number box with the number in white", {
  gt <- built(economist_chart(chart_plot(), number = 2))
  box <- grob_named(gt, "economist-number")
  expect_equal(box$children[[1]]$gp$fill, "#518fa6")
  expect_equal(grid::convertUnit(box$children[[1]]$width, "pt", valueOnly = TRUE), 9)
  expect_equal(box$children[[2]]$label, "2")
  expect_equal(box$children[[2]]$gp$col, "white")
})

test_that("economist_chart marks a broken scale in the right axis's cell, at the panel's foot", {
  p <- chart_plot() + ggplot2::scale_y_continuous(position = "right")
  gt <- built(economist_chart(p, scale_break = "right"))
  i <- which(gt$layout$name == "economist-scale-break-1")
  expect_length(i, 1)
  axis <- gt$layout[gt$layout$name == "axis-r", ]
  expect_equal(unlist(gt$layout[i, c("t", "l", "b", "r")]), unlist(axis[, c("t", "l", "b", "r")]))
  mark <- gt$grobs[[i]]
  expect_s3_class(mark, "polyline")
  expect_equal(mark$gp$col, "black")
  # 4.5pt tall at a base size of 6.5.
  expect_equal(diff(range(grid::convertY(mark$y, "pt", valueOnly = TRUE))), 4.5)
  expect_false(any(grepl("scale-break", built(economist_chart(p))$layout$name)))
})

test_that("economist_chart warns when the axis to mark is not drawn", {
  expect_warning(built(economist_chart(chart_plot(), scale_break = "right")), "no right axis")
  expect_error(economist_chart(chart_plot(), scale_break = "top"))
})

test_that("economist_chart draws correctly", {
  expect_doppelganger("economist_chart-number", economist_chart(chart_plot(), number = 3))
  expect_doppelganger(
    "economist_chart-scale-break",
    economist_chart(
      chart_plot() + ggplot2::scale_y_continuous(position = "right", limits = c(-1.5, 2.2)),
      scale_break = "right"
    )
  )
})

# economist_plus_minus() ---------------------------------------------------

test_that("economist_plus_minus drops the signs and marks the sides of zero", {
  expect_equal(economist_plus_minus(c(-10, -5, 0, 5, 10)), c("10", "5", "+\n0\n\u2013", "5", "10"))
  expect_equal(economist_plus_minus(c(-5, 0, 5), direction = "horizontal"), c("5", "\u2013 0 +", "5"))
})

test_that("economist_plus_minus keeps NA breaks and formats decimals alike", {
  expect_equal(economist_plus_minus(c(NA, -0.5, 1)), c(NA, "0.5", "1.0"))
  expect_equal(economist_plus_minus(numeric()), character())
})

test_that("economist_plus_minus checks its arguments", {
  expect_error(economist_plus_minus("a"), "numeric")
  expect_error(economist_plus_minus(1, direction = "up"))
})

test_that("economist_plus_minus_format returns a labeller", {
  f <- economist_plus_minus_format("horizontal")
  expect_type(f, "closure")
  expect_equal(f(c(-1, 0)), economist_plus_minus(c(-1, 0), "horizontal"))
})
