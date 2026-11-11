test_that("circlefill_shape_pal and scale_shape_circlefill are defunct", {
  expect_snapshot(circlefill_shape_pal(), error = TRUE)
  expect_snapshot(scale_shape_circlefill(), error = TRUE)
})

test_that("tremmel_shape_pal works", {
  pal <- tremmel_shape_pal()
  expect_type(pal, "closure")
  expect_equal(attr(pal, "max_n"), 3L)
  n <- 3L
  values <- pal(n)
  expect_type(values, "integer")
  expect_length(values, n)
})

test_that("tremmel_shape_pal works for all values", {
  for (i in 1:3L) {
    expect_length(tremmel_shape_pal()(i), i)
    expect_length(tremmel_shape_pal(alt = TRUE)(i), i)
    expect_length(tremmel_shape_pal(overlap = TRUE)(i), i)
  }
})

test_that("scale_shape_tremmel works", {
  expect_s3_class(scale_shape_tremmel(), "ScaleDiscrete")
})

test_that("cleveland_shape_pal works", {
  pal <- cleveland_shape_pal(unicode = FALSE)
  expect_type(pal, "closure")
  expect_equal(attr(pal, "max_n"), 5)
  n <- 3
  vals <- pal(n)
  expect_length(vals, n)
})


test_that("cleveland_shape_pal works with overlap = FALSE", {
  pal <- cleveland_shape_pal(overlap = FALSE, unicode = FALSE)
  expect_type(pal, "closure")
  # Two, not five: only the solid and the open circle have a base pch. See
  # test-shape-pal.R for both branches.
  expect_equal(attr(pal, "max_n"), 2)
  n <- 2
  vals <- pal(n)
  expect_length(vals, n)
  expect_type(vals, "integer")
  expect_contains(c(0:25, 32:127), vals)
})

test_that("scale_shape_cleveland works", {
  local_missing_glyphs(function(...) character(0))
  expect_s3_class(scale_shape_cleveland(unicode = TRUE), "ScaleDiscrete")
  expect_s3_class(scale_shape_cleveland(unicode = FALSE), "ScaleDiscrete")
  expect_s3_class(scale_shape_cleveland(unicode = TRUE, edition = "1994"), "ScaleDiscrete")
})

test_that("warn_unicode_pch warns only for unicode pch on non-UTF-8 locales", {
  testthat::local_mocked_bindings(l10n_info = function() list(`UTF-8` = FALSE), .package = "base")
  expect_snapshot(x <- warn_unicode_pch(c(-9675, -9679)))
  expect_no_warning(warn_unicode_pch(c(1, 2, 3)))
})

test_that("warn_unicode_pch is silent on UTF-8 locales", {
  testthat::local_mocked_bindings(l10n_info = function() list(`UTF-8` = TRUE), .package = "base")
  expect_no_warning(warn_unicode_pch(c(-9675, -9679)))
})

test_that("scale_shape_tremmel() takes alt by name only", {
  expect_s3_class(scale_shape_tremmel(overlap = TRUE, alt = TRUE), "ScaleDiscrete")
  expect_snapshot(scale_shape_tremmel(TRUE, TRUE), error = TRUE)
})
