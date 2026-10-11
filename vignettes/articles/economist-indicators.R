# The weekly indicator table "Economic data, 1 of 2" of 20 October 2018 (20181020_INT101), transcribed in full, and
# a builder that sets it in the indicator-table style of each era: the classic pages (2012 to 6 October 2018), the
# pages of 20 October 2018 to January 2024, and the pages from April 2024. Sourced by the three style guides, so the
# same figures appear in each.
#
# Every color is one the package already has, or a print tint of one (`indicator_tint()`), measured on the pages in
# ~/econ-chart-corpus-data/economist-tables/:
#
# * classic band: the classic blue-gray at 50% (pages: 35-55%, CIEDE2000 <= 1.0);
# * 2017 key cell: the 2017 print number box (1.6); band: the number box at 60% (0.7);
# * negative key cell, 2018 and 2024: the 2024 print salmon at 75% (0.4);
# * 2024 key cell: London 85 (1.5); row rules: London 70 (0.8); group and header rules: London 40 (0.0).

indicator_rows <- read.csv(
  text = "
country,gdp,gdp_p,gdp_q,gdp_f,cpi,cpi_p,cpi_f,unemp,unemp_p
United States,2.9,Q2,4.2,2.9,2.3,Sep,2.5,3.7,Sep
China,6.7,Q2,7.4,6.6,2.5,Sep,2.1,3.8,Q2§
Japan,1.3,Q2,3.0,1.1,1.3,Aug,0.9,2.4,Aug
Britain,1.2,Q2,1.6,1.3,2.4,Sep,2.4,4.0,Jul††
Canada,1.9,Q2,2.9,2.3,2.8,Aug,2.3,5.9,Sep
Euro area,2.2,Q2,1.8,2.1,2.1,Sep,1.7,8.1,Aug
Austria,2.3,Q2,-4.0,2.9,2.0,Sep,2.1,4.8,Aug
Belgium,1.4,Q2,1.6,1.5,2.3,Sep,2.2,6.5,Aug
France,1.7,Q2,0.6,1.7,2.2,Sep,2.1,9.3,Aug
Germany,1.9,Q2,1.8,1.9,2.3,Sep,1.8,3.4,Aug‡
Greece,1.8,Q2,0.9,2.0,1.1,Sep,0.9,19.0,Jul
Italy,1.2,Q2,0.8,1.1,1.4,Sep,1.4,9.7,Aug
Netherlands,3.1,Q2,3.3,2.8,1.9,Sep,1.7,4.7,Sep
Spain,2.7,Q2,2.3,2.7,2.3,Sep,1.8,15.2,Aug
Czech Republic,2.7,Q2,2.9,3.0,2.3,Sep,2.3,2.7,Aug‡
Denmark,1.5,Q2,1.0,1.3,0.6,Sep,1.1,3.9,Aug
Norway,3.3,Q2,1.5,1.6,3.4,Sep,2.3,4.0,Jul‡‡
Poland,5.1,Q2,4.1,4.6,1.9,Sep,1.8,5.8,Sep§
Russia,1.9,Q2,na,1.6,3.4,Sep,2.9,4.5,Sep§
Sweden,2.4,Q2,3.1,2.7,2.3,Sep,2.0,6.1,Aug§
Switzerland,3.4,Q2,2.9,2.7,1.0,Sep,1.0,2.5,Sep
Turkey,5.2,Q2,na,3.8,24.5,Sep,15.3,10.8,Jul§
Australia,3.4,Q2,3.5,3.2,2.1,Q2,2.1,5.0,Sep
Hong Kong,3.5,Q2,-0.9,3.4,2.3,Aug,2.2,2.8,Aug‡‡
India,8.2,Q2,7.8,7.4,3.8,Sep,4.6,6.4,Aug
Indonesia,5.3,Q2,na,5.2,2.9,Sep,3.4,5.1,Q1§
Malaysia,4.5,Q2,na,5.0,0.2,Aug,0.9,3.4,Aug§
Pakistan,5.4,2018**,na,5.4,5.1,Sep,5.4,5.9,2015
Philippines,6.0,Q2,5.3,6.2,6.7,Sep,5.2,5.4,Q3§
Singapore,2.6,Q3,4.7,3.5,0.7,Aug,0.6,2.1,Q2
South Korea,2.8,Q2,2.4,2.8,1.9,Sep,1.6,3.6,Sep§
Taiwan,3.3,Q2,1.6,2.6,1.7,Sep,1.7,3.7,Aug
Thailand,4.6,Q2,4.1,4.1,1.3,Sep,1.2,1.0,Aug§
Argentina,-4.2,Q2,-15.2,-2.3,40.3,Sep,33.6,9.6,Q2§
Brazil,1.0,Q2,0.7,1.5,4.5,Sep,3.8,12.1,Aug§
Chile,5.3,Q2,2.8,3.9,3.1,Sep,2.4,7.3,Aug§‡‡
Colombia,2.5,Q2,2.3,2.7,3.2,Sep,3.3,9.2,Aug§
Mexico,2.6,Q2,-0.6,2.1,5.0,Sep,4.8,3.3,Aug
Peru,5.4,Q2,12.5,4.1,1.3,Sep,1.4,6.3,Aug§
Egypt,5.4,Q2,na,5.4,16.0,Sep,17.0,9.9,Q2§
Israel,3.9,Q2,1.8,3.6,1.2,Sep,1.1,4.0,Aug
Saudi Arabia,-0.9,2017,na,1.5,2.3,Aug,2.6,6.1,Q1
South Africa,0.4,Q2,-0.7,0.7,4.9,Aug,4.8,27.2,Q2§
",
  colClasses = "character",
  strip.white = TRUE
)

