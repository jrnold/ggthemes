# Shared setup of "The Wall Street Journal chart style, 2010-2014" (wsj-styleguide.Rmd). Sourced from the article's
# setup chunk; nothing here is exported.

library(ggthemes)
library(ggplot2)

# ---- The evidence ---------------------------------------------------------------------------------------------------
# One row per chart: what two readings of each image recorded and what the pixel measurements found
# (data-raw/wsj-corpus/export.py writes these files). `inks.csv` counts the charts in each period that use each
# measured color.
charts <- read.csv("wsj-2010-2014/charts.csv", stringsAsFactors = FALSE)
inks <- read.csv("wsj-2010-2014/inks.csv", stringsAsFactors = FALSE)
# The number callouts of the charts that have them, read from the images.
callouts <- read.csv("wsj-2010-2014/callouts.csv", stringsAsFactors = FALSE)
# The color of each directly labeled series' label against its line, by hue, in the charts whose labels are colored
# text (data-raw/wsj-corpus/label_colors.py): the mean of the darkest third of the glyph pixels and of the line pixels.
label_colors <- read.csv("wsj-2010-2014/label-colors.csv", stringsAsFactors = FALSE)
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
  black = "black"
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
  sprintf("%s%%, %s of %s %s", round(100 * n / of), n, of, unit)
}
pct <- function(n, of) paste0(round(100 * sum(n) / sum(of)), "%")

# Links to charts by file name: the title links to the archived image. Every chart cited was checked by eye.
cite <- function(files) {
  ch <- charts[match(files, charts$file), ]
  if (anyNA(ch$file)) {
    stop("no chart record for ", paste(files[is.na(ch$file)], collapse = ", "))
  }
  title <- gsub("([][*_])", "\\\\\\1", ch$title)
  paste0("[*", title, "*](", ch$image, "), ", format(as.Date(ch$date), "%b %Y"), collapse = "; ")
}

# ---- Many series ----------------------------------------------------------------------------------------------------
# Charts of three or more series, after period A and leaving out gains-and-losses charts. Lines are too thin for the
# ink measurements, so their colors are the readings'; bars and pies use the measured inks.
has_colour <- function(d, colour) has(d$series_colors, colour)
many <- charts[
  lengths(strsplit(charts$series_colors, ";")) >= 3 & charts$period != "A" & charts$direction_colors == "False",
]
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
# The median field color of each kind of chart, measured on the corpus. theme_wsj() offers the first two; on_field()
# puts a theme_wsj() chart on any of them.
fields <- c(ivory = "#f8f2e4", gray = "#efefef", `pale blue` = "#eff4f9", `pale green` = "#f2f9f2", white = "#ffffff")
on_field <- function(field, ...) {
  theme_wsj(..., base_family = wsj_text_font, title_family = wsj_title_font) +
    theme(
      plot.background = element_rect(fill = field, colour = NA),
      panel.background = element_rect(fill = field, colour = NA),
      legend.background = element_rect(fill = field, colour = NA),
      legend.key = element_rect(fill = field, colour = NA),
      strip.background = element_rect(fill = field, colour = NA)
    )
}

# ---- The four periods -----------------------------------------------------------------------------------------------
# theme_wsj() with the overrides that turn it into each period's look; the bands are a layer, added by period_plot().
period_theme <- function(period, base_size = 11) {
  thm <- switch(
    period,
    ## White or pale blue field, sans titles over bold subtitles, blue bands.
    A = theme_wsj(base_size, base_family = wsj_text_font, title_family = wsj_text_semibold) +
      theme(
        plot.background = element_rect(fill = fields[["pale blue"]], colour = NA),
        panel.background = element_rect(fill = fields[["pale blue"]], colour = NA),
        plot.title = element_text(face = "plain"),
        plot.subtitle = element_text(family = wsj_text_semibold),
        panel.grid.major.y = element_blank()
      ),
    ## Ivory, slab title, bold subtitle, bands.
    B = theme_wsj(base_size, base_family = wsj_text_font, title_family = wsj_title_font) +
      theme(plot.subtitle = element_text(family = wsj_text_semibold), panel.grid.major.y = element_blank()),
    ## Ivory, regular subtitle, dotted rules.
    C = theme_wsj(base_size, base_family = wsj_text_font, title_family = wsj_title_font),
    ## Gray.
    D = theme_wsj(base_size, paper = "gray", base_family = wsj_text_font, title_family = wsj_title_font)
  )
  thm + theme(axis.text.x = element_text(hjust = 0))
}
period_plot <- function(p, period) {
  if (period %in% c("A", "B")) {
    fill <- if (period == "A") "#d7e4ee" else NULL
    p$layers <- c(wsj_bands(fill = fill), p$layers)
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
