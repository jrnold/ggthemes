# Palettes built on `new_shape_pal()`. Each has two branches: the default
# returns font-independent base pch, and `unicode = TRUE` returns the negative
# glyph pch that the palette returned before 6.1.0.

safe_palettes <- function() {
  list(
    "stata" = list(pal = stata_shape_pal, max_n = 10L),
    "calc" = list(pal = calc_shape_pal, max_n = 7L),
    # Leaving `unicode` unset is deprecated for the Cleveland palettes, so these
    # wrappers pass the base-pch default the helpers below expect.
    "cleveland overlap" = list(pal = function(unicode = FALSE) cleveland_shape_pal(TRUE, unicode), max_n = 5L),
    "cleveland default" = list(pal = function(unicode = FALSE) cleveland_shape_pal(FALSE, unicode), max_n = 2L),
    "cleveland 1994 overlap" = list(
      pal = function(unicode = FALSE) cleveland_shape_pal(TRUE, unicode, "1994"),
      max_n = 5L
    ),
    "cleveland 1994 default" = list(
      pal = function(unicode = FALSE) cleveland_shape_pal(FALSE, unicode, "1994"),
      max_n = 2L
    ),
    "tableau default" = list(pal = function(...) tableau_shape_pal("default", ...), max_n = 8L),
    "tableau filled" = list(pal = function(...) tableau_shape_pal("filled", ...), max_n = 6L),
    "tableau proportions" = list(pal = function(...) tableau_shape_pal("proportions", ...), max_n = 2L)
  )
}

test_that("the safe branch drops shapes with no font-independent equivalent", {
  # The counts come from the mapping in R/shape-names.R: a shape whose
  # canonical name has no base pch lowers `max_n` rather than being
  # approximated by a different shape.
  for (nm in names(safe_palettes())) {
    p <- safe_palettes()[[nm]]
    expect_equal(attr(p$pal(), "max_n"), p$max_n, label = paste0(nm, " safe max_n"))
  }
})

test_that("the safe branch returns only font-independent pch", {
  for (nm in names(safe_palettes())) {
    p <- safe_palettes()[[nm]]
    values <- p$pal()(p$max_n)
    expect_false(anyNA(values), label = paste0(nm, " has no NA below max_n"))
    expect_true(all(values %in% c(0:25, 32:127)), label = paste0(nm, " safe pch"))
  }
})

test_that("the unicode branch returns the negative glyph pch", {
  unicode_max_n <- c(
    "stata" = 10L,
    "calc" = 13L,
    "cleveland overlap" = 5L,
    "cleveland default" = 5L,
    "cleveland 1994 overlap" = 5L,
    "cleveland 1994 default" = 5L,
    "tableau default" = 10L,
    "tableau filled" = 10L,
    "tableau proportions" = 5L
  )
  # The font warning is `warn_shape_font()`'s business, tested in
  # test-shape-font.R; whether this machine's default font happens to cover a
  # palette's glyphs must not decide whether these assertions run.
  local_missing_glyphs(function(...) character(0))
  for (nm in names(safe_palettes())) {
    pal <- safe_palettes()[[nm]]$pal(unicode = TRUE)
    expect_equal(attr(pal, "max_n"), unicode_max_n[[nm]], label = paste0(nm, " unicode max_n"))
    expect_true(all(pal(unicode_max_n[[nm]]) < 0), label = paste0(nm, " unicode pch are negative"))
  }
})

test_that("asking for more values than a palette has warns and pads with NA", {
  pal <- tableau_shape_pal("proportions")
  expect_warning(values <- pal(4), "maximum of 2 values")
  expect_length(values, 4L)
  expect_equal(sum(is.na(values)), 2L)
})

test_that("a negative n is an error", {
  expect_error(calc_shape_pal()(-1), "non-negative")
})

test_that("stata's safe palette reproduces its symbol set exactly", {
  # Stata's ten plotting symbols all have a base pch, so nothing is dropped:
  # solid then hollow circle, diamond, square, triangle, plus the X and plus.
  expect_equal(
    stata_shape_pal()(10),
    c(16L, 18L, 15L, 17L, 4L, 3L, 1L, 5L, 0L, 2L)
  )
})

# Figure 3.70 of Cleveland (1985), p. 196. The top row is for little overlap
# (`overlap = FALSE`) and the bottom row for overlap that causes problems
# (`overlap = TRUE`); each is used from the left.
test_that("cleveland's little-overlap set keeps the solid and open circle without a font", {
  expect_equal(cleveland_shape_pal(overlap = FALSE, unicode = FALSE)(2), c(16L, 1L))
  expect_equal(attr(cleveland_shape_pal(overlap = FALSE, unicode = FALSE), "max_n"), 2L)
})

