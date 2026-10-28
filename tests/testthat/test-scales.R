test_that("extended_range_breaks_ respects the n argument", {
  breaks5 <- extended_range_breaks_(1, 99, n = 5)
  breaks10 <- extended_range_breaks_(1, 99, n = 10)

  expect_gt(length(breaks10), length(breaks5))
  expect_equal(min(breaks5), 1)
  expect_equal(max(breaks5), 99)
  expect_equal(min(breaks10), 1)
  expect_equal(max(breaks10), 99)
})

test_that("extended_range_breaks_ breaks are within the data range", {
  breaks <- extended_range_breaks_(1, 99, n = 10)
  expect_gte(min(breaks), 1)
  expect_lte(max(breaks), 99)
})

test_that("extended_range_breaks_ swaps dmin and dmax when reversed", {
  breaks <- extended_range_breaks_(99, 1, n = 5)
  expect_equal(min(breaks), 1)
  expect_equal(max(breaks), 99)
})

test_that("extended_range_breaks_ handles a near-zero range", {
  breaks <- extended_range_breaks_(5, 5, n = 5)
  expect_equal(breaks, seq(from = 5, to = 5, length.out = 5))
})

test_that("extended_range_breaks returns a breaks function", {
  breaks_fun <- extended_range_breaks(n = 5)
  expect_type(breaks_fun, "closure")
  breaks <- breaks_fun(c(1, 99))
  expect_equal(min(breaks), 1)
  expect_equal(max(breaks), 99)
})

test_that("zero_range detects degenerate ranges", {
  expect_true(zero_range(1))
  expect_true(zero_range(c(1, 1)))
  expect_false(zero_range(c(1, 2)))
  expect_identical(zero_range(c(NA, 1)), NA)
  expect_false(zero_range(c(-Inf, Inf)))
})

test_that("zero_range errors for vectors of the wrong length", {
  expect_snapshot(zero_range(c(1, 2, 3)), error = TRUE)
})

test_that("precision returns a power of ten based on the smallest gap", {
  expect_equal(precision(c(1, 100)), 1)
  expect_equal(precision(c(0, 0.05)), 0.01)
  expect_equal(precision(c(0, 25, 50, 75, 100)), 1)
  expect_equal(precision(c(0, 200, 400)), 100)
  expect_equal(precision(5), 1)
  expect_equal(precision(0), 1)
})

test_that("smart_digits rounds to an appropriate number of digits", {
  out <- smart_digits(c(1.234, 5.678))
  expect_type(out, "character")
  expect_equal(smart_digits(numeric()), character())
})

test_that("smart_digits keeps evenly spaced breaks distinct", {
  expect_equal(trimws(smart_digits(c(0, 25, 50, 75, 100))), c("0", "25", "50", "75", "100"))
  expect_equal(trimws(smart_digits(c(0, 0.25, 0.5, 0.75, 1))), c("0.00", "0.25", "0.50", "0.75", "1.00"))
  expect_equal(trimws(smart_digits(c(0, 2.5, 5, 7.5, 10))), c("0.0", "2.5", "5.0", "7.5", "10.0"))
  expect_equal(trimws(smart_digits(0)), "0")
  expect_equal(trimws(smart_digits(c(1e-9, 2e-9, 3e-9))), c("1e-09", "2e-09", "3e-09"))
})

test_that("smart_digits_format returns a formatting function", {
  fmt <- smart_digits_format()
  expect_type(fmt, "closure")
  expect_equal(fmt(c(1.234, 5.678)), smart_digits(c(1.234, 5.678)))
})
