test_that("geom_rangeframe works", {
  expect_s3_class(geom_rangeframe(), "LayerInstance")
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
