context("few")
library("ggplot2")

test_that("few_shape_pal works", {
  out <- few_shape_pal()
  expect_is(out, "function")
  expect_true(!is.null(attr(out, "max_n")))

  pal0 <- out(0)
  expect_identical(length(pal0), 0L)
  pal3 <- out(3)
  expect_identical(length(pal3), 3L)
  expect_warning(out(10))

})

test_that("few_shape_pal works", {
  out <- scale_shape_few()
  expect_is(out, c("ScaleDiscrete", "Scale", "ggproto"))
})

test_that("few_pal runs", {
  p <- few_pal("Medium")
  expect_is(p, "function")
  expect_is(attr(p, "max_n"), "integer")
  out <- p(5)
  expect_is(out, "character")
  expect_equal(length(out), 5L)
  # should use the first accent color
  expect_equal(out[[1]],
               ggthemes::ggthemes_data$few$colors$Medium$value[[2]])
  expect_warning(p(10))
})

test_that("few_pal works with n = 1", {
  out <- few_pal("Medium")(1)
  expect_equal(out, ggthemes::ggthemes_data$few$colors$Medium$value[[1]])
})

test_that("few_pal raises error with bad palette", {
  expect_error(few_pal("Foo"))
})

test_that("scale_colour_few works", {
  expect_is(scale_colour_few(), "ScaleDiscrete")
})

test_that("scale_color_few works", {
  expect_equal(scale_color_few(), scale_colour_few())
})

test_that("scale_fill_few works", {
  expect_is(scale_fill_few(), "ScaleDiscrete")
})

test_that("theme_few works", {
  expect_is(theme_few(), "theme")
})

test_that("theme_few draws correctly", {
  df <- data.frame(x = 1:3, y = 1:3, z = c("a", "b", "a"), a = 1)
  plot <- ggplot(df, aes(x, y, colour = z)) +
    geom_point() +
    facet_wrap(~ a)
  expect_doppelganger("theme_few", plot + theme_few())
})