test_that("cleveland's little-overlap set is Figure 3.70's top row with unicode = TRUE", {
  local_missing_glyphs(function(...) character(0))
  # Solid circle, open circle, circle with a vertical line, heavy ring, circled dot.
  expect_equal(
    cleveland_shape_pal(overlap = FALSE, unicode = TRUE)(5),
    -c(0x25CF, 0x25CB, 0x233D, 0x2B58, 0x2299)
  )
})

test_that("cleveland's overlap set is Figure 3.70's bottom row", {
  # Open circle, plus, S, triangle, U: all have a base pch, the letters as ASCII.
  expect_equal(cleveland_shape_pal(overlap = TRUE, unicode = FALSE)(5), c(1L, 3L, 83L, 2L, 85L))
  local_missing_glyphs(function(...) character(0))
  expect_equal(
    cleveland_shape_pal(overlap = TRUE, unicode = TRUE)(5),
    -c(0x25CB, 0x2B, 0x53, 0x25B3, 0x55)
  )
})

# The revised (second) edition of *The Elements of Graphing Data* draws the
# same two rows differently from the first edition's Figure 3.70.
test_that("cleveland's 1994 overlap set is an open circle, plus, <, S and W", {
  expect_equal(cleveland_shape_pal(overlap = TRUE, unicode = FALSE, edition = "1994")(5), c(1L, 3L, 60L, 83L, 87L))
  local_missing_glyphs(function(...) character(0))
  expect_equal(
    cleveland_shape_pal(overlap = TRUE, unicode = TRUE, edition = "1994")(5),
    -c(0x25CB, 0x2B, 0x3C, 0x53, 0x57)
  )
})

test_that("cleveland's 1994 little-overlap set is ordered open circle first", {
  expect_equal(cleveland_shape_pal(overlap = FALSE, unicode = FALSE, edition = "1994")(2), c(1L, 16L))
  local_missing_glyphs(function(...) character(0))
  # Open circle, solid circle, heavy ring, circle with a vertical line, circled dot.
  expect_equal(
    cleveland_shape_pal(overlap = FALSE, unicode = TRUE, edition = "1994")(5),
    -c(0x25CB, 0x25CF, 0x2B58, 0x233D, 0x2299)
  )
})

test_that("cleveland's palettes still default to base pch, and say the default will change", {
  skip_if_not_installed("withr")
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot({
    values <- cleveland_shape_pal()(5)
    scale <- scale_shape_cleveland(overlap = FALSE)
  })
  expect_equal(values, c(1L, 3L, 83L, 2L, 85L))
  expect_equal(scale$palette(2), c(16L, 1L))
})

test_that("cleveland's palettes don't warn about the default when `unicode` is set", {
  local_missing_glyphs(function(...) character(0))
  withr::local_options(lifecycle_verbosity = "warning")
  expect_no_warning(cleveland_shape_pal(unicode = FALSE))
  expect_no_warning(cleveland_shape_pal(unicode = TRUE)(5))
  expect_no_warning(scale_shape_cleveland(unicode = FALSE))
  # The scale resolves the default once; the palette it calls doesn't warn too.
  expect_length(capture_warnings(scale_shape_cleveland()), 1)
})

test_that("cleveland's edition is 1985 unless asked otherwise", {
  local_missing_glyphs(function(...) character(0))
  expect_equal(cleveland_shape_pal(unicode = TRUE), cleveland_shape_pal(unicode = TRUE, edition = "1985"))
  expect_equal(cleveland_shape_pal(unicode = FALSE)(5), c(1L, 3L, 83L, 2L, 85L))
  expect_snapshot(cleveland_shape_pal(unicode = FALSE, edition = "1994 revised"), error = TRUE)
  expect_snapshot(scale_shape_cleveland(unicode = FALSE, edition = "second"), error = TRUE)
  expect_equal(
    scale_shape_cleveland(unicode = TRUE, edition = "1994")$palette(5),
    cleveland_shape_pal(unicode = TRUE, edition = "1994")(5)
  )
})

test_that("`unicode` must be TRUE or FALSE", {
  expect_snapshot(calc_shape_pal(unicode = NA), error = TRUE)
  expect_snapshot(tableau_shape_pal("arrows", unicode = c(TRUE, FALSE)), error = TRUE)
  expect_snapshot(cleveland_shape_pal(unicode = "yes"), error = TRUE)
})

test_that("few's palette is unchanged by the safe mapping", {
  # Already base pch before 6.1.0, so it has nothing to drop and gains no
  # `unicode` argument.
  expect_equal(few_shape_pal()(5), c(1L, 0L, 2L, 3L, 4L))
  expect_error(few_shape_pal(unicode = TRUE), "unused argument")
})

test_that("scale functions pass unicode through to their palette", {
  local_missing_glyphs(function(...) character(0))
  expect_s3_class(scale_shape_calc(unicode = TRUE), "ScaleDiscrete")
  expect_s3_class(scale_shape_stata(unicode = TRUE), "ScaleDiscrete")
  expect_s3_class(scale_shape_tableau("filled", unicode = TRUE), "ScaleDiscrete")
  expect_s3_class(scale_shape_cleveland(overlap = FALSE, unicode = TRUE), "ScaleDiscrete")
})

