test_that("ptol_pal works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  p <- ptol_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  expect_hexcolor(p(11))
})

test_that("scale_colour_ptol works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(scale_colour_ptol(), "ScaleDiscrete")
})

test_that("scale_fill_ptol works", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(scale_fill_ptol(), "ScaleDiscrete")
})

test_that("ptol_pal is deprecated in favour of khroma", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot(p <- ptol_pal())
})

test_that("scale_colour_ptol is deprecated in favour of khroma", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot(s <- scale_colour_ptol())
})

test_that("scale_color_ptol is deprecated in favour of khroma", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot(s <- scale_color_ptol())
})

test_that("scale_fill_ptol is deprecated in favour of khroma", {
  withr::local_options(lifecycle_verbosity = "warning")
  expect_snapshot(s <- scale_fill_ptol())
})

test_that("the ptol scales warn for themselves and not also for ptol_pal()", {
  # The scales call `ptol_pal()` internally, which is deprecated in its own
  # right. Without suppression a single `scale_fill_ptol()` call would warn
  # twice and send the user chasing a function they never called.
  withr::local_options(lifecycle_verbosity = "warning")
  warnings <- character()
  withCallingHandlers(
    scale_fill_ptol(),
    lifecycle_warning_deprecated = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  expect_length(warnings, 1L)
  expect_match(warnings, "scale_fill_ptol")
})
