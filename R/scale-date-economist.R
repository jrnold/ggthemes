#' Date axis in the classic Economist style
#'
#' `scale_x_date_economist()` is a date scale for the bottom axis of a
#' [theme_economist()] chart, labeled the way *The Economist*'s print charts
#' labeled time. The labels follow the span of the data:
#'
#' * **Within one month**: a tick each day, the days numbered on the ticks
#'   every one, two, three or seven days, first and last included, and the
#'   month and year on a line below ("1 4 7 ... 28", "August 2013").
#' * **Up to about three months**: short ticks every day, two days or week,
#'   long ticks at the start of each month, and the month names centered under
#'   each month, with the year on a second line.
#' * **Up to about 18 months**: a tick at the start of each month, a long tick
#'   at the start of each year, the month names centered under each month, and
#'   the year centered under its months on a second line ("J F M A ... 2016").
#' * **Up to about ten years**: a long tick at the start of each year (and short
#'   monthly ticks up to five years), and each year centered under its span
#'   ("2015 2016"; "2008 09 10 ... 16").
#' * **Longer**: a tick at each year, and labels on the ticks every one, two,
#'   five, ten or more years, with the first and last years always labeled.
#'   The step is the smallest that keeps the labels apart and to about nine on
#'   a one-column chart (ten or eleven on a two-column one). A step year one or
#'   two years from the first or last year is dropped when that is under half
#'   a step: "1996 2000 05 10 15", "2000 02 ... 12 15", but "... 05 10 13".
#'
#' The labels shorten to fit the width the chart is drawn at, which the guide
#' measures when the plot is drawn: month names go from "September" to "Sep"
#' to "S", years from "2016" to "16" (the first and the first of each century
#' stay in full, as in [economist_2017_year()]), and on a long axis the step
#' between labeled years grows. The same plot drawn one column wide and two
#' columns wide gets different labels.
#'
#' Labels centered between ticks treat each date as a moment in time: a daily or
#' monthly series. For annual data placed on 1 January, use `unit = "year"`
#' and `center = FALSE`, so the labels sit on the ticks with the points.
#'
#' The labels are drawn by `guide_axis_economist_date()`, which is the default
#' guide of the scale; use it directly to give another date scale the same
#' axis. It draws only a bottom axis: at any other position it falls back to
#' [ggplot2::guide_axis()].
#'
#' @param name The name of the scale, used as the axis title.
#' @param ... Other arguments passed to [ggplot2::scale_x_date()].
#' @param unit The period labeled: `"auto"` chooses from the span of the
#'   limits, as above; `"day"`, `"month"` or `"year"` force one.
#' @param center For yearly labels, `TRUE` centers each year under its span and
#'   `FALSE` puts the labels on the ticks. The default, `NULL`, centers them
#'   when the axis spans ten and a half years or less.
#' @param tick_ratio The length of the short ticks as a share of the long
#'   ones. The long ticks take the theme's `axis.ticks.length.x.bottom`.
#' @param guide A guide for the axis; the default is
#'   `guide_axis_economist_date()`.
#' @param title A character string or expression for the axis title. The
#'   default, [ggplot2::waiver()], takes the title from the scale.
#' @param order A positive integer giving the order of this guide among
#'   multiple guides, or `0` to let ggplot2 decide.
#' @param position Where the axis is drawn. The default, [ggplot2::waiver()],
#'   uses the scale's position.
#'
#' @return `scale_x_date_economist()` returns a ggplot2 scale.
#'   `guide_axis_economist_date()` returns a guide object.
#'
#' @family economist
#' @export
#' @example inst/examples/ex-scale_x_date_economist.R
scale_x_date_economist <- function(
  name = ggplot2::waiver(),
  ...,
  unit = c("auto", "day", "month", "year"),
  center = NULL,
  tick_ratio = 0.5,
  guide = NULL
) {
  unit <- match.arg(unit)
  fixed <- intersect(names(list(...)), c("breaks", "date_breaks", "minor_breaks", "date_minor_breaks"))
  if (length(fixed)) {
    cli::cli_abort(c(
      "{.fn scale_x_date_economist} sets its breaks from the axis layout, so {.arg {fixed}} can't be given.",
      i = "Use {.code ggplot2::scale_x_date(guide = guide_axis_economist_date())} to choose other breaks."
    ))
  }
  guide <- guide %||% guide_axis_economist_date(unit = unit, center = center, tick_ratio = tick_ratio)
  scale <- ggplot2::scale_x_date(name = name, ..., minor_breaks = NULL, guide = guide)
  ggplot2::ggproto(
    NULL,
    scale,
    # Gridlines, where a theme draws them, fall on the long ticks. The layout is
    # taken from the unexpanded limits, as the guide takes it, not from the
    # expanded range the breaks are asked for.
    get_breaks = function(self, limits = self$get_limits()) {
      layout <- economist_date_layout(as.numeric(self$get_limits()), unit = unit, center = center)
      breaks <- layout$ticks$value[layout$ticks$long]
      breaks[breaks >= min(limits) & breaks <= max(limits)]
    }
  )
}

