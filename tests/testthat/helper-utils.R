library("ggplot2")
library("grid")
library("scales")
library("glue")

is_hexcolor <- function(x) {
  out <- stringr::str_detect(x, regex("^#[a-f0-9]{6}$", ignore_case = TRUE))
  out[is.na(out)] <- FALSE
  out
}

expect_hexcolor <- function(object) {
  # capture object and label
  act <- quasi_label(rlang::enquo(object))

  valid <- is_hexcolor(act$val)
  expect(
    all(valid),
    glue("Not all elements of {act$lab} are hex colors.")
  )

  invisible(act$val)
}
