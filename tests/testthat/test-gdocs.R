test_that("gdocs_pal works", {
  pal <- gdocs_pal()
  expect_type(pal, "closure")
  n <- 3
  vals <- pal(n)
  expect_type(vals, "character")
  expect_equal(length(vals), n)
})

test_that("scale_fill_gdocs works", {
  expect_s3_class(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_colour_gdocs works", {
  expect_s3_class(scale_fill_gdocs(), "ScaleDiscrete")
})

test_that("scale_color_gdocs works", {
  expect_equal_scale(scale_color_gdocs(), scale_colour_gdocs())
})

test_that("theme_gdocs works", {
  expect_s3_class(theme_gdocs(), "theme")
})

test_that("gdocs_pal returns 24 distinct colours", {
  vals <- gdocs_pal()(24)
  expect_length(vals, 24)
  expect_equal(anyDuplicated(vals), 0)
})

test_that("gdocs_pal matches the Google Sheets series colours", {
  # Sampled from a 24-series Google Sheets column chart, read left to right
  # off the rendered chart canvas. Hue-major, tint-minor.
  expect_equal(
    unname(gdocs_pal()(24)),
    c(
      "#4285f4",
      "#ea4335",
      "#fbbc04",
      "#34a853",
      "#ff6d01",
      "#46bdc6",
      "#7baaf7",
      "#f07b72",
      "#fcd04f",
      "#71c287",
      "#ff994d",
      "#7ed1d7",
      "#b3cefb",
      "#f7b4ae",
      "#fde49b",
      "#aedcba",
      "#ffc599",
      "#b5e5e8",
      "#ecf3fe",
      "#fdeceb",
      "#fff8e6",
      "#ebf6ee",
      "#fff0e6",
      "#edf8f9"
    )
  )
})
