# Shared setup of "The Wall Street Journal chart style, 2010-2014" (wsj-styleguide.Rmd). Sourced from the article's
# setup chunk; nothing here is exported.

library(ggthemes)
library(ggplot2)

# ---- The evidence ---------------------------------------------------------------------------------------------------
# One row per chart: what the readings of each image recorded and what the pixel measurements found
# (`guide/export.py` of the WSJ graphics corpus writes these files). Every chart was measured. The Asia-desk charts
# were all read, twice; the US-desk charts were read once, in a stratified sample, and `read` marks the charts with a
# reading.
# `inks.csv` counts the charts in each period and on each desk that use each measured color.
# "NA" is a desk, the U.S. news pages, so it must not be read as missing; empty numbers still are.
charts <- read.csv("wsj-2010-2014/charts.csv", stringsAsFactors = FALSE, na.strings = character(0))
inks <- read.csv("wsj-2010-2014/inks.csv", stringsAsFactors = FALSE)
# Shares of what the readings recorded are of the charts read. They pool the two desks only where the desks agree;
# the Asia desks have 388 charts read against 405 of 1,883 for the US desks, so a pooled share leans toward Asia.
read <- charts[charts$read == "True", ]
asia <- charts[charts$desks == "Asia", ]
us_read <- read[read$desks == "US", ]
# The number callouts of the charts that have them, read from the images.
callouts <- read.csv("wsj-2010-2014/callouts.csv", stringsAsFactors = FALSE)
# The color of each directly labeled series' label against its line, by hue, in the charts whose labels are colored
# text (`guide/label_colors.py` of the corpus): the mean of the darkest third of the glyph pixels and of the line
# pixels.
label_colors <- read.csv("wsj-2010-2014/label-colors.csv", stringsAsFactors = FALSE)
label_colors$desks <- charts$desks[match(label_colors$file, charts$file)]
stopifnot(!anyNA(label_colors$desks))
# The alignment of the y labels of 48 charts, 16 from each of periods B to D, read by eye at three times the size.
ylabel_check <- read.csv("wsj-2010-2014/ylabel-check.csv", stringsAsFactors = FALSE)
# The hue family of each measured color, to tell shades of one hue from different hues.
ink_family <- c(
  red = "red",
  salmon = "red",
  `pale red` = "red",
  navy = "blue",
  blue = "blue",
  steel = "blue",
  `pale steel` = "blue",
  `dark green` = "green",
  green = "green",
  `pale green` = "green",
  orange = "orange",
  `light orange` = "orange",
  gold = "gold",
  tan = "gold",
  `pale gold` = "gold",
  yellow = "yellow",
  black = "black",
  `bright red` = "red",
  `pale bright red` = "red",
  `royal blue` = "blue",
  `pale royal blue` = "blue",
  `bright green` = "green",
  `pale bright green` = "green",
  `bright yellow` = "yellow"
)

periods <- data.frame(
  period = c("A", "B", "C", "D"),
  dates = c("Nov 2010 to Sep 2011", "Oct 2011 to Jun 2012", "Jul 2012 to Jul 2013", "Aug 2013 to Jul 2014")
)

has <- function(x, value) vapply(strsplit(x, ";"), function(v) value %in% v, logical(1))

# "62%, 140 of 226 charts": no parentheses of its own, so it reads inside the prose's parentheses too.
share <- function(n, of, unit = "charts") {
  n <- sum(n)
  of <- sum(of)
  trimws(sprintf("%s%%, %s of %s %s", round(100 * n / of), n, of, unit))
}
pct <- function(n, of) paste0(round(100 * sum(n) / sum(of)), "%")
# A share on each desk, Asia first: share(n, of) of the rows of `d` for which `cond` and `denom` hold, both evaluated
# within `d`, as "62%, 140 of 226 charts on the Asia desks and 40%, 30 of 75 on the U.S. desks". `d` says whether the
# counts are of all charts or of the charts read.
by_desk <- function(d, cond, denom = TRUE, unit = "charts") {
  cond <- eval(substitute(cond), d, parent.frame())
  denom <- eval(substitute(denom), d, parent.frame())
  denom <- rep_len(denom, nrow(d))
  # A missing value would print as "NA%" without failing the knit.
  stopifnot(!anyNA(cond), !anyNA(denom))
  a <- d$desks == "Asia"
  sprintf(
    "%s on the Asia desks and %s on the U.S. desks",
    share(cond[a] & denom[a], denom[a], unit),
    share(cond[!a] & denom[!a], denom[!a], unit = "")
  )
}

