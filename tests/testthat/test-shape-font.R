# `warn_shape_font()` replaces a locale heuristic with a real measurement of
# what the device font can draw. The locale guess stays silent on a UTF-8
# session even when the font would render seven of eight glyphs as blank boxes,
# which is the failure it was meant to catch.

clear_font_cache <- function() {
  rm(list = ls(shape_font_cache), envir = shape_font_cache)
}

# `warn_shape_font()` checks the locale *and* glyph coverage. Tests about
# coverage pin the locale to UTF-8 so the other check cannot fire and make the
# result depend on the machine the suite runs on.
local_utf8_locale <- function(env = parent.frame()) {
  testthat::local_mocked_bindings(
    l10n_info = function() list(`UTF-8` = TRUE),
    .package = "base",
    .env = env
  )
}

glyph_table <- function(characters) {
  tibble::tibble(
    character = characters,
    pch_unicode = -vapply(characters, function(x) utf8ToInt(x)[[1]], integer(1))
  )
}

test_that("a font covering every glyph produces no warning", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  expect_no_warning(warn_shape_font(glyph_table(c("○", "●"))))
})

test_that("uncovered glyphs are named in the warning", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(missing_glyphs = function(...) c("⧓", "✦"))
  expect_warning(
    warn_shape_font(glyph_table(c("●", "⧓", "✦"))),
    "lacks glyphs for 2 of 3 shapes"
  )
})

test_that("the warning points at both ways out", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(missing_glyphs = function(...) "⧓")
  w <- capture_warnings(warn_shape_font(glyph_table("⧓")))
  expect_match(paste(w, collapse = " "), "DejaVu Sans")
  expect_match(paste(w, collapse = " "), "unicode = FALSE")
})

# `ragg::agg_png()` has no `family` argument, so the advice this replaced
# errored when followed. The font has to be set on the device, and only on a
# device that takes a `family`.
test_that("the suggested device call names a real argument", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(missing_glyphs = function(...) "⧓")
  w <- paste(capture_warnings(warn_shape_font(glyph_table("⧓"))), collapse = " ")
  expect_no_match(w, "agg_png")
  expect_match(w, "png\\(family = ")
  # `png()` takes `family` through `...`; `cairo_pdf()` declares it outright.
  # `ragg::agg_png()`, which the replaced advice named, accepts it in neither
  # form -- following that advice raised "unused argument (family = ...)".
  # `ragg` is not a declared dependency, so that is asserted by absence above
  # rather than by probing its formals here.
  expect_true("family" %in% names(formals(grDevices::cairo_pdf)))
})

# Fix: interpolating the empty family printed a bare `("")` at the reader.
test_that("an unknown device family is described, not printed as empty", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(current_font_family = function() "")
  local_mocked_bindings(missing_glyphs = function(...) "⧓")
  w <- paste(capture_warnings(warn_shape_font(glyph_table("⧓"))), collapse = " ")
  expect_match(w, "The default device font lacks glyphs")
  expect_no_match(w, '\\(""\\)')
})

test_that("a known device family is named in the warning", {
  clear_font_cache()
  local_utf8_locale()
  local_mocked_bindings(current_font_family = function() "Times")
  local_mocked_bindings(missing_glyphs = function(...) "⧓")
  expect_warning(warn_shape_font(glyph_table("⧓")), "Times")
})

test_that("the font is probed once per family and character set", {
  clear_font_cache()
  local_utf8_locale()
  probes <- 0L
  local_mocked_bindings(missing_glyphs = function(...) {
    probes <<- probes + 1L
    character(0)
  })
  shapes <- glyph_table(c("○", "●"))
  warn_shape_font(shapes)
  warn_shape_font(shapes)
  expect_equal(probes, 1L)
})

# Regression: these were `if`/`else` alternatives, so installing `systemfonts`
# -- which `ragg` depends on, making it the common case -- silently dropped the
# locale check. A covered font on a non-UTF-8 session still fails at draw time.
test_that("the locale is checked even when systemfonts measures full coverage", {
  clear_font_cache()
  skip_if_not_installed("systemfonts")
  local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  expect_warning(warn_shape_font(glyph_table("○")), "locale is not UTF-8")
})

test_that("without systemfonts the locale heuristic is used instead", {
  clear_font_cache()
  local_mocked_bindings(is_installed = function(...) FALSE, .package = "rlang")
  local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  local_mocked_bindings(missing_glyphs = function(...) {
    stop("systemfonts must not be probed when it is not installed")
  })
  expect_warning(warn_shape_font(glyph_table("○")), "locale is not UTF-8")
})

test_that("glyph coverage of ASCII is reported for the default font", {
  skip_if_not_installed("systemfonts")
  # Every real font covers ASCII, so this holds whatever font the machine
  # running the tests resolves `""` to.
  expect_equal(missing_glyphs(c("A", "+", "<"), ""), character(0))
})

test_that("the safe branch never probes the font", {
  clear_font_cache()
  local_mocked_bindings(missing_glyphs = function(...) {
    stop("the safe branch does not depend on the font")
  })
  expect_no_warning(calc_shape_pal()(7))
  expect_no_warning(tableau_shape_pal("filled")(6))
})
