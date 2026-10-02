test_that("geom_tufteboxplot works", {
  expect_s3_class(geom_tufteboxplot(), "LayerInstance")
})

tufteboxplot_plot <- function(...) {
  ggplot(mtcars, aes(factor(cyl), mpg)) + geom_tufteboxplot(...)
}

test_that("geom_tufteboxplot draws without ggplot2 deprecation warnings", {
  expect_no_warning(ggplot2::ggplotGrob(tufteboxplot_plot()))
  expect_no_warning(ggplot2::ggplotGrob(tufteboxplot_plot(median.type = "line")))
  expect_no_warning(ggplot2::ggplotGrob(tufteboxplot_plot(whisker.type = "point")))
})

test_that("geom_tufteboxplot draws its segments with linewidth", {
  segment_lwd <- function(p) {
    grobs <- ggplot2::layer_grob(p)[[1]]$children
    grobs <- unlist(lapply(grobs, function(g) c(list(g), g$children)), recursive = FALSE)
    seg <- Filter(function(g) inherits(g, "segments"), grobs)
    unique(seg[[1]]$gp$lwd)
  }
  expect_equal(segment_lwd(tufteboxplot_plot()), 0.5 * ggplot2::.pt)
  expect_equal(segment_lwd(tufteboxplot_plot(linewidth = 2)), 2 * ggplot2::.pt)
})

test_that("geom_tufteboxplot draws correctly", {
  expect_doppelganger("geom_tufteboxplot", tufteboxplot_plot())
  expect_doppelganger("geom_tufteboxplot-line", tufteboxplot_plot(median.type = "line", whisker.type = "point"))
})
