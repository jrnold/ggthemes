# Shared setup of "The classic Economist chart style, 2012-2016" (economist-classic-styleguide.Rmd) and its child
# documents, `_classic-guide-*.Rmd`. Sourced from the article's setup chunk; nothing here is exported.

library(ggthemes)
library(ggplot2)
library(grid)
library(gtable)

# The red tab, the dots and the coloured axis titles of the classic-vs-2017 article, and the chunk options that size a
# figure from `econ_size` and `econ_height` (in points). This guide draws one chart per figure, not a pair.
source("economist-classic-helpers.R")
knitr::opts_chunk$set(econ_pair = FALSE)

# The aesthetics of some helper functions are columns of their data.
.data <- rlang::.data

# ---- The evidence ---------------------------------------------------------------------------------------------------
# One row per claim measured on the chart corpus, and the archived image and article of every chart a claim cites
# (`export_guide.py` of the corpus pipeline writes both). `periods.csv` has pixel measurements of every print chart by
# half-year, 2012 to 2016; `years.csv` the shares of some conventions in the sample read chart by chart, by year.
ev <- read.csv("economist-classic/evidence.csv", stringsAsFactors = FALSE)
charts <- read.csv("economist-classic/charts.csv", stringsAsFactors = FALSE)
# Charts cited outside the sample read chart by chart (the 2016 measurements, truncated bars); checked by eye.
charts <- rbind(charts, read.csv("economist-classic/charts-extra.csv", stringsAsFactors = FALSE))
periods <- read.csv("economist-classic/periods.csv", stringsAsFactors = FALSE)
years <- read.csv("economist-classic/years.csv", stringsAsFactors = FALSE)
# Counts on the titles and subtitles of the print charts, as the corpus read them; the kinds of title were classified
# by Claude from each title and its subtitle.
words <- read.csv("economist-classic/words.csv", stringsAsFactors = FALSE)
# The time axes of 190 sampled charts and 16 daily-data charts, read from their images, and how the end years of
# the axes with labels on the ticks were handled.
time_axes <- read.csv("economist-classic/time-axes.csv", stringsAsFactors = FALSE)
time_axes_ends <- read.csv("economist-classic/time-axes-ends.csv", stringsAsFactors = FALSE)
# The marks given on the review page to the charts the reading put under each claim, counted by section: "good" and
# "ok" charts show the claim, "poor" ones show it but not cleanly, "wrong" ones do not. Charts of claims since dropped
# from the guide are counted together.
verification <- read.csv("economist-classic/verification.csv", stringsAsFactors = FALSE)

# The strength of a convention from its share: a rule at 90% or more, a default from 60%, an option from 15%, and
# rare below that or when it could apply to fewer than 15 panels or charts.
strength_cuts <- c(rule = 0.9, default = 0.6, option = 0.15, cases = 15)
strength_of <- function(n, of) {
  s <- n / of
  out <- ifelse(
    s >= strength_cuts[["rule"]],
    "Rule",
    ifelse(s >= strength_cuts[["default"]], "Default", ifelse(s >= strength_cuts[["option"]], "Option", "Rare"))
  )
  out[of < strength_cuts[["cases"]]] <- "Rare"
  out
}