# Links to charts by file name: the title links to the archived image. Every chart cited was checked by eye. Only read
# charts have a title on record, so only they can be cited.
cite <- function(files) {
  ch <- read[match(files, read$file), ]
  if (anyNA(ch$file)) {
    stop("no reading of ", paste(files[is.na(ch$file)], collapse = ", "))
  }
  title <- gsub("([][*_])", "\\\\\\1", ch$title)
  paste0("[*", title, "*](", ch$image, "), ", format(as.Date(ch$date), "%b %Y"), collapse = "; ")
}

# ---- Many series ----------------------------------------------------------------------------------------------------
# Charts of three or more series, after period A and leaving out gains-and-losses charts. Lines are too thin for the
# ink measurements, so their colors are the readings'; bars and pies use the measured inks.
has_colour <- function(d, colour) has(d$series_colors, colour)
# Charts read with one series, from the redesign on: period A drew with its own bright set.
single <- read[lengths(strsplit(read$series_colors, ";")) == 1 & read$period != "A", ]
many <- read[lengths(strsplit(read$series_colors, ";")) >= 3 & read$period != "A" & read$direction_colors == "False", ]
many_lines <- many[many$chart_types == "line", ]
many_parts <- many[many$chart_types != "line", ]
many_parts$shades <- vapply(strsplit(many_parts$inks, ";"), function(k) any(table(ink_family[k]) >= 2), logical(1))

# ---- Annotations ----------------------------------------------------------------------------------------------------
# Charts with each kind of annotation besides the boxed callouts: found from the readings' arrow and circle-marker
# flags and checked by eye. The lists may be short, never wrong.
annotated <- list(
  pointer = c(
    "AI-CD056_CECON_NS_20130822054204.jpg",
    "AI-CE711_ECB_NS_20131107110005.jpg",
    "AM-BB245_AMONEY_NS_20131127131503.jpg",
    "AM-BB519B_AMONE_NS_20131218001802.jpg",
    "AI-CG163_NZECON_NS_20140120211805.jpg",
    "AM-BB971_RBIHER_NS_20140122081805.jpg",
    "AI-CG344_INDIAR_NS_20140128030303.jpg",
    "AI-CI384_HKPROP_NS_20140506123603.jpg",
    "AI-CJ432_JOKOWI_NS_20140629125103.jpg"
  ),
  ring = c(
    "AI-BU430_CECON_NS_20120723233003.jpg",
    "AI-BV139_CECON_NS_20120823021803.jpg",
    "AI-BV767_CECON_NS_20120919230902.jpg",
    "AM-BA790_CPROP_NS_20131022111803.jpg",
    "AM-BB585_CHINAH_NS_20131223060011.jpg",
    "AM-BB971_RBIHER_NS_20140122081805.jpg",
    "AI-CH003_YUAN_NS_20140228034204.jpg"
  ),
  arrow = c(
    "AI-BP200_CYUAN_NS_20111205110603.jpg",
    "AM-AQ466_CHINAH_NS_20111205061205.jpg",
    "AI-BS604_BOJ_ch_NS_20120503050603.jpg"
  ),
  event = c(
    "AI-BY854_CECON_NS_20130201025705.jpg",
    "AI-CB163_JSTOCK_NS_20130523041204.jpg",
    "AI-CJ432_JOKOWI_NS_20140629125103.jpg"
  )
)

# The small black wedge of a pointer label: a triangle with its tip at (x, y), pointing "up", "down", "left" or
# "right", `w` wide in x units and `h` tall in y units.
wedge <- function(x, y, dir = "down", w, h) {
  px <- switch(dir, up = , down = c(x, x - w / 2, x + w / 2), right = c(x, x - w, x - w), left = c(x, x + w, x + w))
  py <- switch(dir, up = c(y, y - h, y - h), down = c(y, y + h, y + h), right = , left = c(y, y - h / 2, y + h / 2))
  annotate("polygon", x = px, y = py, fill = "#000000")
}

# ---- Tints ----------------------------------------------------------------------------------------------------------
# A tint mixes a color toward white in RGB, as an Illustrator tint or an opacity over white does:
# target = 255 - t * (255 - base). tint_of() fits t by least squares and reports the worst channel's miss, in levels.
tint_of <- function(base, target) {
  b <- grDevices::col2rgb(base)[, 1]
  x <- grDevices::col2rgb(target)[, 1]
  t <- sum((255 - x) * (255 - b)) / sum((255 - b)^2)
  c(t = t, miss = max(abs(255 - t * (255 - b) - x)))
}

