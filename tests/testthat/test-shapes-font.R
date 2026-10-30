# No fallback to the source tree: a font missing from the installed package
# must fail here rather than be found somewhere else.
font_path <- function() {
  system.file("fonts", "ggthemes-shapes.ttf", package = "ggthemes", mustWork = TRUE)
}

# Area of the convex hull of a glyph's outline: independent of whether the
# shape is hollow or filled, and of its rotation. This is the quantity the font
# is built to equalize (see data-raw/shapes-font/build.py).
glyph_hull_area <- function(codepoint, path) {
  info <- systemfonts::glyph_info(intToUtf8(codepoint), path = path, index = 0, size = 100, res = 72)
  if (info$index[[1]] == 0) {
    return(NA_real_)
  }
  outline <- systemfonts::glyph_outline(info$index[[1]], path = path, index = 0, size = 100, tolerance = 0.5)
  hull <- grDevices::chull(outline$x, outline$y)
  x <- outline$x[hull]
  y <- outline$y[hull]
  abs(sum(x * c(y[-1], y[1]) - c(x[-1], x[1]) * y)) / 2
}

# `new_shape_pal()` returns the glyph codepoints as negative pch values.
unicode_palette_codepoints <- function(pal_fn) {
  pal <- suppressWarnings(pal_fn(unicode = TRUE))
  -pal(attr(pal, "max_n"))
}

unicode_palette_functions <- function() {
  list(
    calc_shape_pal,
    function(unicode) cleveland_shape_pal(overlap = TRUE, unicode = unicode),
    function(unicode) cleveland_shape_pal(overlap = FALSE, unicode = unicode),
    function(unicode) cleveland_shape_pal(overlap = TRUE, unicode = unicode, edition = "1994"),
    function(unicode) cleveland_shape_pal(overlap = FALSE, unicode = unicode, edition = "1994"),
    stata_shape_pal,
    tableau_shape_pal
  )
}

size_spread <- function(codepoints, path) {
  area <- vapply(codepoints, glyph_hull_area, numeric(1), path = path)
  sqrt(max(area) / min(area))
}

test_that("shapes_font() registers the font and returns its family name", {
  skip_if_not_installed("systemfonts")
  # Registration outlives the test and silences `warn_shape_font()`.
  withr::defer(systemfonts::clear_registry())
  expect_false(shapes_font_registered())
  expect_equal(shapes_font(), "ggthemes shapes")
  expect_true(shapes_font_registered())
})

test_that("shapes_font() errors when the font file is missing", {
  local_mocked_bindings(shapes_font_path = function() "")
  expect_snapshot(shapes_font(), error = TRUE)
})

test_that("the font covers every shape of the unicode palettes", {
  skip_if_not_installed("systemfonts")
  path <- font_path()
  for (pal_fn in unicode_palette_functions()) {
    codepoints <- unicode_palette_codepoints(pal_fn)
    area <- vapply(codepoints, glyph_hull_area, numeric(1), path = path)
    expect_false(
      anyNA(area),
      info = paste("uncovered:", paste(sprintf("U+%04X", codepoints[is.na(area)]), collapse = " "))
    )
  }
})

test_that("the shapes of each unicode palette have comparable sizes", {
  skip_if_not_installed("systemfonts")
  path <- font_path()
  for (pal_fn in unicode_palette_functions()) {
    # Linear size spread (max/min). System fonts measured 1.6x to 2.4x here.
    expect_lt(size_spread(unicode_palette_codepoints(pal_fn), path), 1.1)
  }
})

test_that("the Tableau arrow, kpi and gender sign shapes are covered and comparable", {
  skip_if_not_installed("systemfonts")
  path <- font_path()
  shapes <- ggthemes_data$tableau[["shape-palettes"]]
  codepoint <- function(x) strtoi(sub("U+", "", sub(" .*", "", x), fixed = TRUE), 16L)
  for (nm in c("Arrows", "Thin Arrows")) {
    expect_lt(size_spread(codepoint(shapes[[nm]]$unicode), path), 1.1)
  }
  # The exclamation mark is too narrow to reach the common area, so "kpi" is looser.
  expect_lt(size_spread(codepoint(shapes[["kpi"]]$unicode), path), 1.25)
  gender <- shapes[["Gender"]]
  signs <- codepoint(gender$unicode)[!codepoint(gender$unicode) %in% 0x1F6B9:0x1F6BB]
  expect_lt(size_spread(signs, path), 1.1)
})

test_that("the shapes the font leaves to the device font are not in it", {
  skip_if_not_installed("systemfonts")
  path <- font_path()
  weather <- ggthemes_data$tableau[["shape-palettes"]][["weather"]]
  codepoints <- strtoi(sub("U+", "", sub(" .*", "", weather$unicode), fixed = TRUE), 16L)
  expect_true(all(is.na(vapply(codepoints, glyph_hull_area, numeric(1), path = path))))
})
