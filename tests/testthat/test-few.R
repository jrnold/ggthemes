context("few")

test_that("few_shape_pal works", {
  out <- few_shape_pal()
  expect_is(out, "function")
  expect_true(!is.null(attr(out, "max_n")))

  pal0 <- out(0)
  expect_identical(length(pal0), 0L)
  pal3 <- out(3)
  expect_identical(length(pal3), 3L)
  expect_error(out(10))

})

test_that("few_shape_pal works", {
  out <- scale_shape_few()
  expect_is(out, c("ScaleDiscrete", "Scale", "ggproto"))
})
