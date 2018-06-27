context("shapes")

test_that("circlefill_pal works", {
  pal <- circlefill_shape_pal()
  expect_is(pal, "function")
  expect_equal(attr(pal, "max_n"), 5L)
  n <- 4L
  values <- pal(n)
  expect_is(values, "integer")
  expect_equal(length(values), n)
})

test_that("scale_shape_circlefill works", {
  expect_is(scale_shape_circlefill(), "ScaleDiscrete")
})

test_that("tremmel_shape_pal works", {
  pal <- tremmel_shape_pal()
  expect_is(pal, "function")
  expect_equal(attr(pal, "max_n"), 3L)
  n <- 3L
  values <- pal(n)
  expect_is(values, "integer")
  expect_equal(length(values), n)
})

test_that("tremmel_shape_pal works for all values", {
  for (i in 1:3L) {
    expect_equal(length(tremmel_shape_pal()(i)), i)
    expect_equal(length(tremmel_shape_pal(alt = TRUE)(i)), i)
    expect_equal(length(tremmel_shape_pal(overlap = TRUE)(i)), i)
  }
})

test_that("scale_shape_tremmel works", {
  expect_is(scale_shape_tremmel(), "ScaleDiscrete")
})

test_that("cleveland_shape_pal works", {
  pal <- cleveland_shape_pal()
  expect_is(pal, "function")
  expect_equal(attr(pal, "max_n"), 4)
  n <- 3
  vals <- pal(n)
  expect_equal(length(vals), n)
})

test_that("tremmel_pal arg n3alt is deprected", {
  expect_warning(tremmel_shape_pal(n3alt = FALSE))
  expect_warning(tremmel_shape_pal(n3alt = TRUE))
})

test_that("cleveland_shape_pal works with overlap = FALSE", {
  pal <- cleveland_shape_pal(overlap = FALSE)
  expect_is(pal, "function")
  expect_equal(attr(pal, "max_n"), 5)
  n <- 3
  vals <- pal(n)
  expect_equal(length(vals), n)
  expect_is(vals, "integer")
  expect_true(all(vals < 0))
})

test_that("scale_shape_cleveland works", {
  expect_is(scale_shape_cleveland(), "ScaleDiscrete")
})
