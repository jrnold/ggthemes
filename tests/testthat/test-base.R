context("base")

test_that("theme_base runs", {
  expect_is(theme_base(), "theme")
})

test_that("theme_par runs", {
  expect_is(theme_par(), "theme")
})


test_that("theme_par recognizes las", {
  withr::with_par(list(las = 1), {
    thm <- theme_par()
    expect_equal(thm$axis.title.x$angle, 0)
    expect_equal(thm$axis.title.y$angle, 0)
  })
  withr::with_par(list(las = 2), {
    thm <- theme_par()
    expect_equal(thm$axis.title.x$angle, 90)
    expect_equal(thm$axis.title.y$angle, 0)
  })
  withr::with_par(list(las = 3), {
    thm <- theme_par()
    expect_equal(thm$axis.title.x$angle, 90)
    expect_equal(thm$axis.title.y$angle, 90)
  })

})

test_that("theme_par recognizes tck", {
  withr::with_par(list(tck = 1), {
    expect_equal(theme_par()$axis.ticks.length, grid::unit(-1, "snpc"))
  })
})

test_that("theme_par recognizes xaxt", {
  withr::with_par(list(xaxt = "n"), {
    thm <- theme_par()
    for (i in c("axis.line.x", "axis.text.x", "axis.ticks.x")) {
      expect_equal(thm[[i]], element_blank())
    }
  })
})

test_that("theme_par recognizes yaxt", {
  withr::with_par(list(yaxt = "n"), {
    thm <- theme_par()
    for (i in c("axis.line.y", "axis.text.y", "axis.ticks.y")) {
      expect_equal(thm[[i]], element_blank())
    }
  })
})