#' @rdname scale_x_date_economist
#' @export
guide_axis_economist_date <- function(
  title = ggplot2::waiver(),
  unit = c("auto", "day", "month", "year"),
  center = NULL,
  tick_ratio = 0.5,
  order = 0,
  position = ggplot2::waiver()
) {
  unit <- match.arg(unit)
  if (!is.null(center) && !rlang::is_bool(center)) {
    cli::cli_abort("{.arg center} must be {.code TRUE}, {.code FALSE} or {.code NULL}.")
  }
  if (!is.numeric(tick_ratio) || length(tick_ratio) != 1 || is.na(tick_ratio) || tick_ratio < 0) {
    cli::cli_abort("{.arg tick_ratio} must be a single non-negative number.")
  }
  ggplot2::new_guide(
    title = title,
    theme = NULL,
    check.overlap = FALSE,
    angle = NULL,
    n.dodge = 1,
    minor.ticks = FALSE,
    cap = "none",
    unit = unit,
    center = center,
    tick_ratio = tick_ratio,
    available_aes = "x",
    order = order,
    position = position,
    name = "axis",
    super = GuideAxisEconomistDate
  )
}

#' @rdname scale_x_date_economist
#' @format NULL
#' @usage NULL
#' @export
# nolint start: object_name_linter
GuideAxisEconomistDate <- ggplot2::ggproto(
  "GuideAxisEconomistDate",
  ggplot2::GuideAxis,
  params = c(ggplot2::GuideAxis$params, list(unit = "auto", center = NULL, tick_ratio = 0.5, layout = NULL)),

  extract_key = function(scale, aesthetic, unit = "auto", center = NULL, ...) {
    limits <- scale$get_limits()
    if (length(limits) != 2 || any(!is.finite(limits))) {
      return(ggplot2::GuideAxis$extract_key(scale, aesthetic, ...))
    }
    # Dates count days and date-times seconds; the layout works in days.
    per_day <- if (economist_is_datetime(scale)) 86400 else 1
    layout <- economist_date_layout(limits / per_day, unit = unit, center = center)
    # Every position the guide draws at is passed through the coord as one key,
    # tagged by what it is: an end of the limits, a tick, or a label in the
    # first or second row.
    n <- c(limit = 2, tick = nrow(layout$ticks), row1 = nrow(layout$row1), row2 = nrow(layout$row2))
    key <- data.frame(
      .kind = rep(names(n), n),
      .day = c(layout$limits, layout$ticks$value, layout$row1$value, layout$row2$value),
      .long = c(rep(NA, 2), layout$ticks$long, rep(NA, n[["row1"]] + n[["row2"]]))
    )
    key$.value <- key$.day * per_day
    key$.label <- rep("", nrow(key))
    key <- cbind(data.frame(x = scale$map(key$.value)), key)
    names(key)[1] <- aesthetic
    attr(key, "layout") <- layout
    key
  },

  extract_params = function(scale, params, ...) {
    params <- ggplot2::GuideAxis$extract_params(scale, params, ...)
    params$layout <- attr(params$key, "layout")
    params
  },

  draw = function(self, theme, position = NULL, direction = NULL, params = self$params) {
    position <- position %||% params$position
    layout <- params$layout
    if (!identical(position, "bottom") || is.null(layout)) {
      return(ggplot2::ggproto_parent(ggplot2::GuideAxis, self)$draw(theme, position, direction, params))
    }
    if (!is.null(params$theme)) {
      theme <- theme + params$theme
    }
    text <- ggplot2::calc_element("axis.text.x.bottom", theme)
    ticks <- ggplot2::calc_element("axis.ticks.x.bottom", theme)
    line <- ggplot2::calc_element("axis.line.x.bottom", theme)
    long <- ggplot2::calc_element("axis.ticks.length.x.bottom", theme)
    long <- if (inherits(ticks, "element_blank")) 0 else grid::convertHeight(long, "pt", valueOnly = TRUE)
    key <- params$key

    size <- if (inherits(text, "element_blank")) 0 else text$size
    margin <- if (inherits(text, "element_blank")) 0 else grid::convertHeight(text$margin[1], "pt", valueOnly = TRUE)
    rows <- if (inherits(text, "element_blank")) {
      0
    } else if (nrow(layout$row2) > 0) {
      2
    } else {
      1
    }
    lineheight <- size * (text$lineheight %||% 0.9) * 1.25
    height <- max(long, 0) + margin + rows * lineheight

    grob <- grid::gTree(
      key = key,
      layout = layout,
      text = text,
      ticks = ticks,
      line = line,
      long = long,
      short = long * params$tick_ratio,
      margin = margin,
      lineheight = lineheight,
      gp = if (inherits(text, "element_blank")) {
        grid::gpar()
      } else {
        grid::gpar(fontsize = text$size, fontfamily = text$family %||% "", fontface = text$face %||% "plain")
      },
      cl = "economist_date_axis"
    )
    gt <- gtable::gtable(widths = grid::unit(1, "npc"), heights = grid::unit(height, "pt"))
    gtable::gtable_add_grob(gt, grob, t = 1, l = 1, clip = "off", name = "axis")
  }
)
# nolint end

