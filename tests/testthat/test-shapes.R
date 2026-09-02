# `circlefill_shape_pal()` is glyph-only, so it probes the device font. What
# this machine's font happens to cover must not reach the snapshot, or CI
# records one build machine's font coverage as the expected output.
#
# Forcing `lifecycle_verbosity` keeps this test's own deprecation warning in
# the record whatever ran before it.
test_that("circlefill_pal works", {
  skip_if_not_installed("withr")
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot({
    pal <- circlefill_shape_pal()
    expect_type(pal, "closure")
    expect_equal(attr(pal, "max_n"), 5L)
    n <- 4L
    values <- pal(n)
    expect_type(values, "integer")
    expect_equal(length(values), n)
  })
})

# Asserted rather than snapshotted. This call raises two deprecation warnings:
# its own, and an *indirect* one from the `circlefill_shape_pal()` it delegates
# to. lifecycle emits that second one only once per session and
# `lifecycle_verbosity` does not override it, so a snapshot of this code records
# one warning or two depending on what ran earlier in the session.
test_that("scale_shape_circlefill works", {
  skip_if_not_installed("withr")
  local_mocked_bindings(missing_glyphs = function(...) character(0))
  lifecycle::expect_deprecated(scale_shape_circlefill())
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(scale_shape_circlefill(), "ScaleDiscrete")
})

test_that("tremmel_shape_pal works", {
  pal <- tremmel_shape_pal()
  expect_type(pal, "closure")
  expect_equal(attr(pal, "max_n"), 3L)
  n <- 3L
  values <- pal(n)
  expect_type(values, "integer")
  expect_equal(length(values), n)
})

test_that("tremmel_shape_pal works for all values", {
  for (i in 1:3L) {
    expect_equal(length(tremmel_shape_pal()(i)), i)
    expect_equal(length(tremmel_shape_pal(alt = TRUE)(i)), i)
    expect_equal(length(tremmel_shape_pal(overlap = TRUE)(i)), i)
  }
})

test_that("scale_shape_tremmel works", {
  expect_s3_class(scale_shape_tremmel(), "ScaleDiscrete")
})

test_that("cleveland_shape_pal works", {
  pal <- cleveland_shape_pal()
  expect_type(pal, "closure")
  expect_equal(attr(pal, "max_n"), 4)
  n <- 3
  vals <- pal(n)
  expect_equal(length(vals), n)
})


test_that("cleveland_shape_pal works with overlap = FALSE", {
  pal <- cleveland_shape_pal(overlap = FALSE)
  expect_type(pal, "closure")
  # Three, not five: the two fill-graded circles have no base pch equivalent.
  # See test-shape-pal.R for both branches.
  expect_equal(attr(pal, "max_n"), 3)
  n <- 3
  vals <- pal(n)
  expect_equal(length(vals), n)
  expect_type(vals, "integer")
  expect_true(all(vals %in% c(0:25, 32:127)))
})

test_that("scale_shape_cleveland works", {
  expect_s3_class(scale_shape_cleveland(), "ScaleDiscrete")
})

test_that("warn_unicode_pch warns only for unicode pch on non-UTF-8 locales", {
  testthat::local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  expect_warning(warn_unicode_pch(c(-9675, -9679)), "Unicode")
  expect_no_warning(warn_unicode_pch(c(1, 2, 3)))
})

test_that("warn_unicode_pch is silent on UTF-8 locales", {
  testthat::local_mocked_bindings(l10n_info = function() list(`UTF-8` = TRUE), .package = "base")
  expect_no_warning(warn_unicode_pch(c(-9675, -9679)))
})
