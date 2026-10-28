test_that("geom_tufteboxplot works", {
  expect_s3_class(geom_tufteboxplot(), "LayerInstance")
})

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

test_that("geom_tufteboxplot draws a horizontal box plot as the transpose of a vertical one", {
  segment_coords <- function(p, along, across) {
    grobs <- ggplot2::layer_grob(p)[[1]]$children
    grobs <- unlist(lapply(grobs, function(g) c(list(g), g$children)), recursive = FALSE)
    seg <- Filter(function(g) inherits(g, "segments"), grobs)[[1]]
    cbind(as.numeric(seg[[paste0(along, "0")]]), as.numeric(seg[[paste0(along, "1")]]), as.numeric(seg[[across]]))
  }
  vertical <- tufteboxplot_plot()
  horizontal <- ggplot(mtcars, aes(.data$mpg, factor(.data$cyl))) + geom_tufteboxplot()
  expect_equal(segment_coords(horizontal, "x", "y0"), segment_coords(vertical, "y", "x0"))
})

test_that("geom_tufteboxplot draws its legend key as a point range", {
  expect_identical(environment(GeomTufteboxplot$draw_key)$f, ggplot2::draw_key_pointrange)
})

test_that("geom_tufteboxplot draws horizontal box plots correctly", {
  horizontal <- function(...) ggplot(mtcars, aes(.data$mpg, factor(.data$cyl))) + geom_tufteboxplot(...)
  expect_doppelganger("geom_tufteboxplot-horizontal", horizontal())
  expect_doppelganger(
    "geom_tufteboxplot-horizontal-line",
    horizontal(median.type = "line", whisker.type = "point")
  )
})