#' @exportS3Method grid::makeContent
makeContent.economist_date_axis <- function(x) {
  key <- x$key
  layout <- x$layout
  width <- grid::convertWidth(grid::unit(1, "npc"), "pt", valueOnly = TRUE)
  # Points per day, from the coord's own mapping of the ends of the limits.
  ends <- key[key$.kind == "limit", ]
  slope <- if (diff(ends$.day) > 0) diff(ends$x) / diff(ends$.day) * width else 0
  text_width <- function(labels) {
    if (!length(labels)) {
      return(numeric())
    }
    vapply(labels, function(l) grid::convertWidth(grid::stringWidth(l), "pt", valueOnly = TRUE), numeric(1))
  }
  # A label needs its own width and a gap of a quarter of the font size each side.
  pad <- if (inherits(x$text, "element_blank")) 0 else x$text$size * 0.25
  labels <- economist_date_labels(layout, slope, text_width, pad)

  children <- list()
  if (!inherits(x$line, "element_blank")) {
    children$line <- ggplot2::element_grob(x$line, x = grid::unit(c(0, 1), "npc"), y = grid::unit(c(1, 1), "npc"))
  }
  tk <- key[key$.kind == "tick", ]
  if (!inherits(x$ticks, "element_blank") && nrow(tk) > 0) {
    len <- ifelse(tk$.long, x$long, x$short)
    children$ticks <- ggplot2::element_grob(
      x$ticks,
      x = grid::unit(rep(tk$x, each = 2), "npc"),
      y = grid::unit(1, "npc") - grid::unit(rep(c(0, 1), nrow(tk)) * rep(len, each = 2), "pt"),
      id.lengths = rep(2, nrow(tk))
    )
  }
  if (!inherits(x$text, "element_blank")) {
    top <- grid::unit(1, "npc") - grid::unit(x$long + x$margin, "pt")
    gp <- grid::gpar(col = x$text$colour, fontsize = x$text$size)
    rows <- list(row1 = 0, row2 = 1)
    for (row in names(rows)) {
      pos <- key$x[key$.kind == row]
      lab <- labels[[row]]
      keep <- !is.na(lab)
      if (any(keep)) {
        children[[row]] <- grid::textGrob(
          lab[keep],
          x = grid::unit(pos[keep], "npc"),
          y = top - grid::unit(rows[[row]] * x$lineheight, "pt"),
          hjust = 0.5,
          vjust = 1,
          gp = gp
        )
      }
    }
  }
  grid::setChildren(x, do.call(grid::gList, children))
}

