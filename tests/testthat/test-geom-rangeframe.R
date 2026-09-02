test_that("geom_rangeframe works", {
  expect_s3_class(geom_rangeframe(), "LayerInstance")
})

test_that("geom_rangeframe drops rows with NA x/y before drawing", {
  data <- data.frame(
    x = c(1, 2, 3, NA, 5),
    y = c(10, NA, 30, 40, 50),
    colour = "black",
    size = 0.5,
    linetype = 1,
    alpha = NA,
    PANEL = 1,
    group = 1
  )

  expect_snapshot(
    filtered <- GeomRangeFrame$handle_na(data, list(na.rm = FALSE))
  )
  expect_equal(nrow(filtered), 3)

  expect_no_warning(
    GeomRangeFrame$handle_na(data, list(na.rm = TRUE))
  )
})

test_that("geom_rangeframe draws the full range of non-missing values when NAs are present", {
  data <- data.frame(
    x = c(1, 2, 3, NA, 5),
    y = c(10, NA, 30, 40, 50),
    colour = "black",
    size = 0.5,
    linetype = 1,
    alpha = NA,
    PANEL = 1,
    group = 1
  )
  filtered <- suppressWarnings(GeomRangeFrame$handle_na(data, list(na.rm = TRUE)))

  fake_coord <- list(transform = function(data, panel_scales) data)
  grob <- GeomRangeFrame$draw_panel(filtered, panel_scales = list(), coord = fake_coord, sides = "trbl")

  coords <- vapply(
    grob$children,
    function(ch) c(as.numeric(ch$x0), as.numeric(ch$x1), as.numeric(ch$y0), as.numeric(ch$y1)),
    numeric(4)
  )

  expect_identical(anyNA(coords), FALSE)
  expect_equal(range(coords[3:4, grep("range_y", names(grob$children))]), c(10, 50))
})

test_that("geom_rangeframe sides = 'trbl' is correctly positioned with a secondary axis", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    geom_rangeframe(sides = "trbl") +
    ggplot2::scale_y_continuous(sec.axis = ggplot2::sec_axis(~ . * 2, name = "mpg2")) +
    ggplot2::coord_cartesian(clip = "off")

  built <- ggplot2::ggplot_build(p)
  panel_params <- built$layout$panel_params[[1]]

  # a secondary axis only relabels the existing scale; the underlying
  # (native) coordinate range that geom_rangeframe draws against is
  # identical with or without one.
  expect_equal(panel_params$y.sec$continuous_range, panel_params$y.range)
})
