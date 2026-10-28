test_that("theme_base runs", {
  expect_s3_class(theme_base(), "theme")
})

test_that("theme_base uses the base graphics default text size", {
  thm <- theme_base()
  expect_equal(thm$text$size, 12)
  expect_equal(ggplot2::calc_element("axis.text.x.bottom", thm)$size, 12)
})

test_that("theme_par runs", {
  expect_s3_class(theme_par(), "theme")
})


test_that("theme_par applies las to tick labels, not axis titles", {
  skip_if_not_installed("withr")
  angles <- function(thm) {
    c(
      text_x = thm$axis.text.x$angle %||% 0,
      text_y = thm$axis.text.y$angle %||% 0,
      title_x = thm$axis.title.x$angle %||% 0,
      title_y = thm$axis.title.y$angle
    )
  }
  expected <- list(
    `0` = c(text_x = 0, text_y = 90, title_x = 0, title_y = 90),
    `1` = c(text_x = 0, text_y = 0, title_x = 0, title_y = 90),
    `2` = c(text_x = 90, text_y = 0, title_x = 0, title_y = 90),
    `3` = c(text_x = 90, text_y = 90, title_x = 0, title_y = 90)
  )
  for (las in names(expected)) {
    withr::with_par(list(las = as.integer(las)), {
      expect_equal(angles(theme_par()), expected[[las]], info = las)
    })
  }
})

test_that("theme_par uses adj for horizontal justification only", {
  skip_if_not_installed("withr")
  withr::with_par(list(adj = 0), {
    thm <- theme_par()
    expect_equal(thm$text$vjust, 0.5)
    expect_equal(thm$text$hjust, 0.5)
    expect_equal(thm$plot.title$hjust, 0)
    expect_equal(thm$axis.title$hjust, 0)
  })
})

test_that("theme_par draws the panel box in fg, not col", {
  skip_if_not_installed("withr")
  withr::with_par(list(col = "red", fg = "blue"), {
    thm <- theme_par()
    expect_equal(thm$panel.border$colour, "blue")
    expect_true(is.na(thm$panel.background$colour))
  })
})

test_that("theme_par maps bty to the panel border or axis lines", {
  skip_if_not_installed("withr")
  for (bty in c("l", "n")) {
    withr::with_par(list(bty = bty), {
      thm <- theme_par()
      expect_s3_class(thm$panel.border, "element_blank")
      expect_s3_class(thm$axis.line, "element_line")
    })
  }
  withr::with_par(list(bty = "o"), {
    expect_s3_class(theme_par()$panel.border, "element_rect")
  })
})

test_that("theme_par warns for the symbol font", {
  skip_if_not_installed("withr")
  # expect_snapshot() draws on its own graphics device, so set par() inside it.
  expect_snapshot(thm <- withr::with_par(list(font.main = 5), theme_par()))
  expect_equal(thm$plot.title$face, "plain")
})

test_that("theme_par scales text by cex and lines by lwd", {
  skip_if_not_installed("withr")
  withr::with_par(list(ps = 10, cex = 2, lwd = 3), {
    thm <- theme_par()
    expect_equal(thm$text$size, 20)
    expect_equal(thm$line$linewidth, 3 / ggplot2::.pt)
  })
})

test_that("theme_par styles subtitles and captions from the sub parameters", {
  skip_if_not_installed("withr")
  withr::with_par(list(col.sub = "red", font.sub = 3), {
    thm <- theme_par()
    expect_equal(thm$plot.subtitle$colour, "red")
    expect_equal(thm$plot.caption$face, "italic")
  })
})

test_that("theme_par drops annotation when ann is FALSE", {
  skip_if_not_installed("withr")
  withr::with_par(list(ann = FALSE), {
    thm <- theme_par()
    for (i in c("plot.title", "plot.subtitle", "plot.caption", "axis.title")) {
      expect_s3_class(thm[[i]], "element_blank")
    }
  })
})

test_that("theme_par converts tck and tcl to tick lengths", {
  skip_if_not_installed("withr")
  withr::with_par(list(tck = 1), {
    thm <- theme_par()
    expect_equal(thm$axis.ticks.length, grid::unit(0, "pt"))
    expect_s3_class(thm$panel.grid.major, "element_line")
  })
  withr::with_par(list(tcl = 0.5), {
    expect_lt(as.numeric(theme_par()$axis.ticks.length), 0)
  })
  withr::with_par(list(tck = -0.02), {
    expect_gt(as.numeric(theme_par()$axis.ticks.length), 0)
  })
})

test_that("theme_par sets geom defaults from par", {
  skip_if_not_installed("withr")
  withr::with_par(list(col = "red", bg = "gray90", lwd = 2, lty = "dashed", pch = 19, ljoin = "mitre"), {
    thm <- theme_par()
    expect_equal(thm$geom@ink, "red")
    expect_equal(thm$geom@paper, "gray90")
    expect_equal(thm$geom@linewidth, 2 / ggplot2::.pt)
    expect_equal(thm$geom@linetype, "dashed")
    expect_equal(thm$geom@pointshape, 19)
    expect_equal(thm$line$linejoin, "mitre")
  })
})

test_that("theme_par uses palette() for discrete scales, recycled", {
  skip_if_not_installed("withr")
  old <- grDevices::palette("Okabe-Ito")
  withr::defer(grDevices::palette(old))
  pal <- theme_par()$palette.colour.discrete
  cols <- grDevices::palette()
  expect_equal(pal(3), cols[1:3])
  expect_equal(pal(length(cols) + 1), c(cols, cols[1]))

  d <- data.frame(x = 1:3, y = 1:3, g = c("a", "b", "c"))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) + ggplot2::geom_point() + theme_par()
  expect_equal(ggplot2::ggplot_build(p)$data[[1]]$colour, cols[1:3])
})

test_that("theme_par uses the image() colours for continuous scales", {
  thm <- theme_par()
  expect_equal(thm$palette.fill.continuous, grDevices::hcl.colors(12, "YlOrRd", rev = TRUE))
  expect_equal(thm$palette.colour.continuous, thm$palette.fill.continuous)
})

test_that("theme_par recognizes xaxt", {
  skip_if_not_installed("withr")
  withr::with_par(list(xaxt = "n"), {
    thm <- theme_par()
    for (i in c("axis.line.x", "axis.text.x", "axis.ticks.x")) {
      expect_equal(thm[[i]], element_blank())
    }
  })
})

test_that("theme_par recognizes yaxt", {
  skip_if_not_installed("withr")
  withr::with_par(list(yaxt = "n"), {
    thm <- theme_par()
    for (i in c("axis.line.y", "axis.text.y", "axis.ticks.y")) {
      expect_equal(thm[[i]], element_blank())
    }
  })
})

test_that("theme_base draws correctly", {
  expect_doppelganger("theme_base", theme_test_plot() + theme_base())
})

test_that("theme_par draws correctly", {
  expect_doppelganger("theme_par", theme_test_plot() + theme_par())
})
