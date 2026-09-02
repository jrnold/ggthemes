# vdiffr is listed in Suggests (#124), so visual tests are skipped when it is
# not installed. That silence is dangerous on CI, where a missing vdiffr would
# drop visual coverage to zero without failing anything. Setting
# VDIFFR_RUN_TESTS="true" turns a missing vdiffr into an error instead; the
# R-CMD-check workflow sets it on the stable version of R only.
#
# Visual tests still skip on CRAN, via the `cran = FALSE` default of the
# `testthat::expect_snapshot_file()` that vdiffr delegates to.

if (requireNamespace("vdiffr", quietly = TRUE)) {
  expect_doppelganger <- vdiffr::expect_doppelganger
} else {
  # If vdiffr is not available and visual tests are explicitly required, raise
  # an error rather than quietly losing the coverage.
  if (identical(Sys.getenv("VDIFFR_RUN_TESTS"), "true")) {
    rlang::abort("vdiffr is not installed")
  }

  expect_doppelganger <- function(...) testthat::skip("vdiffr is not installed.")
}
