# The layout and labels of scale_x_date_economist(), checked against the
# classic print charts it copies.

days <- function(from, to) as.numeric(as.Date(c(from, to)))
# Text widths at 6.5pt, about 0.55 em a character.
text_width_pt <- function(x) nchar(x) * 6.5 * 0.55
labels_at <- function(from, to, width, ...) {
  limits <- days(from, to)
  layout <- economist_date_layout(limits, ...)
  economist_date_labels(layout, width / diff(limits), text_width_pt, 6.5 * 0.25)
}

test_that("the unit follows the span of the limits", {
  expect_equal(economist_date_layout(days("2016-10-24", "2016-11-28"))$unit, "day")
  expect_equal(economist_date_layout(days("2016-01-01", "2016-11-20"))$unit, "month")
  expect_equal(economist_date_layout(days("2015-01-01", "2016-11-20"))$unit, "year")
  expect_true(economist_date_layout(days("2007-06-01", "2016-11-25"))$center)
  expect_false(economist_date_layout(days("1996-01-01", "2015-01-01"))$center)
  expect_equal(economist_date_layout(days("2015-01-01", "2016-11-20"), unit = "month")$unit, "month")
})

test_that("a month axis ticks each month, with a long tick at the new year", {
  layout <- economist_date_layout(days("2015-11-15", "2016-03-20"))
  expect_equal(
    as.Date(layout$ticks$value, origin = "1970-01-01"),
    as.Date(c("2015-12-01", "2016-01-01", "2016-02-01", "2016-03-01"))
  )
  expect_equal(layout$ticks$long, c(FALSE, TRUE, FALSE, FALSE))
  # Half of November is shown, so it is labeled; the year row names both years.
  expect_equal(layout$row1$abbr, c("Nov", "Dec", "Jan", "Feb", "Mar"))
  expect_equal(layout$row2$full, c("2015", "2016"))
})

test_that("month names shorten to fit the width (S&P 500 banks, Last-minute sprint, Stockmarkets)", {
  expect_equal(
    labels_at("2016-01-01", "2016-11-20", 130)$row1,
    c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N")
  )
  expect_equal(labels_at("2016-01-01", "2016-11-20", 130)$row2, "2016")
  expect_equal(labels_at("2016-06-01", "2016-11-20", 130)$row1, c("Jun", "Jul", "Aug", "Sep", "Oct", "Nov"))
  expect_equal(labels_at("2016-10-20", "2016-11-28", 290)$row1, c("October", "November"))
})

test_that("years are centered under their spans, shortened after the first (Under-achiever, The Zuma years)", {
  expect_equal(labels_at("2015-01-01", "2016-11-20", 130)$row1, c("2015", "2016"))
  # A quarter of 2007 is too little to label; the first year shown is in full.
  expect_equal(
    labels_at("2007-10-01", "2016-11-25", 130)$row1,
    c("2008", "09", "10", "11", "12", "13", "14", "15", "16")
  )
  # Half of 2007 is labeled, but not where its label would not fit.
  expect_equal(labels_at("2007-07-01", "2016-11-25", 100)$row1[1:2], c(NA, "2008"))
})

test_that("a long axis labels the first and last years and every few between", {
  on <- function(from, to, width) {
    out <- labels_at(from, to, width, unit = "year", center = FALSE)$row1
    out[!is.na(out)]
  }
  # Partners in decline, Papered over and Dedicated followers of fashion.
  expect_equal(on("2000-01-01", "2015-01-01", 130), c("2000", "02", "04", "06", "08", "10", "12", "15"))
  expect_equal(on("1996-01-01", "2015-01-01", 130), c("1996", "2000", "05", "10", "15"))
  expect_equal(on("1985-01-01", "2016-01-01", 290), c("1985", "90", "95", "2000", "05", "10", "16"))
})

test_that("an end year two or more steps' worth away keeps its neighbour", {
  out <- labels_at("1990-01-01", "2013-01-01", 130, unit = "year", center = FALSE)$row1
  expect_equal(out[!is.na(out)], c("1990", "95", "2000", "05", "10", "13"))
})

test_that("an axis within one month numbers its days (Oil, August 2013)", {
  layout <- economist_date_layout(days("2013-08-01", "2013-08-28"))
  expect_equal(layout$unit, "date")
  expect_false(any(layout$ticks$long))
  out <- labels_at("2013-08-01", "2013-08-28", 100)
  expect_equal(out$row1[!is.na(out$row1)], as.character(seq(1, 28, by = 3)))
  expect_equal(out$row2, "August 2013")
})

test_that("a forced unit with no tick inside the limits still draws", {
  plot_unit <- function(d, ...) {
    ggplot2::ggplot(data.frame(date = d, v = 1), ggplot2::aes(date, v)) +
      ggplot2::geom_point() +
      scale_x_date_economist(...) +
      theme_economist()
  }
  expect_no_error(ggplot2::ggplotGrob(plot_unit(as.Date("2016-01-03") + 0:10, unit = "month")))
  expect_no_error(ggplot2::ggplotGrob(plot_unit(as.Date("2016-02-03") + 0:200, unit = "year")))
  expect_no_error(ggplot2::ggplotGrob(plot_unit(as.Date("2016-02-03") + 0:200, unit = "year", center = FALSE)))
})

