# Palettes built on `new_shape_pal()`. Each has two branches: the default
# returns font-independent base pch, and `unicode = TRUE` returns the negative
# glyph pch that the palette returned before 6.1.0.

safe_palettes <- function() {
  list(
    "stata" = list(pal = stata_shape_pal, max_n = 10L),
    "calc" = list(pal = calc_shape_pal, max_n = 7L),
    "cleveland overlap" = list(pal = function(...) cleveland_shape_pal(TRUE, ...), max_n = 4L),
    "cleveland default" = list(pal = function(...) cleveland_shape_pal(FALSE, ...), max_n = 3L),
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
    expect_false(any(is.na(values)), label = paste0(nm, " has no NA below max_n"))
    expect_true(all(values %in% c(0:25, 32:127)), label = paste0(nm, " safe pch"))
  }
})

test_that("the unicode branch returns the negative glyph pch", {
  unicode_max_n <- c(
    "stata" = 10L,
    "calc" = 13L,
    "cleveland overlap" = 4L,
    "cleveland default" = 5L,
    "tableau default" = 10L,
    "tableau filled" = 10L,
    "tableau proportions" = 5L
  )
  # The font warning is `warn_shape_font()`'s business, tested in
  # test-shape-font.R; whether this machine's default font happens to cover a
  # palette's glyphs must not decide whether these assertions run.
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  for (nm in names(safe_palettes())) {
    pal <- safe_palettes()[[nm]]$pal(unicode = TRUE)
    expect_equal(attr(pal, "max_n"), unicode_max_n[[nm]], label = paste0(nm, " unicode max_n"))
    expect_true(all(pal(unicode_max_n[[nm]]) < 0), label = paste0(nm, " unicode pch are negative"))
  }
})

test_that("asking for more values than a palette has warns and pads with NA", {
  pal <- tableau_shape_pal("proportions")
  expect_warning(values <- pal(4), "maximum of 2 values")
  expect_equal(length(values), 4L)
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

test_that("cleveland's non-overlapping palette keeps the three separable circles", {
  # Empty circle, solid circle, circled plus. The two dropped shapes are the
  # fill-graded circles that Tremmel (1995) Experiment 2 measured as the worst
  # performers in exactly this five-symbol set.
  expect_equal(cleveland_shape_pal(overlap = FALSE)(3), c(1L, 16L, 10L))
})

test_that("cleveland's overlapping palette draws an S, not a W", {
  expect_equal(cleveland_shape_pal(overlap = TRUE)(4), c(1L, 3L, 60L, 83L))
})

test_that("few's palette is unchanged by the safe mapping", {
  # Already base pch before 6.1.0, so it has nothing to drop and gains no
  # `unicode` argument.
  expect_equal(few_shape_pal()(5), c(1L, 0L, 2L, 3L, 4L))
  expect_error(few_shape_pal(unicode = TRUE), "unused argument")
})

test_that("deprecated circlefill still returns its glyph pch", {
  skip_if_not_installed("withr")
  withr::local_options(lifecycle_verbosity = "quiet")
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  values <- circlefill_shape_pal()(5)
  expect_equal(attr(circlefill_shape_pal(), "max_n"), 5L)
  expect_true(all(values < 0))
})

test_that("scale functions pass unicode through to their palette", {
  local_mocked_bindings(missing_glyphs = function(...) character(0))
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