# Whether a scale, or the view scale a guide is trained on, is a date-time scale.
economist_is_datetime <- function(scale) {
  identical((scale$scale %||% scale)$get_transformation()$name, "time")
}

# Whole days from `lo` to `hi`, every `by`; empty if no day falls between.
economist_whole_days <- function(lo, hi, by = 1) {
  if (ceiling(lo) > floor(hi)) {
    return(numeric())
  }
  seq(ceiling(lo), floor(hi), by = by)
}

# Ticks and labels for a date axis from its limits, in days since 1970. The
# label text is chosen later, by economist_date_labels(), once the width the
# axis is drawn at is known.
economist_date_layout <- function(limits, unit = "auto", center = NULL) {
  lo <- min(limits)
  hi <- max(limits)
  span <- hi - lo
  if (unit == "auto") {
    unit <- if (span <= 92) {
      "day"
    } else if (span <= 548) {
      "month"
    } else {
      "year"
    }
  }
  if (unit == "year" && is.null(center)) {
    center <- span <= 365.25 * 10.5
  }
  from <- as.Date(lo, origin = "1970-01-01")
  to <- as.Date(hi, origin = "1970-01-01")
  inside <- function(d) d[as.numeric(d) >= lo & as.numeric(d) <= hi]
  month_starts <- seq(as.Date(format(from, "%Y-%m-01")), as.Date(format(to, "%Y-%m-01")) + 31, by = "month")
  year_starts <- seq(as.Date(format(from, "%Y-01-01")), as.Date(format(to, "%Y-01-01")) + 366, by = "year")

  # The visible part of each period between consecutive starts, and its middle.
  spans <- function(starts) {
    a <- pmax(as.numeric(starts[-length(starts)]), lo)
    b <- pmin(as.numeric(starts[-1]), hi)
    ok <- b > a
    data.frame(start = starts[-length(starts)][ok], from = a[ok], to = b[ok], value = (a[ok] + b[ok]) / 2)
  }
  empty_row <- data.frame(value = numeric(), from = numeric(), to = numeric())
  months <- function(min_share) {
    m <- spans(month_starts)
    m <- m[(m$to - m$from) >= min_share * 30.44, ]
    data.frame(
      value = m$value,
      from = m$from,
      to = m$to,
      full = month.name[as.integer(format(m$start, "%m"))],
      abbr = month.abb[as.integer(format(m$start, "%m"))],
      initial = substr(month.name[as.integer(format(m$start, "%m"))], 1, 1)
    )
  }
  years <- function(min_share) {
    y <- spans(year_starts)
    y <- y[(y$to - y$from) >= min_share * 365.25, ]
    yr <- as.integer(format(y$start, "%Y"))
    data.frame(
      value = y$value,
      from = y$from,
      to = y$to,
      full = as.character(yr),
      short = if (length(yr)) economist_2017_year(yr) else character()
    )
  }
  long_months <- inside(month_starts)
  long_years <- inside(year_starts)
  # The label steps on a long yearly axis; NULL leaves the default.
  steps <- NULL

  if (unit == "day" && format(from, "%Y-%m") == format(to, "%Y-%m")) {
    # Within one month: a tick each day, the days numbered on the ticks, and
    # the month and year on a line below ("1 4 7 ... 28 | August 2013").
    days <- economist_whole_days(lo, hi)
    ticks <- data.frame(value = days, long = rep(FALSE, length(days)))
    row1 <- data.frame(
      value = days,
      from = rep(NA_real_, length(days)),
      to = rep(NA_real_, length(days)),
      day = as.integer(format(as.Date(days, origin = "1970-01-01"), "%d"))
    )
    row2 <- data.frame(value = (lo + hi) / 2, from = lo, to = hi, full = format(from, "%B %Y"))
    unit <- "date"
  } else if (unit == "day") {
    step <- if (span <= 31) {
      1
    } else if (span <= 62) {
      2
    } else {
      7
    }
    days <- economist_whole_days(lo, hi, by = step)
    ticks <- data.frame(value = sort(unique(c(days, as.numeric(long_months)))))
    ticks$long <- ticks$value %in% as.numeric(long_months)
    row1 <- months(0)
    row2 <- years(0)
    row2 <- row2[c("value", "from", "to", "full")]
  } else if (unit == "month") {
    ticks <- data.frame(value = as.numeric(long_months))
    ticks$long <- ticks$value %in% as.numeric(long_years)
    row1 <- months(0.4)
    row2 <- years(0)
    row2 <- row2[c("value", "from", "to", "full")]
  } else if (center) {
    minor <- if (span <= 365.25 * 5) as.numeric(long_months) else numeric()
    ticks <- data.frame(value = sort(unique(c(minor, as.numeric(long_years)))))
    ticks$long <- ticks$value %in% as.numeric(long_years)
    row1 <- years(0.4)
    row2 <- empty_row
  } else {
    every <- if (span <= 365.25 * 60) {
      1
    } else if (span <= 365.25 * 150) {
      5
    } else {
      10
    }
    yr <- as.integer(format(long_years, "%Y"))
    # The first and last years are always labeled, so they are always ticked.
    tick_years <- long_years[yr %% every == 0 | seq_along(yr) %in% c(1, length(yr))]
    ticks <- data.frame(value = as.numeric(tick_years), long = rep(TRUE, length(tick_years)))
    # Every year on the axis is a candidate label; the step is chosen to fit,
    # from the steps that land on ticks.
    row1 <- data.frame(
      value = as.numeric(long_years),
      from = rep(NA_real_, length(yr)),
      to = rep(NA_real_, length(yr)),
      year = yr
    )
    row2 <- empty_row
    steps <- c(1, 2, 5, 10, 20, 25, 50, 100)
    steps <- steps[steps %% every == 0]
  }
  list(
    unit = unit,
    center = center,
    limits = c(lo, hi),
    ticks = ticks,
    row1 = row1,
    row2 = row2,
    steps = steps
  )
}

