is_hexcolor <- function(x) {
  pattern <- stringr::regex("^#[a-f0-9]{6}$", ignore_case = TRUE)
  out <- stringr::str_detect(x, pattern)
  out[is.na(out)] <- FALSE
  out
}

expect_hexcolor <- function(object) {
  # capture object and label
  act <- quasi_label(rlang::enquo(object))

  valid <- is_hexcolor(act$val)
  expect(
    all(valid),
    glue::glue("Not all elements of {act$lab} are hex colors.")
  )

  invisible(act$val)
}

# Needed to fix CRAN issues due to changes in all-equal function
# See https://github.com/Ryo-N7/tvthemes/issues/15
expect_eqNe <- function(...) {
  testthat::expect_equal(..., check.environment=FALSE)
}