test_that("shape palettes draw correctly", {
  expect_doppelganger(
    "shape-palettes-safe",
    shape_swatch_plot(safe_shape_values(), "Shape palettes (unicode = FALSE)")
  )
})

test_that("scale_shape_tremmel defaults to the same variant as its palette", {
  # The scale defaulted to `alt = TRUE` while the palette defaulted to
  # `alt = FALSE`, so the two disagreed at n = 3.
  expect_equal(formals(scale_shape_tremmel)$alt, formals(tremmel_shape_pal)$alt)
})

# `warn_shape_font()` replaces a locale heuristic with a real measurement of
# what the device font can draw. The locale guess stays silent on a UTF-8
# session even when the font would render seven of eight glyphs as blank boxes,
# which is the failure it was meant to catch.

glyph_table <- function(characters) {
  tibble::tibble(
    character = characters,
    pch_unicode = -vapply(characters, function(x) utf8ToInt(x)[[1]], integer(1))
  )
}

test_that("a font covering every glyph produces no warning", {
  local_utf8_locale()
  local_missing_glyphs(function(...) character(0))
  expect_no_warning(warn_shape_font(glyph_table(c("○", "●"))))
})

test_that("uncovered glyphs are named in the warning", {
  local_utf8_locale()
  local_missing_glyphs(function(...) c("⧓", "✦"))
  expect_warning(
    warn_shape_font(glyph_table(c("●", "⧓", "✦"))),
    "lacks glyphs for 2 of 3 shapes"
  )
})

test_that("the warning points at both ways out", {
  local_utf8_locale()
  local_missing_glyphs(function(...) "⧓")
  w <- capture_warnings(warn_shape_font(glyph_table("⧓")))
  expect_match(paste(w, collapse = " "), "DejaVu Sans")
  expect_match(paste(w, collapse = " "), "unicode = FALSE")
  expect_match(paste(w, collapse = " "), "shapes_font")
})

# `ragg::agg_png()` has no `family` argument, so the advice this replaced
# errored when followed. The font has to be set on the device, and only on a
# device that takes a `family`.
test_that("the suggested device call names a real argument", {
  local_utf8_locale()
  local_missing_glyphs(function(...) "⧓")
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
  local_utf8_locale()
  local_mocked_bindings(current_font_family = function() "")
  local_missing_glyphs(function(...) "⧓")
  w <- paste(capture_warnings(warn_shape_font(glyph_table("⧓"))), collapse = " ")
  expect_match(w, "The default device font lacks glyphs")
  expect_no_match(w, '\\(""\\)')
})

test_that("a known device family is named in the warning", {
  local_utf8_locale()
  local_mocked_bindings(current_font_family = function() "Times")
  local_missing_glyphs(function(...) "⧓")
  expect_warning(warn_shape_font(glyph_table("⧓")), "Times")
})

test_that("the font is probed once per family and character set", {
  local_utf8_locale()
  probes <- 0L
  local_missing_glyphs(function(...) {
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
  skip_if_not_installed("systemfonts")
  local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  local_missing_glyphs(function(...) character(0))
  expect_warning(warn_shape_font(glyph_table("○")), "locale is not UTF-8")
})

test_that("without systemfonts the locale heuristic is used instead", {
  local_mocked_bindings(is_installed = function(...) FALSE, .package = "rlang")
  local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  local_missing_glyphs(function(...) {
    stop("systemfonts must not be probed when it is not installed", call. = FALSE)
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
  local_missing_glyphs(function(...) {
    stop("the safe branch does not depend on the font", call. = FALSE)
  })
  expect_no_warning(calc_shape_pal()(7))
  expect_no_warning(tableau_shape_pal("filled")(6))
})

test_that("a unicode palette checks the device font when first called, not when made", {
  local_utf8_locale()
  local_missing_glyphs("\u25B3")
  expect_no_warning(pal <- cleveland_shape_pal(unicode = TRUE))
  expect_warning(pal(5), "lacks glyphs")
  expect_no_warning(pal(5))
  expect_no_warning(cleveland_shape_pal(unicode = FALSE)(5))
})

test_that("once the shapes font is in use, palettes it covers do not warn", {
  local_utf8_locale()
  # The default font lacks every shape; the shapes font lacks none.
  local_missing_glyphs(
    function(characters, family) if (family == "ggthemes shapes") character(0) else characters,
    in_use = TRUE
  )
  expect_no_warning(cleveland_shape_pal(unicode = TRUE)(5))
  expect_no_warning(tableau_shape_pal(unicode = TRUE)(10))
})

test_that("shapes the font lacks are still checked in the device font", {
  local_utf8_locale()
  local_missing_glyphs(function(characters, family) "\u2614", in_use = TRUE)
  expect_warning(warn_shape_font(glyph_table("\u2614")), "default device font")
})
