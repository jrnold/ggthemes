test_that("stata_pal works", {
  p <- stata_pal()
  expect_type(p, "closure")
  expect_type(attr(p, "max_n"), "integer")
  n <- 5
  vals <- p(n)
  expect_hexcolor(vals)
  expect_length(vals, n)
  expect_warning(stata_pal()(100))
})

test_that("scale_colour_stata works", {
  expect_s3_class(scale_colour_stata(), "ScaleDiscrete")
})

test_that("scale_color_stata works", {
  expect_equal_scale(scale_colour_stata(), scale_color_stata())
})

test_that("scale_fill_stata works", {
  expect_s3_class(scale_fill_stata(), "ScaleDiscrete")
})

test_that("scale_shape_stata works", {
  expect_s3_class(scale_shape_stata(), "ScaleDiscrete")
})

test_that("theme_stata works", {
  expect_s3_class(theme_stata(), "theme")
  for (i in c("s2mono", "s1mono", "s2manual", "s1rcolor", "s1color")) {
    expect_s3_class(theme_stata(scheme = i), "theme")
  }
})

test_that("theme_state raises error with invallid scheme", {
  expect_error(theme_stata(scheme = "dsagasagdadgaga"),
    regexp = "`scheme` must be one of"
  )
})

test_that("stata_shape_pal works", {
  p <- stata_shape_pal()
  expect_type(p, "closure")
  n <- 5L
  vals <- p(n)
  expect_type(vals, "integer")
  expect_length(vals, n)
  expect_true(all(vals < 0))
  expect_warning(p(100))
})

test_that("stata_linetype_pal works", {
  p <- stata_linetype_pal()
  expect_type(p, "closure")
  n <- 5L
  vals <- p(n)
  expect_equal(vals, c("solid", "84", "23", "F414", "F4"))
})

test_that("scale_linetype_stata works", {
  expect_s3_class(scale_linetype_stata(), "ScaleDiscrete")
})
