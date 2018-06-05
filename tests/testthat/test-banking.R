context("banking")

test_that("bank_slopes runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y)
  expect_equal(length(out), 1L)
  expect_is(out, "numeric")
})

test_that("bank_slopes with as runs", {
  x <- 1:5
  y <- runif(length(x))
  out <- bank_slopes(x, y, method = "as")
  expect_equal(length(out), 1L)
  expect_is(out, "numeric")
})

test_that("bank_slopes with invalid method throws error", {
  expect_error(bank_slopes(1:5, 1:5, method = "aor"))
})
