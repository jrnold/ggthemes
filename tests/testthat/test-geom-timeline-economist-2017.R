# Columns are referenced through the `.data` pronoun, as in the other tests.
.data <- rlang::.data

test_that("timeline layers use their geoms", {
  expect_s3_class(geom_event_economist_2017()$geom, "GeomEventEconomist2017")
  expect_s3_class(geom_span_economist_2017()$geom, "GeomSpanEconomist2017")
  expect_s3_class(geom_period_economist_2017()$geom, "GeomPeriodEconomist2017")
  expect_s3_class(geom_year_band_economist_2017(1990, 2000)$geom, "GeomYearBandEconomist2017")
  expect_error(geom_year_band_economist_2017(2000, 1990))
  event <- ggplot2::annotate("event_economist_2017", x = 1, y = 0, yend = 1, label = "a")
  expect_s3_class(event$geom, "GeomEventEconomist2017")
})

timeline_plot <- function() {
  events <- data.frame(
    x = c(1992, 1998, 2004, 2010),
    yend = c(3, 2.5, 3, -0.6),
    label = c("Right of the rule", "Centred", "Left of\nthe rule", "Below"),
    hjust = c(0, 0.5, 1, 0.5)
  )
  ggplot2::ggplot() +
    geom_span_economist_2017(ggplot2::aes(xmin = 1995, xmax = 2001, ymin = 0, ymax = 2, label = "A period")) +
    geom_event_economist_2017(
      ggplot2::aes(.data$x, y = 0, yend = .data$yend, label = .data$label, hjust = .data$hjust),
      data = events
    ) +
    geom_year_band_economist_2017(from = 1990, to = 2015, y = 0) +
    geom_period_economist_2017(
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
  expect_doppelganger("geom_timeline_economist_2017", timeline_plot())
})

test_that("a year band of one year draws, and draws in every facet", {
  d <- data.frame(x = c(2004, 2006, 2008), y = 1)
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    geom_year_band_economist_2017(2005, 2005)
  expect_no_error(ggplot2::ggplotGrob(p))
  faceted <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    geom_year_band_economist_2017(2004, 2008) +
    ggplot2::facet_wrap(~x)
  expect_equal(as.vector(table(ggplot2::layer_data(faceted, 2)$PANEL)), rep(1, 3))
})