# The label text for each row of a layout, shortened to fit: `slope` is points
# per day and `text_width()` measures strings in points. Returns NA for a
# position left unlabeled.
economist_date_labels <- function(layout, slope, text_width, pad) {
  # In the corpus a one-column chart carries at most about nine year labels and
  # a two-column chart ten or eleven, however much room is left.
  most <- floor(8 + slope * diff(layout$limits) / 100)
  fits <- function(labels, room) all(text_width(labels) + 2 * pad <= room)
  pick <- function(row, variants, room) {
    for (v in variants) {
      if (fits(row[[v]], room)) {
        return(row[[v]])
      }
    }
    row[[variants[length(variants)]]]
  }
  # A part-month or part-year at either end of the axis loses its label if the
  # label, with a gap on the side toward its neighbour, is wider than the part
  # that is shown. The end of the axis needs no gap.
  drop_cramped <- function(labels, row, period) {
    shown <- row$to - row$from
    cramped <- text_width(labels) + pad > slope * shown & shown < 0.95 * period
    ends <- seq_along(labels) %in% c(1, length(labels))
    labels[cramped & ends] <- NA
    labels
  }
  row1 <- layout$row1
  row2 <- layout$row2
  out <- list(row1 = character(nrow(row1)), row2 = character(nrow(row2)))
  if (nrow(row1) > 0) {
    if (layout$unit == "date") {
      out$row1 <- economist_date_steps(
        row1$day,
        row1$value,
        slope,
        text_width,
        pad,
        # Day numbers are shorter than years; the checked examples carry ten in
        # a narrow column.
        most = most + 2,
        steps = c(1, 2, 3, 7),
        anchor = min(row1$day),
        format = as.character
      )
    } else if (layout$unit %in% c("day", "month")) {
      # Every label takes the same form: the one a whole month can hold (or the
      # widest month shown, if none is whole). A part month too narrow for that
      # form at either end goes unlabeled.
      room <- slope * min(30.44, max(row1$to - row1$from))
      out$row1 <- drop_cramped(pick(row1, c("full", "abbr", "initial"), room), row1, 30.44)
    } else if (isTRUE(layout$center)) {
      room <- slope * min(365.25, max(row1$to - row1$from))
      labels <- drop_cramped(pick(row1, c("full", "short"), room), row1, 365.25)
      # Shortened years are counted from the first one shown, which is in full.
      if (!identical(labels[!is.na(labels)], row1$full[!is.na(labels)])) {
        labels[!is.na(labels)] <- economist_2017_year(as.integer(row1$full[!is.na(labels)]))
      }
      out$row1 <- labels
    } else {
      out$row1 <- economist_date_steps(row1$year, row1$value, slope, text_width, pad, most = most, steps = layout$steps)
    }
  }
  if (nrow(row2) > 0) {
    room <- slope * (row2$to - row2$from)
    labels <- row2$full
    keep <- text_width(labels) + 2 * pad <= room
    # Always name at least one year: the one with the most room.
    if (!any(keep)) {
      keep[which.max(room)] <- TRUE
    }
    labels[!keep] <- NA
    out$row2 <- labels
  }
  out
}

