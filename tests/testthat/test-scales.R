test_that("extended_range_breaks_ respects the n argument", {
  breaks5 <- extended_range_breaks_(1, 99, n = 5)
  breaks10 <- extended_range_breaks_(1, 99, n = 10)

  expect_true(length(breaks10) > length(breaks5))
  expect_equal(min(breaks5), 1)
  expect_equal(max(breaks5), 99)
  expect_equal(min(breaks10), 1)
  expect_equal(max(breaks10), 99)
})

test_that("extended_range_breaks_ breaks are within the data range", {
  breaks <- extended_range_breaks_(1, 99, n = 10)
  expect_true(min(breaks) >= 1)
  expect_true(max(breaks) <= 99)
})
