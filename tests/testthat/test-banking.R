test_that("bank_slopes runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y)
  expect_equal(length(out), 1L)
  expect_type(out, "double")
})

test_that("bank_slopes with method=\"as\" runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y, method = "as")
  expect_equal(length(out), 1L)
  expect_type(out, "double")
})

test_that("bank_slopes with invalid method throws error", {
  expect_error(bank_slopes(1:5, 1:5, method = "aor"))
})

test_that("bank_slopes works with cull = TRUE", {
  x <- c(1, 1, 2)
  y <- runif(length(x))
  out <- bank_slopes(x, y, cull = TRUE)
  expect_equal(length(out), 1L)
  expect_type(out, "double")
})

test_that("bank_slopes with method=\"ao\" runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y, method = "ao")
  expect_equal(length(out), 1L)
  expect_type(out, "double")
})

test_that("bank_slopes with method=\"ao\" matches analytic solution for equal-magnitude slopes", {
  # All segments have the same normalized absolute slope, so the average
  # orientation is just atan(1/alpha) = pi/4, i.e. alpha = 1, giving y/x = 1.
  x <- c(0, 1, 2)
  y <- c(0, 2, 4)
  out <- bank_slopes(x, y, method = "ao")
  expect_equal(out, 1, tolerance = 1e-6)
})

test_that("bank_slopes with method=\"was\" runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y, method = "was")
  expect_equal(length(out), 1L)
  expect_type(out, "double")
})

test_that("bank_slopes with method=\"was\" weights slopes by segment run (dx)", {
  # Segment 1: dx = 1, slope = 1. Segment 2: dx = 2, slope = 0.5.
  # Rx = 3, Ry = 2, so normalized slopes are 1.5 and 0.75.
  # Weighted (by dx) mean: (1.5*1 + 0.75*2) / 3 = 1, so y/x = 1.
  # The unweighted average ("as") would instead give alpha = 1.125.
  x <- c(0, 1, 3)
  y <- c(0, 1, 2)
  out <- bank_slopes(x, y, method = "was")
  expect_equal(out, 1, tolerance = 1e-6)
})

test_that("bank_plot runs and returns a ggplot with a numeric coord_fixed ratio", {
  df <- data.frame(x = 1:5, y = runif(5))
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  out <- bank_plot(p)
  expect_s3_class(out, "gg")
  expect_s3_class(out$coordinates, "CoordCartesian")
  expect_type(out$coordinates$ratio, "double")
})

test_that("bank_plot's ratio matches bank_slopes() on the same ungrouped data", {
  x <- c(0, 1, 3)
  y <- c(0, 1, 2)
  df <- data.frame(x = x, y = y)
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  out <- bank_plot(p, method = "as")
  expect_equal(out$coordinates$ratio, bank_slopes(x, y, method = "as"))
})

test_that("bank_plot computes slopes within groups, not across group boundaries", {
  # Group "a": x = 0,1,2; y = 0,1,2 (slopes 1, 1).
  # Group "b": x = 0,1,3; y = 0,2,4 (slopes 2, 1, weighted by dx = 1, 2).
  # A naive diff() over the concatenated rows would also produce a bogus
  # segment linking the last point of "a" to the first point of "b".
  df <- data.frame(
    x = c(0, 1, 2, 0, 1, 3),
    y = c(0, 1, 2, 0, 2, 4),
    g = rep(c("a", "b"), each = 3)
  )
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, group = g)) + ggplot2::geom_line()
  out <- bank_plot(p, method = "was")
  expect_equal(out$coordinates$ratio, 1 / 0.9, tolerance = 1e-6)
})

test_that("bank_plot errors for an out-of-range layer index", {
  df <- data.frame(x = 1:5, y = runif(5))
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expect_error(bank_plot(p, layer = 2), regexp = "layer")
})

test_that("bank_plot errors when the layer has no x/y columns", {
  expect_error(check_bank_plot_data(data.frame(xmin = 1:3, xmax = 2:4)), regexp = "x.*y")
})