# Labels on a long yearly axis, or the days of a month: the first and last
# values and every `step`-th value between (counted from `anchor`), for the
# smallest step that gives at most `most` labels, none touching. A step value one
# or two from the first or last is dropped when that is under half a step, so
# "2000 02 ... 12 15" rather than "... 12 14 15", but "... 05 10 13".
economist_date_steps <- function(
  n,
  value,
  slope,
  text_width,
  pad,
  most,
  steps = NULL,
  anchor = 0,
  format = economist_2017_year
) {
  if (!length(n)) {
    return(character())
  }
  first <- min(n)
  last <- max(n)
  steps <- steps %||% c(1, 2, 5, 10, 20, 25, 50, 100)
  for (step in steps) {
    near <- pmin(2, step / 2)
    keep <- (n - anchor) %% step == 0
    keep <- keep & (n - first > near | n == first) & (last - n > near | n == last)
    keep <- keep | n == first | n == last
    shown <- sort(n[keep])
    labels <- format(shown)
    w <- text_width(labels)
    gaps <- diff(value[match(shown, n)]) * slope
    if (!length(gaps) || (length(shown) <= most && all(gaps >= (w[-1] + w[-length(w)]) / 2 + 2 * pad))) {
      break
    }
  }
  out <- rep(NA_character_, length(n))
  out[match(shown, n)] <- labels
  out
}
