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
# A count from `words.csv`, as "53%, 341 of 644 titles".
word_share <- function(measure, unit = "charts") {
  r <- words[words$measure == measure, ]
  if (nrow(r) != 1) stop("no words measure ", measure)
  sprintf("%s%%, %s of %s %s", round(100 * r$n / r$of), r$n, r$of, unit)
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
        size = rel(0.95), hjust = 1, vjust = 0, face = "plain",
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
