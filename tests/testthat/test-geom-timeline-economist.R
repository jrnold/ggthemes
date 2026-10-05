# Columns are referenced through the `.data` pronoun, as in the other tests.
.data <- rlang::.data

test_that("timeline layers use their geoms", {
  expect_s3_class(geom_event_economist()$geom, "GeomEventEconomist")
  expect_s3_class(geom_span_economist()$geom, "GeomSpanEconomist")
  expect_s3_class(geom_period_economist()$geom, "GeomPeriodEconomist")
  expect_s3_class(geom_year_band_economist(1990, 2000)$geom, "GeomYearBandEconomist")
  expect_error(geom_year_band_economist(2000, 1990))
  expect_s3_class(ggplot2::annotate("event_economist", x = 1, y = 0, yend = 1, label = "a")$geom, "GeomEventEconomist")
})

timeline_plot <- function() {
  events <- data.frame(
    x = c(1992, 1998, 2004, 2010),
    yend = c(3, 2.5, 3, -0.6),
    label = c("Right of the rule", "Centred", "Left of\nthe rule", "Below"),
    hjust = c(0, 0.5, 1, 0.5)
  )
  ggplot2::ggplot() +
    geom_span_economist(ggplot2::aes(xmin = 1995, xmax = 2001, ymin = 0, ymax = 2, label = "A period")) +
    geom_event_economist(
      ggplot2::aes(.data$x, y = 0, yend = .data$yend, label = .data$label, hjust = .data$hjust),
      data = events
    ) +
    geom_year_band_economist(from = 1990, to = 2015, y = 0) +
    geom_period_economist(
      ggplot2::aes(xmin = .data$xmin, xmax = .data$xmax, y = -1.4, label = .data$label),
      data = data.frame(xmin = c(1990, 1997, 2005), xmax = c(1997, 2005, 2016), label = c("One", "Two", "Three"))
    ) +
    ggplot2::coord_cartesian(xlim = c(1990, 2016), ylim = c(-2.2, 4), expand = FALSE, clip = "off")
}

test_that("unmapped period bars alternate through `fills` in time order", {
  built <- ggplot2::ggplot_build(timeline_plot())
  periods <- built$plot$layers[[4]]
  grob <- periods$geom$draw_panel(
    built$data[[4]][3:1, ], built$layout$panel_params[[1]], built$layout$coord,
    fills = c("red", "blue")
  )
  bars <- Filter(function(g) inherits(g, "rect"), grob$children)
  expect_equal(unname(vapply(bars, function(b) b$gp$fill, "")), c("red", "blue", "red"))
})

test_that("the year band labels years the guide's way", {
  built <- ggplot2::ggplot_build(timeline_plot())
  band <- built$plot$layers[[3]]
  grob <- band$geom$draw_panel(
    built$data[[3]], built$layout$panel_params[[1]], built$layout$coord,
    from = 1990, to = 2015, label_every = 5
  )
  cells <- grob$children[[1]]
  expect_length(cells$x, 26)
  expect_equal(sum(cells$gp$fill == "#A1C3D5"), 6)
  expect_equal(grob$children[[3]]$label, c("1990", "95", "2000", "05", "10", "15"))
})

test_that("timeline layers draw correctly", {
  expect_doppelganger("geom_timeline_economist", timeline_plot())
})
