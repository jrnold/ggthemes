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

test_that("no two tableau shape palettes draw the same characters", {
  # Arrows and Thin Arrows once held the same eight characters.
  shapes <- ggthemes_data$tableau$`shape-palettes`
  glyphs <- vapply(shapes, function(x) paste(x$character, collapse = " "), character(1))
  expect_equal(names(glyphs)[duplicated(glyphs)], character(0))
})

test_that("tableau shape characters match their code points", {
  # `unicode` documents the whole sequence, including any variation selector
  # (U+FE0E text, U+FE0F emoji), so a selector recorded there but missing from
  # the character, or the reverse, changes how the shape draws.
  for (nm in names(ggthemes_data$tableau$`shape-palettes`)) {
    shapes <- ggthemes_data$tableau$`shape-palettes`[[nm]]
    sequences <- vapply(
      shapes$character,
      function(ch) paste(sprintf("U+%04X", utf8ToInt(ch)), collapse = " "),
      character(1),
      USE.NAMES = FALSE
    )
    expect_equal(sequences, shapes$unicode, info = nm)
  }
})

test_that("tableau arrow palettes are solid and thin versions of one set", {
  shapes <- ggthemes_data$tableau$`shape-palettes`
  expect_equal(shapes$Arrows$name, shapes$`Thin Arrows`$name)
  expect_equal(
    shapes$Arrows$unicode,
    c("U+2B06", "U+2B08", "U+27A1", "U+2B0A", "U+2B07", "U+2B0B", "U+2B05", "U+2B09")
  )
  expect_equal(
    shapes$`Thin Arrows`$unicode,
    c("U+2191", "U+2197", "U+2192", "U+2198", "U+2193", "U+2199", "U+2190", "U+2196")
  )
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

test_that("tableau_gradient_pal() rejects an unknown palette", {
  expect_snapshot(tableau_gradient_pal("Chartreuse"), error = TRUE)
  expect_snapshot(tableau_seq_gradient_pal("Chartreuse"), error = TRUE)
})

test_that("tableau gradient palette helpers reject extra arguments", {
  expect_snapshot(tableau_seq_gradient_pal("Blue", extra = 1), error = TRUE)
  expect_snapshot(tableau_div_gradient_pal(extra = 1), error = TRUE)
})

test_that("scale_colour_tableau() takes type and direction by name only", {
  expect_s3_class(scale_colour_tableau("Tableau 20", type = "regular", direction = -1), "ScaleDiscrete")
  expect_snapshot(scale_colour_tableau("Tableau 20", "regular"), error = TRUE)
  expect_snapshot(scale_fill_tableau("Tableau 20", "regular"), error = TRUE)
})
