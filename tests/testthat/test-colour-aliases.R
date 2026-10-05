test_that("every exported *color* object has a *colour* version", {
  exports <- getNamespaceExports("ggthemes")
  color <- grep("color", exports, value = TRUE)
  colour <- gsub("color", "colour", color)
  expect_equal(sort(setdiff(colour, exports)), character())
})

test_that("British colour is matched with colourblind, American color with colorblind", {
  exports <- getNamespaceExports("ggthemes")
  mixed <- grep("colour.*colorblind|color.*colourblind", exports, value = TRUE)
  # Mixed spellings may exist only as deprecated names.
  expect_equal(mixed, "scale_colour_colorblind")
  skip_if_not_installed("withr")
  withr::local_options(lifecycle_verbosity = "warning")
  lifecycle::expect_deprecated(scale_colour_colorblind())
})
