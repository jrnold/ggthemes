test_that("tableau_color_pal works", {
  pal <- tableau_color_pal()
  expect_type(pal, "closure")
  expect_type(attr(pal, "max_n"), "integer")
  n <- 3
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("tableau_color_pal direction = -1 works", {
  n <- 4L
  expect_equal(tableau_color_pal(direction = -1)(n), rev(tableau_color_pal()(n)))
})

test_that("tableau_color_pal works with diverging palette", {
  n <- 3L
  pal <- tableau_color_pal("Orange-Blue Diverging", type = "ordered-diverging")(n)
  expect_type(pal, "character")
  expect_equal(length(pal), n)
})

test_that("tableau_color_pal raises error with invalid palette", {
  expect_snapshot(tableau_color_pal("dsaga"), error = TRUE)
})

test_that("tableau_shape_pal raises error with bad palette", {
  expect_snapshot(tableau_shape_pal(palette = "gender"), error = TRUE)
})

test_that("tableau_shape_pal works", {
  n <- 3
  pal <- tableau_shape_pal()(n)
  expect_type(pal, "integer")
  expect_type(attr(tableau_shape_pal(), "max_n"), "integer")
  # Base pch by default; the glyph branch is covered in test-shape-pal.R.
  expect_contains(c(0:25, 32:127), pal)
  expect_equal(length(pal), n)
})

test_that("scale_shape_tableau works", {
  expect_s3_class(scale_shape_tableau(), "ScaleDiscrete")
})

test_that("scale_colour_tableau works", {
  expect_s3_class(scale_colour_tableau(), "ScaleDiscrete")
})

test_that("scale_colour_tableau works with diverging scales", {
  expect_s3_class(
    scale_colour_tableau(
      type = "ordered-diverging",
      palette = "Orange-Blue Diverging"
    ),
    "ScaleDiscrete"
  )
})

test_that("scale_colour_tableau works with sequential scales", {
  expect_s3_class(
    scale_colour_tableau(
      type = "ordered-sequential",
      palette = "Blue-Green Sequential"
    ),
    "ScaleDiscrete"
  )
})

test_that("scale_fill_tableau works", {
  expect_s3_class(scale_fill_tableau(), "ScaleDiscrete")
})

test_that("scale_fill_tableau works with diverging scales", {
  expect_s3_class(
    scale_fill_tableau(
      type = "ordered-diverging",
      palette = "Orange-Blue Diverging"
    ),
    "ScaleDiscrete"
  )
})

test_that("scale_fill_tableau works with sequential scales", {
  expect_s3_class(
    scale_fill_tableau(
      type = "ordered-sequential",
      palette = "Blue-Green Sequential"
    ),
    "ScaleDiscrete"
  )
})

test_that("tableau_gradient_pal works", {
  p <- tableau_gradient_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(seq(0, 1, by = 0.1)))
})

test_that("tableau_seq_gradient_pal works", {
  p <- tableau_seq_gradient_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(seq(0, 1, by = 0.1)))
})

test_that("tableau_div_gradient_pal works", {
  p <- tableau_seq_gradient_pal()
  expect_type(p, "closure")
  expect_hexcolor(p(seq(0, 1, by = 0.1)))
})

test_that("scale_colour_gradient_tableau works", {
  expect_s3_class(scale_colour_gradient_tableau(), "ScaleContinuous")
})

test_that("scale_fill_gradient_tableau works", {
  expect_s3_class(scale_fill_gradient_tableau(), "ScaleContinuous")
})

test_that("scale_colour_gradient_tableau works", {
  expect_s3_class(scale_colour_gradient2_tableau(), "ScaleContinuous")
})

test_that("scale_fill_gradient_tableau works", {
  expect_s3_class(scale_fill_gradient2_tableau(), "ScaleContinuous")
})

test_that("scale_fill_gradient2_tableau midpoint argument changes the color mapping", {
  sc0 <- scale_fill_gradient2_tableau(midpoint = 0)
  sc5 <- scale_fill_gradient2_tableau(midpoint = 5)
  values <- c(-2, 0, 5, 8)

  map <- function(sc) {
    sc$train(values)
    sc$map(values)
  }

  expect_gt(sum(map(sc0) != map(sc5)), 0L)
  # at midpoint, the value should map to the middle of the palette
  expect_equal(map(sc0)[2], map(sc5)[3])
})

test_that("classic colors are in the correct order", {
  # Issue #96
  pal <- tableau_color_pal("Classic 20")(20)
  expect_equal(pal[[1]], "#1f77b4")
  expect_equal(pal[[20]], "#9edae5")
})

test_that("Gray Warm sequential palette has no off-hue color", {
  # Regression: position 7 was "#b047a4", a magenta in a warm-gray ramp.
  values <- ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]][["Gray Warm"]][["value"]]
  expect_equal(values[[7]], "#b0a8a4")
  # In a gray ramp no colour may have channels differing by more than 20/255.
  rgb_values <- grDevices::col2rgb(values)
  expect_lt(max(apply(rgb_values, 2, function(x) max(x) - min(x))), 20)
})

test_that("Red-Gold sequential palette has 20 distinct colors", {
  # Regression: "#fa9d4f" appeared twice, giving 21 colours.
  values <- ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]][["Red-Gold"]][["value"]]
  expect_equal(length(values), 20L)
  expect_equal(anyDuplicated(values), 0L)
})

test_that("Blue-Red-Brown is the canonical palette name", {
  palettes <- ggthemes_data$tableau[["color-palettes"]][["regular"]]
  expect_contains(names(palettes), "Blue-Red-Brown")
  expect_no_match(names(palettes), "^Red-Blue-Brown$")
})

test_that("Classic Area Brown is the canonical palette name", {
  palettes <- ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]]
  expect_contains(names(palettes), "Classic Area Brown")
  expect_no_match(names(palettes), "^Classic Area-Brown$")
})

test_that("tableau_color_pal accepts a deprecated palette name with a warning", {
  expect_snapshot(pal <- tableau_color_pal("Red-Blue-Brown"))
  expect_equal(pal(4), tableau_color_pal("Blue-Red-Brown")(4))
})

test_that("tableau_gradient_pal accepts a deprecated palette name with a warning", {
  expect_snapshot(
    pal <- tableau_gradient_pal("Classic Area-Brown", type = "ordered-sequential")
  )
  expect_equal(
    pal(c(0, 1)),
    tableau_gradient_pal("Classic Area Brown", type = "ordered-sequential")(c(0, 1))
  )
})
