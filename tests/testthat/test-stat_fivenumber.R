test_that("stat_fivenumber works", {
  expect_s3_class(stat_fivenumber(), "LayerInstance")
})

test_that("stat_fivenumber summarises x when y is discrete", {
  vertical <- ggplot2::layer_data(ggplot2::ggplot(mtcars, ggplot2::aes(factor(cyl), mpg)) + stat_fivenumber())
  horizontal <- ggplot2::layer_data(ggplot2::ggplot(mtcars, ggplot2::aes(mpg, factor(cyl))) + stat_fivenumber())
  expect_true(all(horizontal$flipped_aes))
  expect_equal(horizontal$xmin, vertical$ymin)
  expect_equal(horizontal$xlower, vertical$lower)
  expect_equal(horizontal$xmiddle, vertical$middle)
  expect_equal(horizontal$xupper, vertical$upper)
  expect_equal(horizontal$xmax, vertical$ymax)
  expect_equal(range(horizontal$xmin), range(tapply(mtcars$mpg, mtcars$cyl, min)))
})

test_that("stat_fivenumber orientation can be set explicitly", {
  data <- data.frame(x = c(1, 1, 2, 2, 3), y = c(1, 2, 3, 4, 5))
  p <- ggplot2::ggplot(data, ggplot2::aes(x, y, group = 1)) + stat_fivenumber(orientation = "y")
  expect_true(all(ggplot2::layer_data(p)$flipped_aes))
})
