## geom_ribbon_economist_2024() and geom_gridline_economist_2024() draw two details of the 2024 Economist's line
## charts: a translucent confidence ribbon with hairline edges, and horizontal gridlines that break for a name.

.data <- rlang::.data

ribbon_data <- data.frame(
  x = rep(1:5, 2),
  y = c(1:5, 3:7),
  lo = c(0:4, 2:6),
  hi = c(2:6, 4:8),
  series = rep(c("a", "b"), each = 5)
)

ribbon_plot <- function(...) {
  ggplot2::ggplot(ribbon_data, ggplot2::aes(.data$x, .data$y, colour = .data$series, fill = .data$series)) +
    geom_ribbon_economist_2024(ggplot2::aes(ymin = .data$lo, ymax = .data$hi), ...) +
    ggplot2::geom_line()
}

test_that("geom_ribbon_economist_2024 returns a ribbon and its two edges", {
  layers <- geom_ribbon_economist_2024(ggplot2::aes(x, ymin = lo, ymax = hi, fill = series))
  expect_length(layers, 3)
  expect_s3_class(layers[[1]]$geom, "GeomRibbon")
  expect_s3_class(layers[[2]]$geom, "GeomLine")
  expect_s3_class(layers[[3]]$geom, "GeomLine")
})

test_that("geom_ribbon_economist_2024 needs ymin and ymax", {
  expect_error(geom_ribbon_economist_2024(), "must map")
  expect_error(geom_ribbon_economist_2024(ggplot2::aes(x, ymin = lo)), "must map")
})

test_that("the ribbon has no outline and the edges follow its limits in the series' color", {
  built <- ggplot2::ggplot_build(ribbon_plot())
  ribbon <- built$data[[1]]
  expect_true(all(is.na(ribbon$colour)))
  expect_equal(unique(ribbon$alpha), 0.17)
  lower <- built$data[[2]]
  upper <- built$data[[3]]
  expect_equal(lower$y, ribbon_data$lo[order(ribbon_data$series, ribbon_data$x)])
  expect_equal(upper$y, ribbon_data$hi[order(ribbon_data$series, ribbon_data$x)])
  # The edge takes the color of the ribbon's fill, at the edge opacity.
  expect_equal(unique(lower$alpha), 0.45)
  expect_setequal(lower$colour, unique(ribbon$fill))
})

test_that("opacities and edge width can be set", {
  built <- ggplot2::ggplot_build(ribbon_plot(alpha = 0.3, edge_alpha = 0.6, edge_linewidth = 0.5))
  expect_equal(unique(built$data[[1]]$alpha), 0.3)
  expect_equal(unique(built$data[[2]]$alpha), 0.6)
  expect_equal(unique(built$data[[2]]$linewidth), 0.5 / 0.75 / ggplot2::.pt)
})

test_that("a fixed fill colors the edges too", {
  layers <- geom_ribbon_economist_2024(ggplot2::aes(x, ymin = lo, ymax = hi), fill = "#ED1C24")
  expect_equal(layers[[2]]$aes_params$colour, "#ED1C24")
})

test_that("geom_gridline_economist_2024 breaks a gridline where a gap is", {
  layer <- geom_gridline_economist_2024(c(10, 20), xmin = 0, xmax = 100, gaps = data.frame(y = 20, from = 30, to = 60))
  d <- layer$data
  expect_equal(d[d$y == 10, c("x", "xend")], data.frame(x = 0, xend = 100), ignore_attr = TRUE)
  expect_equal(d[d$y == 20, "x"], c(0, 60))
  expect_equal(d[d$y == 20, "xend"], c(30, 100))
})

test_that("geom_gridline_economist_2024 uses the theme's gridline color and width", {
  spec <- ggthemes_data[["economist_2024"]]
  print_layer <- geom_gridline_economist_2024(10, 0, 1, base_size = 7)
  expect_equal(print_layer$aes_params$colour, spec$print$grid)
  expect_equal(print_layer$aes_params$linewidth, 0.067 * 7 / ggplot2::.pt)
  web_layer <- geom_gridline_economist_2024(10, 0, 1, media = "web")
  expect_equal(web_layer$aes_params$colour, spec$web$grid)
})

test_that("geom_gridline_economist_2024 checks its arguments", {
  expect_error(geom_gridline_economist_2024("a", 0, 1), "numeric")
  expect_error(geom_gridline_economist_2024(1, 0, 1, gaps = data.frame(y = 1)), "columns")
  expect_error(geom_gridline_economist_2024(1, 0, 1, media = "tv"))
})

test_that("both helpers build in a plot", {
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(.data$x, .data$y)) +
    geom_gridline_economist_2024(1:3, 1, 3) +
    ggplot2::geom_line()
  expect_no_error(ggplot2::ggplot_build(p))
  expect_no_error(ggplot2::ggplot_build(ribbon_plot()))
})