# The last row of each group: the five largest economies, the euro area, the rest of Europe, Asia, Latin America,
# and the Middle East and Africa.
indicator_group_ends <- cumsum(c(5, 9, 8, 11, 6, 4))

# The page omits the dagger's note; it is the note of the classic page two weeks earlier (20181006_INT103).
indicator_source <- paste(
  "Source: Haver Analytics. *% change on previous quarter, annual rate.",
  "<sup>†</sup><i>The Economist</i> poll or Economist Intelligence Unit estimate/forecast.",
  "<sup>§</sup>Not seasonally adjusted. <sup>‡</sup>New series. **Year ending June.",
  "<sup>††</sup>Latest 3 months. <sup>‡‡</sup>3-month moving average."
)

# A print tint: `colour` screened to `f` of its strength on white paper.
indicator_tint <- function(colour, f) {
  grDevices::rgb(t(255 - (255 - grDevices::col2rgb(colour)) * f), maxColorValue = 255)
}

# Footnote marks as superscripts.
indicator_marks <- function(x) gsub("([§‡†*]+)$", "<sup>\\1</sup>", x)

indicator_colours <- function(style) {
  d <- ggthemes::ggthemes_data
  salmon <- d$economist_2024$print$qualitative
  salmon <- indicator_tint(salmon$value[salmon$name == "salmon"], 0.75)
  london <- d$economist_design_system$ramps$london
  london <- stats::setNames(london$value, london$name)
  switch(
    style,
    classic = list(
      band = indicator_tint(d$economist$bg$value[d$economist$bg$name == "blue-gray"], 0.5),
      rule = "black"
    ),
    `2017` = list(
      key = d$economist_2017$print$number_box,
      negative = salmon,
      band = indicator_tint(d$economist_2017$print$number_box, 0.6),
      rule = "black"
    ),
    `2024` = list(
      key = london[["London 85"]],
      negative = salmon,
      row_rule = london[["London 70"]],
      rule = london[["London 40"]]
    )
  )
}