claim <- function(id, medium = "print") {
  r <- ev[ev$claim_id == id & ev$medium == medium, ]
  if (nrow(r) == 0) {
    stop("no claim ", id, " for ", medium)
  }
  r[1, ]
}
# "98%, 319 of 325 panels": no parentheses of its own, so it reads inside the prose's parentheses too.
share <- function(id, medium = "print") {
  r <- claim(id, medium)
  sprintf("%s%%, %s of %s %s", round(100 * r$n / r$of), r$n, r$of, r$unit)
}
# Just the percentage: "98%".
pct <- function(id, medium = "print") {
  r <- claim(id, medium)
  paste0(round(100 * r$n / r$of), "%")
}
# The guide's names for the sections of the evidence.
section_names <- c(
  Scope = "Scope",
  `Chart sizes` = "Chart sizes",
  Anatomy = "Anatomy",
  Layout = "Layout",
  `Chart types` = "Chart types",
  `Colour: ground` = "Color: ground",
  `Colour: palette` = "Color: palette",
  `Colour: order` = "Color: sets and order",
  bar_column_side_by_side = "Bar / column, side by side",
  bar_column_stacked = "Bar / column, stacked",
  lines = "Lines, side by side",
  lines_stacked_area = "Lines, stacked",
  thermometer = "Thermometer",
  scatter = "Scatter plot",
  connected_scatter = "Connected scatter",
  bubble = "Bubble chart",
  slope = "Slope charts",
  table = "Tables",
  pie_doughnut = "Pie / doughnut",
  double_scale = "Double-scale charts",
  blob_heads = "Blob heads",
  timeline = "Timelines",
  fan_forecast = "Fan charts",
  pictogram = "Pictograms",
  waterfall = "Waterfalls"
)
# Every claim of the evidence as a table for the appendix, by section of the guide. Sections that count how common
# something is (chart types, sizes, series colors, layouts) are prevalence, not conventions, and get no strength.
conventions_table <- function() {
  prevalence <- c("Scope", "Chart sizes", "Layout", "Chart types", "Colour: palette")
  d <- ev[ev$medium == "print", ]
  d <- d[order(match(d$section, names(section_names)), -d$n / d$of), ]
  ## "lines: gridlines = horizontal" reads as "gridlines: horizontal" under its section's heading.
  what <- sub("^[a-z_]+: ", "", d$statement)
  what <- sub(" = ", ": ", what, fixed = TRUE)
  data.frame(
    Section = unname(section_names[d$section]),
    Convention = what,
    Share = sprintf("%s%%", round(100 * d$n / d$of)),
    Count = sprintf("%s of %s %s", d$n, d$of, d$unit),
    Strength = ifelse(d$section %in% prevalence, "", strength_of(d$n, d$of)),
    check.names = FALSE
  )
}
# Links to charts by code: the title links to the archived image, "article" to the article it ran with.
cite_codes <- function(codes) {
  codes <- codes[!is.na(codes) & codes != ""]
  if (!length(codes)) {
    return("(examples not yet checked)")
  }
  ch <- charts[match(codes, charts$code), ]
  if (anyNA(ch$code)) {
    stop("no chart record for ", paste(codes[is.na(ch$code)], collapse = ", "))
  }
  title <- ifelse(is.na(ch$title) | ch$title == "", ch$code, ch$title)
  title <- gsub("([][*_])", "\\\\\\1", title)
  paste0(
    "*",
    title,
    "*, ",
    format_issue(ch$issue),
    " ([chart](",
    ch$image,
    "), [article](",
    ch$article,
    "))",
    collapse = "; "
  )
}
format_issue <- function(issue) format(as.Date(as.character(issue), "%Y%m%d"), "%b %Y")
# The charts a claim cites, the first `k` of them; every one was checked by eye on the review page.
cite <- function(id, medium = "print", k = 3) {
  codes <- strsplit(claim(id, medium)$cite, ";")[[1]]
  cite_codes(head(codes, k))
}
# A count from `words.csv`, as "53% (341 of 644 titles)".
word_share <- function(measure, unit = "charts", paren = TRUE) {
  r <- words[words$measure == measure, ]
  if (nrow(r) != 1) {
    stop("no words measure ", measure)
  }
  # Inside the prose's own parentheses, `paren = FALSE` gives "53%, 12 of 23 axes".
  sprintf(if (paren) "%s%% (%s of %s %s)" else "%s%%, %s of %s %s", round(100 * r$n / r$of), r$n, r$of, unit)
}
# A share by year from `years.csv`: "62% in 2012, 55% in 2013, ...".
by_year <- function(measure) {
  d <- years[years$measure == measure, ]
  paste0(round(100 * d$n / d$of), "% in ", d$year, collapse = ", ")
}

# ---- Colours --------------------------------------------------------------------------------------------------------
# The classic series colours, by name; the first of each repeated name, as economist_pal() looks them up.
fg <- ggthemes_data$economist$fg
fg <- stats::setNames(fg$value, fg$name)[!duplicated(fg$name)]
bg <- ggthemes_data$economist$bg
bg <- stats::setNames(bg$value, bg$name)
# The classic palette's inferred CMYK and the confidence in it, by color name.
classic_palette <- ggthemes_data$economist$palette
cmyk <- function(name) classic_palette$cmyk[classic_palette$name == name]
conf <- function(name) classic_palette$confidence[classic_palette$name == name]
# Economist red, for the tab and every red rule.
econ_red <- bg[["economist red"]]
ground <- bg[["blue-gray"]]

# ---- Conventions ----------------------------------------------------------------------------------------------------
lw <- function(pt) pt / (ggplot2::.pt * 0.75)

# The thin red rule at zero (or at an index value) that the charts draw over the gridlines.
classic_zero_line <- function(yintercept = 0, xintercept = NULL) {
  if (!is.null(xintercept)) {
    return(geom_vline(xintercept = xintercept, colour = econ_red, linewidth = lw(0.5)))
  }
  geom_hline(yintercept = yintercept, colour = econ_red, linewidth = lw(0.5))
}

# Years after the first labelled one are cut to two digits: 2004, 06, 08.
classic_years <- economist_2017_year_format()

# The neutral band of a forecast or other period: the ground darkened, labelled inside it in blue-gray italic capitals.
classic_band <- function(xmin, xmax, label = NULL, y = Inf, size = classic_size) {
  list(
    annotate("rect", xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = bg[["dark blue-gray"]]),
    if (!is.null(label)) {
      annotate(
        "text",
        x = (xmin + xmax) / 2,
        y = y,
        label = label,
        vjust = 1.6,
        size = size * 0.85 / .pt,
        fontface = "italic",
        colour = fg[["blue-gray"]]
      )
    }
  )
}

# A footnote at the bottom right, its last line level with the source line, which is set as the caption. Add it after
# the theme, which would otherwise reset the position of the tag.
classic_footnote <- function(text, source) {
  n <- lengths(strsplit(text, "\n", fixed = TRUE))
  list(
    labs(tag = text, caption = paste0(strrep("\n", n - 1), source)),
    theme(
      plot.tag.position = c(1, 0),
      plot.tag = element_text(
        size = rel(0.95),
        hjust = 1,
        vjust = 0,
        face = "plain",
        margin = margin(r = classic_size * 1.9)
      )
    )
  )
}

# A note under the time axis ("Years since start") is set in italics, a little below the axis labels: the theme's
# margin, which is the 2017 guide's, leaves it touching them at this size.
classic_x_title <- function() {
  theme(axis.title.x = element_text(face = "italic", margin = margin(t = classic_size * 0.4, unit = "pt")))
}
