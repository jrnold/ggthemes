# Defined in helper-shapes.R too; repeated so lintr, which reads one file at a
# time, can see where the name comes from.
.data <- rlang::.data

# One open circle the font has, one base pch, and one pictograph it lacks.
mixed_shapes_plot <- function() {
  df <- data.frame(x = 1:3, y = 1, shape = c(-0x25CB, 16, -0x2614))
  ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, shape = .data$shape)) +
    geom_point_glyph(size = 5) +
    ggplot2::scale_shape_identity()
}

find_grobs <- function(grob, class) {
  if (inherits(grob, class)) {
    return(list(grob))
  }
  kids <- if (inherits(grob, "gTree")) grob[["children"]] else list()
  unlist(lapply(kids, find_grobs, class = class), recursive = FALSE)
}

test_that("only negative pch the font has are drawn from it", {
  skip_if_not_installed("systemfonts")
  expect_equal(
    shape_in_font(c(-0x25CB, -0x233D, -0x53, 1, 16, -0x2614, NA)),
    c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)
  )
  expect_equal(shape_in_font(c("circle", "triangle")), c(FALSE, FALSE))
})

test_that("geom_point_glyph() marks the shapes font as in use", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  shapes_font_state[["in_use"]] <- NULL
  geom_point_glyph()
  expect_true(shapes_font_in_use())
})

test_that("geom_point_glyph() errors when the font file is missing", {
  skip_if_not_installed("systemfonts")
  local_mocked_bindings(shapes_font_path = function() "")
  expect_snapshot(geom_point_glyph(), error = TRUE)
})

# The palette checks the font when the plot is built, so the order the layer
# and the scale are added in must not matter.
test_that("geom_point_glyph() silences the font warning even when added after the scale", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  local_utf8_locale()
  local_missing_glyphs(
    function(characters, family) if (family == "ggthemes shapes") character(0) else characters,
    in_use = NULL
  )
  df <- data.frame(x = 1:3, y = 1, g = factor(1:3))
  shapes_font_state[["in_use"]] <- NULL
  p <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, shape = .data$g)) +
    scale_shape_cleveland(overlap = FALSE, unicode = TRUE) +
    ggplot2::geom_point()
  expect_warning(ggplot2::ggplot_build(p), "lacks glyphs")

  shapes_font_state[["in_use"]] <- NULL
  p <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, shape = .data$g)) +
    scale_shape_cleveland(overlap = FALSE, unicode = TRUE) +
    geom_point_glyph()
  expect_no_warning(ggplot2::ggplot_build(p))
})

test_that("shapes the font lacks and base pch are left to geom_point()", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  grob <- ggplot2::layer_grob(mixed_shapes_plot())[[1]]
  glyphs <- find_grobs(grob, "ggthemes_glyph_points")
  expect_length(glyphs, 1)
  expect_equal(glyphs[[1]][["codepoint"]], 0x25CB)
  points <- find_grobs(grob, "points")
  expect_length(points, 1)
  expect_equal(points[[1]][["pch"]], c(16, -0x2614))
})

test_that("a device that draws glyphs gets them from the font file", {
  skip_if_not_installed("systemfonts")
  skip_if(is.null(glyph_api()), "R before 4.3 has no glyph API")
  local_shapes_font_state()
  grob <- find_grobs(ggplot2::layer_grob(mixed_shapes_plot())[[1]], "ggthemes_glyph_points")[[1]]
  withr::local_pdf(NULL)
  local_mocked_bindings(device_draws_glyphs = function(...) TRUE)
  child <- grid::makeContent(grob)[["children"]][[1]]
  expect_s3_class(child, "glyphgrob")
})

test_that("a device that can't draw glyphs gets points in the registered family", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  grob <- find_grobs(ggplot2::layer_grob(mixed_shapes_plot())[[1]], "ggthemes_glyph_points")[[1]]
  withr::local_pdf(NULL)
  local_mocked_bindings(device_draws_glyphs = function(...) FALSE)
  child <- grid::makeContent(grob)[["children"]][[1]]
  expect_s3_class(child, "points")
  expect_equal(child[["pch"]], -0x25CB)
  expect_equal(child[["gp"]][["fontfamily"]], "ggthemes shapes")
})

test_that("glyphs land where and as large as geom_point() draws the same font", {
  skip_if_not_installed("systemfonts")
  skip_if_not_installed("ragg")
  skip_if(is.null(glyph_api()), "R before 4.3 has no glyph API")
  local_shapes_font_state()
  # Centre and size of the ink, so the two drawings agree to the pixel
  # rather than up to anti-aliasing.
  ink <- function(geom, family = "") {
    p <- ggplot2::ggplot(data.frame(x = 0, y = 0), ggplot2::aes(.data$x, .data$y)) +
      geom +
      ggplot2::theme_void()
    capture <- ragg::agg_capture(width = 200, height = 200, res = 72)
    on.exit(grDevices::dev.off())
    print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
    img <- capture(native = FALSE)
    dark <- which(matrix(grDevices::col2rgb(img)[1, ] < 200, nrow(img)), arr.ind = TRUE)
    c(x = mean(dark[, 2]), y = mean(dark[, 1]), area = nrow(dark))
  }
  for (codepoint in c(0x25CB, 0x233D, 0x25B2, 0x2B06, 0x53)) {
    expected <- ink(ggplot2::geom_point(shape = -codepoint, size = 20), "ggthemes shapes")
    actual <- ink(geom_point_glyph(shape = -codepoint, size = 20))
    expect_equal(actual, expected, tolerance = 0.01, info = intToUtf8(codepoint))
  }
})

test_that("the legend key draws font shapes from the font and others as points", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  draw_key <- GeomPointGlyph$draw_key
  expect_s3_class(draw_key(data.frame(shape = -0x25CB), list(), NULL), "ggthemes_glyph_points")
  expect_s3_class(draw_key(data.frame(shape = 16), list(), NULL), "points")
})