test_that("the gridlines fall on the long ticks, not on breaks from the expanded range", {
  df <- data.frame(date = as.Date("2016-01-01") + 0:88, v = 1)
  p <- ggplot2::ggplot(df, ggplot2::aes(date, v)) + ggplot2::geom_point() + scale_x_date_economist()
  params <- ggplot2::ggplot_build(p)$layout$panel_params[[1]]
  layout <- params$guides$get_params(1)$layout
  expect_equal(as.numeric(params$x$breaks), layout$ticks$value[layout$ticks$long])
  expect_equal(as.Date(params$x$breaks), as.Date(c("2016-01-01", "2016-02-01", "2016-03-01")))
})

test_that("an axis within one day has no ticks off the axis", {
  layout <- economist_date_layout(c(100.2, 100.8))
  expect_equal(nrow(layout$ticks), 0)
  expect_equal(layout$row2$full, "April 1970")
  # A date-time axis within one day, and one over a month.
  plot_time <- function(by, n) {
    df <- data.frame(t = as.POSIXct("1970-04-11 05:00", tz = "UTC") + seq_len(n) * by, v = 1)
    ggplot2::ggplot(df, ggplot2::aes(t, v)) +
      ggplot2::geom_line() +
      ggplot2::scale_x_datetime(guide = guide_axis_economist_date())
  }
  expect_no_error(ggplot2::ggplotGrob(plot_time(3600, 14)))
  p <- plot_time(86400, 30)
  layout <- ggplot2::ggplot_build(p)$layout$panel_params[[1]]$guides$get_params(1)$layout
  expect_equal(layout$unit, "day")
})

test_that("a sliver of a month at an end neither shrinks the other labels nor keeps its own", {
  out <- labels_at("2016-01-31", "2016-04-01", 300)
  expect_equal(out$row1, c(NA, "February", "March"))
  # Most of a month at the end keeps its initial on a narrow chart (A year of shocks).
  out <- labels_at("2016-01-01", "2016-11-25", 90)
  expect_equal(out$row1[[11]], "N")
})

test_that("a long yearly axis labels only ticked years", {
  limits <- days("1937-01-01", "2016-01-01")
  layout <- economist_date_layout(limits, unit = "year", center = FALSE)
  out <- economist_date_labels(layout, 130 / diff(limits), text_width_pt, 6.5 * 0.25)$row1
  expect_true(all(layout$row1$value[!is.na(out)] %in% layout$ticks$value))
  expect_equal(out[!is.na(out)], c("1937", "50", "75", "2000", "16"))
})

test_that("scale_x_date_economist refuses breaks it would override", {
  expect_snapshot(error = TRUE, scale_x_date_economist(breaks = NULL))
  expect_snapshot(error = TRUE, scale_x_date_economist(minor_breaks = NULL))
})

test_that("guide_axis_economist_date checks its arguments", {
  expect_error(guide_axis_economist_date(center = "yes"), "center")
  expect_error(guide_axis_economist_date(tick_ratio = -1), "tick_ratio")
  expect_error(guide_axis_economist_date(unit = "week"))
})

test_that("scale_x_date_economist draws one axis grob and falls back off the bottom", {
  df <- data.frame(date = as.Date("2016-01-01") + 0:300, v = 1)
  p <- ggplot2::ggplot(df, ggplot2::aes(date, v)) +
    ggplot2::geom_line() +
    scale_x_date_economist() +
    theme_economist(base_size = 6.5)
  gt <- ggplot2::ggplotGrob(p)
  axis <- gt$grobs[[which(gt$layout$name == "axis-b")]]
  expect_s3_class(axis$grobs[[1]], "economist_date_axis")
  top <- ggplot2::ggplot(df, ggplot2::aes(date, v)) +
    ggplot2::geom_line() +
    ggplot2::scale_x_date(position = "top", guide = guide_axis_economist_date())
  expect_no_error(ggplot2::ggplotGrob(top))
})

test_that("scale_x_date_economist draws the classic date axes", {
  plot_dates <- function(from, to, by = "day", ...) {
    d <- seq(as.Date(from), as.Date(to), by = by)
    ggplot2::ggplot(data.frame(date = d, v = sin(seq_along(d) / 20)), ggplot2::aes(date, v)) +
      ggplot2::geom_line(colour = "#00526d") +
      scale_x_date_economist(NULL, ...) +
      ggplot2::scale_y_continuous(NULL, position = "right") +
      theme_economist(base_size = 6.5)
  }
  expect_doppelganger("scale_x_date_economist-months", plot_dates("2016-01-01", "2016-11-20"))
  expect_doppelganger("scale_x_date_economist-years", plot_dates("2015-01-01", "2016-11-20"))
  expect_doppelganger("scale_x_date_economist-days", plot_dates("2016-01-20", "2016-03-25"))
  expect_doppelganger("scale_x_date_economist-dates", plot_dates("2013-08-01", "2013-08-28"))
  expect_doppelganger(
    "scale_x_date_economist-annual",
    plot_dates("2000-01-01", "2015-01-01", by = "year", unit = "year", center = FALSE)
  )
})