# The table in the style of one era. `id` is the gt table id, which the CSS rules need.
indicator_table <- function(style = c("classic", "2017", "2024"), id = paste0("indicators-", style)) {
  style <- match.arg(style)
  x <- indicator_rows
  col <- indicator_colours(style)
  negative <- function(v) startsWith(v, "-")
  small <- function(v) sprintf('<span style="font-size:0.8em">%s</span>', indicator_marks(v))

  if (style == "classic") {
    # Signed figures, the period set small in the same cell.
    signed <- function(v) ifelse(v %in% c("na", "nil") | negative(v), v, paste0("+", v))
    x$gdp <- paste0(signed(x$gdp), "&nbsp;", small(x$gdp_p))
    x$cpi <- paste0(signed(x$cpi), "&nbsp;", small(x$cpi_p))
    x$unemp <- paste0(x$unemp, "&nbsp;", small(x$unemp_p))
    x$gdp_q <- signed(x$gdp_q)
    x$gdp_f <- signed(x$gdp_f)
    x$cpi_f <- signed(x$cpi_f)
    x[c("gdp_p", "cpi_p", "unemp_p")] <- NULL
  } else {
    # The latest figures in a box, salmon where they are negative; the period beside it, small.
    key <- function(v) {
      sprintf(
        '<span style="display:inline-block;min-width:2.6em;padding:0 3pt;text-align:right;background:%s">%s</span>',
        ifelse(negative(v), col$negative, col$key),
        v
      )
    }
    x$gdp <- key(x$gdp)
    x$cpi <- key(x$cpi)
    x$gdp_p <- small(x$gdp_p)
    x$cpi_p <- small(x$cpi_p)
    x$unemp_p <- small(x$unemp_p)
  }
  x$gdp_q <- indicator_marks(x$gdp_q)

  rows <- seq_len(nrow(x))
  inner <- setdiff(indicator_group_ends, nrow(x))
  font <- switch(
    style,
    classic = c("Helvetica", "Arial", "sans-serif"),
    list(gt::google_font("Fira Sans Condensed"), "Roboto Condensed", "Arial Narrow", "sans-serif")
  )
  rule <- function(colour, style = "solid", weight = "0.75pt", sides = "bottom") {
    gt::cell_borders(sides = sides, color = colour, weight = weight, style = style)
  }
  everywhere <- function(rows) list(gt::cells_body(rows = rows), gt::cells_stub(rows = rows))

  tbl <- gt::gt(x, rowname_col = "country", id = id) |>
    gt::fmt_passthrough(-country, escape = FALSE) |>
    gt::opt_table_font(font = font) |>
    gt::cols_align("right", -country) |>
    gt::tab_source_note(gt::html(indicator_source)) |>
    gt::tab_options(
      table.width = "420pt",
      table.font.size = "7pt",
      table.font.color = "black",
      table.background.color = "white",
      table.border.top.style = "none",
      table.border.bottom.style = "none",
      heading.align = "left",
      heading.border.bottom.style = "none",
      heading.padding = "1pt",
      column_labels.border.top.style = "none",
      column_labels.border.bottom.style = "none",
      column_labels.padding = "1pt",
      table_body.border.top.style = "none",
      table_body.border.bottom.style = "none",
      table_body.hlines.style = "none",
      stub.border.style = "none",
      data_row.padding = "1.5pt",
      source_notes.font.size = "6pt",
      source_notes.padding = "2pt"
    )

  if (style == "classic") {
    title <- "Output, prices and jobs"
    tbl |>
      gt::tab_header(
        gt::html(sprintf('<div style="font-weight:bold;font-size:9.5pt">%s</div>', title)),
        gt::html('<div style="font-size:7.5pt">% change on year ago</div>')
      ) |>
      gt::tab_spanner("Gross domestic product", c(gdp, gdp_q, gdp_f)) |>
      gt::tab_spanner("Consumer prices", c(cpi, cpi_f)) |>
      gt::cols_label(
        gdp = "latest",
        gdp_q = "qtr*",
        gdp_f = gt::html("2018<sup>†</sup>"),
        cpi = "latest",
        cpi_f = gt::html("2018<sup>†</sup>"),
        unemp = gt::html("<b>Unemployment<br>rate, %</b>")
      ) |>
      gt::tab_style(gt::cell_text(weight = "bold", align = "center"), gt::cells_column_spanners()) |>
      gt::tab_style(gt::cell_text(align = "center"), gt::cells_column_labels()) |>
      gt::tab_style(gt::cell_text(weight = "bold"), gt::cells_stub()) |>
      gt::tab_style(gt::cell_fill(color = col$band), everywhere(rows[rows %% 2 == 1])) |>
      gt::tab_style(rule(col$rule, "dashed"), everywhere(inner)) |>
      # Each group's name over a thin black rule: gt draws it on the spanner's inner element.
      gt::opt_css(sprintf("#%s .gt_column_spanner { border-bottom: 0.5pt solid black !important; }", id))
  } else {
    unit <- function(name, unit) {
      gt::html(sprintf('<b style="font-size:1.15em">%s</b><br><span style="font-weight:300">%s</span>', name, unit))
    }
    light <- function(v) gt::html(sprintf('<span style="font-weight:300">%s</span>', v))
    groups <- list(c("gdp", "gdp_p", "gdp_q", "gdp_f"), c("cpi", "cpi_p", "cpi_f"), c("unemp", "unemp_p"))
    tbl <- tbl |>
      gt::tab_header(
        gt::html('<div style="font-weight:bold;font-size:11pt">Economic data</div>'),
        gt::html('<div style="font-size:8pt">1 of 2</div>')
      ) |>
      gt::tab_spanner(unit("Gross domestic product", "% change on year ago:"), groups[[1]], id = "group-gdp") |>
      gt::tab_spanner(unit("Consumer prices", "% change on year ago:"), groups[[2]], id = "group-cpi") |>
      gt::tab_spanner(unit("Unemployment", "rate"), groups[[3]], id = "group-unemp") |>
      gt::cols_label(
        gdp = light("latest"),
        gdp_p = "",
        gdp_q = light("quarter*"),
        gdp_f = light("2018<sup>†</sup>"),
        cpi = light("latest"),
        cpi_p = "",
        cpi_f = light("2018<sup>†</sup>"),
        unemp = light("%"),
        unemp_p = ""
      ) |>
      gt::cols_align("left", c(gdp_p, cpi_p, unemp_p)) |>
      gt::tab_style(gt::cell_text(align = "left"), list(gt::cells_column_spanners(), gt::cells_column_labels())) |>
      gt::tab_style(gt::cell_text(weight = 300), list(gt::cells_body(), gt::cells_stub())) |>
      # A vertical rule down the left of each column group's heads, ending at the rule under them.
      gt::tab_style(
        rule(col$rule, sides = "left", weight = "1pt"),
        list(gt::cells_column_spanners(c("group-gdp", "group-cpi", "group-unemp")), gt::cells_column_labels(c(gdp, cpi, unemp)))
      ) |>
      gt::tab_style(rule(col$rule), list(gt::cells_column_labels(), gt::cells_stubhead())) |>
      gt::tab_style(rule(col$rule), everywhere(indicator_group_ends)) |>
      gt::opt_css(sprintf(
        "#%s .gt_column_spanner { border-bottom-style: none !important; text-align: left; padding-left: 3pt; }",
        id
      ))
    if (style == "2017") {
      tbl <- gt::tab_style(tbl, gt::cell_fill(color = col$band), everywhere(rows[rows %% 2 == 1]))
    } else {
      tbl <- gt::tab_style(tbl, rule(col$row_rule, weight = "0.5pt"), everywhere(setdiff(rows, indicator_group_ends)))
    }
    tbl
  }
}
