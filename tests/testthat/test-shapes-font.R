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
  pal <- pal_fn(unicode = TRUE)
  -suppressWarnings(pal(attr(pal, "max_n")))
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

test_that("the font is registered when ggthemes loads", {
  skip_if_not_installed("systemfonts")
  expect_true(shapes_font_registered())
  # Registered, but not in use: availability says nothing about the font a plot
  # is drawn with, so it must not silence the missing-glyph warning.
  local_shapes_font_state()
  shapes_font_state[["in_use"]] <- NULL
  expect_false(shapes_font_in_use())
})

test_that("load-time registration never fails", {
  local_mocked_bindings(shapes_font_path = function() "")
  expect_false(try_register_shapes_font())
})

test_that("register_shapes_font() registers the font, marks it in use and returns its family name", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  systemfonts::clear_registry()
  shapes_font_state[["in_use"]] <- NULL
  expect_equal(register_shapes_font(), "ggthemes shapes")
  expect_true(shapes_font_registered())
  expect_true(shapes_font_in_use())
})

# systemfonts refuses to register a family name an installed font has, and the
# docs tell `pdf()` users to install the font.
test_that("register_shapes_font() leaves a copy of the font installed on the system alone", {
  skip_if_not_installed("systemfonts")
  local_shapes_font_state()
  shapes_font_state[["in_use"]] <- NULL
  local_mocked_bindings(shapes_font_installed = function() TRUE)
  local_mocked_bindings(
    register_font = function(...) stop("A system font called `ggthemes shapes` already exists", call. = FALSE),
    .package = "systemfonts"
  )
  expect_equal(register_shapes_font(), "ggthemes shapes")
  expect_true(shapes_font_in_use())
  expect_true(try_register_shapes_font())
})

test_that("register_shapes_font() errors when the font file is missing", {
  local_mocked_bindings(shapes_font_path = function() "")
  expect_snapshot(register_shapes_font(), error = TRUE)
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
  for (nm in c("arrows", "thin-arrows")) {
    expect_lt(size_spread(codepoint(shapes[[nm]]$unicode), path), 1.1)
  }
  # The exclamation mark is too narrow to reach the common area, so "kpi" is looser.
  expect_lt(size_spread(codepoint(shapes[["kpi"]]$unicode), path), 1.25)
  gender <- shapes[["gender"]]
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

test_that("embed_shapes_font() errors for a file that does not exist", {
  expect_snapshot(embed_shapes_font("no-such-file.pdf"), error = TRUE)
})

test_that("embed_shapes_font() errors for paths that are not single strings", {
  path <- withr::local_tempfile(fileext = ".pdf")
  writeLines("", path)
  expect_snapshot(embed_shapes_font(c("a.pdf", "b.pdf")), error = TRUE)
  expect_snapshot(embed_shapes_font(path, outfile = NULL), error = TRUE)
})

test_that("embed_shapes_font() embeds the font a pdf() file only refers to", {
  skip_if_not_installed("systemfonts")
  skip_if(is.null(glyph_api()), "R before 4.3 has no glyph API")
  skip_if_not(nzchar(tools::find_gs_cmd()), "Ghostscript is not installed")
  # Ghostscript writes the embedded font into a compressed object stream, so
  # the file has to be read by a PDF parser rather than searched for bytes.
  pdffonts <- Sys.which("pdffonts")
  skip_if_not(nzchar(pdffonts), "pdffonts (poppler) is not installed")
  local_shapes_font_state()
  # The `emb` column of the shapes font's row in pdffonts' table.
  embeds_truetype <- function(path) {
    rows <- grep("ggthemes-shapes", system2(pdffonts, path, stdout = TRUE), value = TRUE, fixed = TRUE)
    length(rows) == 1 && grepl("Identity-H\\s+yes", rows)
  }
  path <- withr::local_tempfile(fileext = ".pdf")
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1, g = factor(1:3)), ggplot2::aes(.data$x, .data$y, shape = .data$g)) +
    geom_point_glyph(size = 5) +
    scale_shape_cleveland(unicode = TRUE)
  grDevices::pdf(path)
  print(p)
  grDevices::dev.off()
  expect_false(embeds_truetype(path))
  outfile <- withr::local_tempfile(fileext = ".pdf")
  expect_invisible(embed_shapes_font(path, outfile))
  expect_equal(embed_shapes_font(path, outfile), outfile)
  expect_false(embeds_truetype(path))
  expect_true(embeds_truetype(outfile))
  expect_equal(embed_shapes_font(path), path)
  expect_true(embeds_truetype(path))
})
