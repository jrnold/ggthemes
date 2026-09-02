library("testthat")

is_hexcolor <- function(x) {
  # `grepl()` returns FALSE for NA, which is the behaviour the callers want.
  grepl("^#[a-f0-9]{6}$", x, ignore.case = TRUE)
}

expect_hexcolor <- function(object) {
  # capture object and label
  act <- quasi_label(rlang::enquo(object))

  valid <- is_hexcolor(act$val)
  expect(
    all(valid),
    sprintf("Not all elements of %s are hex colors.", act$lab)
  )

  invisible(act$val)
}

expect_equal_scale <- function(x, y, ...) {
  x <- as.list(x)
  y <- as.list(y)
  x$call <- y$call <- NULL
  expect_equal(x, y, ...)
}