# ---- Drawing --------------------------------------------------------------------------------------------------------
# The figures are drawn at about the size of the native web graphics, which were 225 pixels wide, scaled up.
wsj_col <- function(name) {
  inks$hex[inks$ink == name]
}
wsj_caption <- function(source) paste0("Source: ", source, "\nThe Wall Street Journal")
# Illustrative data: a random walk with drift, monthly.
walk <- function(n, start, sd, drift = 0, from = "2011-01-01") {
  data.frame(
    date = seq(as.Date(from), by = "month", length.out = n),
    value = start + cumsum(stats::rnorm(n, drift, sd))
  )
}

# ---- Fonts ----------------------------------------------------------------------------------------------------------
# The charts set titles in a heavy Ionic slab serif and everything else in a narrow sans; the Journal's house faces
# were Exchange (an Ionic) and Retina (a narrow sans), both commercial. Bitter, heavy weight, and Source Sans 3 are
# the nearest free matches on Google Fonts. systemfonts fetches them when they are not installed, and the figures
# fall back to the generic families when it cannot (offline, or an older systemfonts).
use_font <- function(family, variant = NULL, weight = "normal", fallback) {
  ok <- tryCatch(
    isTRUE(systemfonts::require_font(family, fallback = fallback, verbose = FALSE)) ||
      family %in% systemfonts::system_fonts()$family,
    error = function(e) FALSE
  )
  if (!ok) {
    return(fallback)
  }
  if (is.null(variant)) {
    return(family)
  }
  systemfonts::register_variant(variant, family, weight = weight)
  variant
}
wsj_title_font <- use_font("Bitter", "Bitter Heavy", weight = "heavy", fallback = "serif")
wsj_text_font <- use_font("Source Sans 3", fallback = "sans")
wsj_text_semibold <- if (wsj_text_font == "sans") {
  "sans"
} else {
  use_font("Source Sans 3", "Source Sans 3 Semibold", weight = "semibold", fallback = "sans")
}

# ---- Fields ---------------------------------------------------------------------------------------------------------
# The median field color of each kind of chart, measured on the corpus: the `paper` values of theme_wsj().
fields <- ggthemes::ggthemes_data$wsj$paper
field_name <- function(paper) sub("_", " ", paper)
on_field <- function(paper, ...) {
  theme_wsj(..., paper = paper, base_family = wsj_text_font, title_family = wsj_title_font)
}

# ---- The four periods -----------------------------------------------------------------------------------------------
# The bold subtitles of periods A and B: the semibold face where it could be fetched, the generic bold otherwise.
subtitle_face_ab <- if (wsj_text_semibold == "sans") "bold" else "plain"
# theme_wsj() with the overrides that turn it into each period's look; the bands are a layer, added by period_plot().
period_theme <- function(period, base_size = 11) {
  thm <- switch(
    period,
    ## White or pale blue field, sans titles over bold subtitles, blue bands.
    A = theme_wsj(
      base_size,
      paper = "pale_blue",
      base_family = wsj_text_font,
      title_family = wsj_text_semibold,
      subtitle_face = subtitle_face_ab,
      rules = "none"
    ) +
      theme(plot.title = element_text(face = "plain"), plot.subtitle = element_text(family = wsj_text_semibold)),
    ## Ivory, slab title, bold subtitle, bands.
    B = theme_wsj(
      base_size,
      base_family = wsj_text_font,
      title_family = wsj_title_font,
      subtitle_face = subtitle_face_ab,
      rules = "none"
    ) +
      theme(plot.subtitle = element_text(family = wsj_text_semibold)),
    ## Ivory, regular subtitle, dotted rules.
    C = theme_wsj(base_size, base_family = wsj_text_font, title_family = wsj_title_font),
    ## Gray.
    D = theme_wsj(base_size, paper = "gray", base_family = wsj_text_font, title_family = wsj_title_font)
  )
  thm + theme(axis.text.x = element_text(hjust = 0))
}
period_plot <- function(p, period) {
  if (period %in% c("A", "B")) {
    paper <- if (period == "A") "pale_blue" else "ivory"
    p$layers <- c(wsj_bands(paper), p$layers)
  }
  p + period_theme(period)
}

# Draws ggplots side by side in one figure.
side_by_side <- function(plots) {
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(1, length(plots))))
  for (i in seq_along(plots)) {
    print(plots[[i]], vp = grid::viewport(layout.pos.row = 1, layout.pos.col = i))
  }
  invisible()
}
