test_that("geom_label_economist() is a layer that annotate() can use", {
  l <- geom_label_economist(ggplot2::aes(x = 1, y = 1, label = "a"))
  expect_s3_class(l, "LayerInstance")
  expect_s3_class(l$geom, "GeomLabelEconomist")
  expect_equal(l$geom_params$pointer, "bottom")
  a <- ggplot2::annotate("label_economist", x = 1, y = 1, label = "a", pointer = "left")
  expect_s3_class(a$geom, "GeomLabelEconomist")
  expect_error(geom_label_economist(pointer = "middle"), "pointer")
})

test_that("the pointer is centred, or kept 6pt from the corners", {
  # 5pt wide, so its centre is at least 6 + 2.5 = 8.5pt from either end.
  expect_equal(label_economist_pointer_at(100, 0.5, 6), 50)
  expect_equal(label_economist_pointer_at(100, 0, 6), 8.5)
  expect_equal(label_economist_pointer_at(100, 1, 6), 91.5)
  expect_equal(label_economist_pointer_at(100, 0.3, 6), 30)
  # A side too short for the margin keeps the pointer centred.
  expect_equal(label_economist_pointer_at(12, 0, 6), 6)
})

test_that("text blocks are 12pt tall for one line and 23pt for two", {
  draw_block <- function(label, pointer = "bottom", hjust = 0.5, padding = 6) {
    block <- grid::gTree(
      x = 0.5, y = 0.5, label = label, pointer = pointer, padding = padding, hjust = hjust, vjust = 0.5,
      text_gp = grid::gpar(fontsize = 7.5, lineheight = 9.5 / 7.5),
      box_gp = grid::gpar(fill = "grey"),
      cl = "ggthemes_label_economist"
    )
    withr::local_pdf(NULL)
    grid::grid.newpage()
    built <- grid::makeContent(block)
    box <- built$children[[1]]
    centre_x <- grid::convertX(grid::unit(0.5, "npc"), "pt", valueOnly = TRUE)
    centre_y <- grid::convertY(grid::unit(0.5, "npc"), "pt", valueOnly = TRUE)
    list(
      x = grid::convertX(box$x, "pt", valueOnly = TRUE) - centre_x,
      y = grid::convertY(box$y, "pt", valueOnly = TRUE) - centre_y
    )
  }
  one <- draw_block("ECB announces QE")
  two <- draw_block("ECB announces\nQE beginning")
  # The pointer is 3.75pt deep, so the box runs from 3.75pt above the tip.
  expect_equal(min(one$y), 0)
  expect_equal(max(one$y) - 3.75, 12)
  expect_equal(max(two$y) - 3.75, 23)
  # The pointer is 5pt across and centred on the box.
  expect_equal(sort(one$x[c(2, 7)]), c(-2.5, 2.5))
  expect_equal(-min(one$x), max(one$x))
  # Narrower padding narrows the box by twice the difference.
  tight <- draw_block("ECB announces QE", padding = 2)
  expect_equal(diff(range(one$x)) - diff(range(tight$x)), 8)
  for (side in c("top", "left", "right", "none")) {
    expect_length(draw_block("a", side)$x, if (side == "none") 4 else 7)
  }
})

test_that("geom_label_economist() draws correctly", {
  blocks <- data.frame(
    x = c(1, 1, 2, 2, 3),
    y = c(2, 1, 2, 1, 1.5),
    label = c("One line", "Two\nlines", "Right", "Top, off-centre", "Left")
  )
  p <- ggplot2::ggplot(blocks, ggplot2::aes(x, y)) +
    geom_label_economist(ggplot2::aes(label = label), data = blocks[1:2, ]) +
    ggplot2::annotate("label_economist", x = 2, y = 2, label = "Right", pointer = "right") +
    ggplot2::annotate("label_economist", x = 2, y = 1, label = "Top, off-centre", pointer = "top", hjust = 0) +
    ggplot2::annotate("label_economist", x = 3, y = 1.5, label = "Left", pointer = "left") +
    ggplot2::geom_point() +
    ggplot2::coord_cartesian(xlim = c(0, 4), ylim = c(0, 3))
  expect_doppelganger("geom_label_economist", p)
})
