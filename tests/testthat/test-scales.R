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
  expect_identical(zero_range(1), TRUE)
  expect_identical(zero_range(c(1, 1)), TRUE)
  expect_identical(zero_range(c(1, 2)), FALSE)
  expect_identical(zero_range(c(NA, 1)), NA)
  expect_identical(zero_range(c(-Inf, Inf)), FALSE)
})

test_that("zero_range errors for vectors of the wrong length", {
  expect_snapshot(zero_range(c(1, 2, 3)), error = TRUE)
})

test_that("precision returns a power of ten based on the range", {
  expect_equal(precision(c(1, 100)), 10)
  expect_equal(precision(c(0, 0.05)), 0.01)
  expect_equal(precision(5), 1)
})

test_that("smart_digits rounds to an appropriate number of digits", {
  out <- smart_digits(c(1.234, 5.678))
  expect_type(out, "character")
  expect_equal(smart_digits(numeric()), character())
})

test_that("smart_digits_format returns a formatting function", {
  fmt <- smart_digits_format()
  expect_type(fmt, "closure")
  expect_equal(fmt(c(1.234, 5.678)), smart_digits(c(1.234, 5.678)))
})

## economist_year(): the styleguide truncates a dated axis to two digits,
## keeping the first label and every century boundary in full (guide pp.6, 7,
## 13, 15, 16, 23).

test_that("economist_year reproduces the styleguide's own axes", {
  # p.7, "National anthem monopolies": 1948 through 2016 every four years.
  expect_equal(
    economist_year(seq(1948, 2016, 4)),
    c("1948", "52", "56", "60", "64", "68", "72", "76", "80", "84", "88", "92", "96", "2000", "04", "08", "12", "16")
  )
  # p.15, "Coming down everywhere".
  expect_equal(
    economist_year(c(1960, 1970, 1980, 1990, 2000, 2013)),
    c("1960", "70", "80", "90", "2000", "13")
  )
  # p.13, "African lion": no century crossing, so only the first is full.
  expect_equal(
    economist_year(seq(2004, 2014, 2)),
    c("2004", "06", "08", "10", "12", "14")
  )
})

test_that("economist_year keeps every century boundary in full", {
  expect_equal(economist_year(c(1890, 1900, 1910)), c("1890", "1900", "10"))
  # A boundary that is also the first label is not doubled up.
  expect_equal(economist_year(c(2000, 2002)), c("2000", "02"))
})

test_that("economist_year zero-pads single-digit years", {
  expect_equal(economist_year(c(1998, 2000, 2001)), c("1998", "2000", "01"))
})

test_that("economist_year passes NA through and anchors on the first shown break", {
  # ggplot2 hands out-of-range breaks over as NA, so the first non-NA entry is
  # the first label the reader actually sees.
  expect_equal(
    economist_year(c(NA, 1990, 1995, NA)),
    c(NA, "1990", "95", NA)
  )
})

test_that("economist_year leaves non-whole values in full", {
  # A two-digit form would misrepresent a fractional value.
  expect_equal(economist_year(c(2010, 2010.5, 2011)), c("2010", "2010.5", "11"))
})

test_that("economist_year handles degenerate input", {
  expect_equal(economist_year(numeric()), character())
  expect_equal(economist_year(1999), "1999")
  expect_equal(economist_year(NA_real_), NA_character_)
})

test_that("economist_year_format returns a labelling function", {
  f <- economist_year_format()
  expect_type(f, "closure")
  expect_equal(f(c(1948, 1952)), c("1948", "52"))
})
