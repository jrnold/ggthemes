library("ggplot2")

test_that("numbers_pal works", {
  pal <- numbers_pal()
  expect_type(pal, "closure")
  n <- 3L
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("numbers_pal defaults to the Classic palette", {
  expect_equal(
    numbers_pal()(6L),
    c("#496063", "#6C6F39", "#F0B24F", "#BC5B07", "#892319", "#4D2501")
  )
})

test_that("numbers_pal returns the named palette", {
  expect_equal(
    numbers_pal("Spectrum")(3L),
    c("#2E578C", "#5D9648", "#E7A13D")
  )
})

test_that("numbers_pal converts device-CMYK colors via ColorSync", {
  # The "Blue" palette's first series is stored as device-CMYK. A naive
  # 1 - x conversion would give #5EA3FF.
  expect_equal(numbers_pal("Blue")(1L), "#5E86B8")
})

test_that("numbers_pal raises an error for an unknown palette", {
  expect_snapshot(numbers_pal("Chartreuse"), error = TRUE)
})

test_that("numbers_pal raises a warning for large n", {
  expect_snapshot(x <- numbers_pal()(7L))
})

test_that("numbers_pal has a max_n attribute", {
  expect_equal(attr(numbers_pal(), "max_n"), 6L)
})

test_that("scale_fill_numbers works", {
  expect_s3_class(scale_fill_numbers(), "ScaleDiscrete")
})

test_that("scale_colour_numbers works", {
  expect_s3_class(scale_colour_numbers(), "ScaleDiscrete")
})

test_that("scale_color_numbers works", {
  expect_equal_scale(scale_color_numbers(), scale_colour_numbers())
})

test_that("scale_colour_numbers accepts a palette name", {
  expect_s3_class(scale_colour_numbers(palette = "Jade"), "ScaleDiscrete")
})

test_that("theme_numbers works", {
  expect_s3_class(theme_numbers(), "theme")
})

test_that("theme_numbers respects base_family and base_size", {
  thm <- theme_numbers(base_family = "mono", base_size = 20)
  expect_equal(thm$text$family, "mono")
  expect_equal(thm$text$size, 20)
})

test_that("theme_numbers draws only horizontal gridlines", {
  # Numbers shows value-direction gridlines and hides category-direction ones.
  thm <- theme_numbers()
  expect_s3_class(thm$panel.grid.major.y, "element_line")
  expect_s3_class(thm$panel.grid.major.x, "element_blank")
  expect_s3_class(thm$panel.grid.minor, "element_blank")
})

test_that("theme_numbers draws only the bottom axis line", {
  # Resolve inheritance rather than reading the raw slots, so this tests what
  # actually gets drawn.
  thm <- theme_numbers()
  expect_s3_class(calc_element("axis.line.x", thm), "element_line")
  expect_s3_class(calc_element("axis.line.y", thm), "element_blank")
  expect_s3_class(calc_element("axis.ticks", thm), "element_blank")
})

test_that("theme_numbers draws correctly", {
  expect_doppelganger("theme_numbers", theme_test_plot() + theme_numbers())
})
