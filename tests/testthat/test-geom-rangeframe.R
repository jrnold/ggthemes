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

  expect_warning(
    filtered <- GeomRangeFrame$handle_na(data, list(na.rm = FALSE)),
    "missing values"
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

  expect_false(anyNA(coords))
  expect_equal(range(coords[3:4, grep("range_y", names(grob$children))]), c(10, 50))
})
