context("shapes")

test_that("show_shapes works", {
  # creates plot using base plotting system, so just run code --- any
  # errors / warnings will be caught.
  x <- 1:10
  expect_equal(show_shapes(x), x)
})

test_that("show_linetypes works", {
  x <- 1:5
  expect_equal(show_linetypes(x), x)
})

test_that("show_linetypes works with labels = FALSE", {
  x <- 1:5
  expect_equal(show_linetypes(x, labels = FALSE), x)
})
