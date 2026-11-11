skip_if_not_installed("gt")
skip_if_not_installed("htmltools")

table_data <- data.frame(
  company = c("Airbnb", "Dropbox", "Stripe"),
  value = c(25.5, 10, 5),
  joined = c(2009, 2007, 2010)
)
stub_table <- function(id = NULL) gt::gt(table_data, rowname_col = "company", id = id)
html_of <- function(x) gt::as_raw_html(x, inline_css = TRUE)

# gt_theme_economist() ------------------------------------------------------

test_that("gt_theme_economist returns a gt table and checks its argument", {
  expect_s3_class(gt_theme_economist(stub_table()), "gt_tbl")
  expect_error(gt_theme_economist(table_data), "gt table")
})

test_that("gt_theme_economist sets the classic ground, dotted row rules and bold row headers", {
  html <- html_of(gt_theme_economist(stub_table()))
  expect_match(html, "#cbdde6", ignore.case = TRUE)
  expect_match(html, "border-top-style: dotted")
  # The stub cells are bold.
  stub <- regmatches(html, regexpr('<th[^>]*class="gt_row gt_left gt_stub"[^>]*>', html))
  expect_match(stub, "font-weight: bold")
})

test_that("gt_theme_economist scopes its finer CSS to the table id, when there is one", {
  scoped <- gt::as_raw_html(gt_theme_economist(stub_table(id = "hits")), inline_css = FALSE)
  expect_match(scoped, "#hits .gt_row, #hits .gt_stub", fixed = TRUE)
  # With the CSS inlined, the rules land on the cells.
  expect_match(html_of(gt_theme_economist(stub_table(id = "hits"))), "line-height: 8.5pt", fixed = TRUE)
  expect_no_match(
    gt::as_raw_html(gt_theme_economist(stub_table()), inline_css = FALSE),
    ".gt_row, #hits .gt_stub",
    fixed = TRUE
  )
})

# gt_theme_economist_2017() -------------------------------------------------

test_that("gt_theme_economist_2017 uses the print or web ground and stripes the rows", {
  pal <- ggthemes_data$economist_2017
  print_html <- html_of(gt_theme_economist_2017(stub_table()))
  expect_match(print_html, pal$print$ground, ignore.case = TRUE)
  expect_match(print_html, pal$print$highlight, ignore.case = TRUE)
  expect_no_match(
    html_of(gt_theme_economist_2017(stub_table(), stripe = FALSE)),
    pal$print$highlight,
    ignore.case = TRUE
  )
  expect_match(html_of(gt_theme_economist_2017(stub_table(), media = "web")), pal$web$box, ignore.case = TRUE)
  expect_error(gt_theme_economist_2017(stub_table(), media = "tv"))
})

# economist_table() ---------------------------------------------------------

test_that("economist_table frames the table with the tab, title, footnote and source", {
  out <- economist_table(
    stub_table(),
    title = "Greatest hits",
    subtitle = "Largest startups",
    footnote = "*Latest round",
    source = "Source: CB Insights"
  )
  expect_s3_class(out, "html")
  html <- as.character(out)
  expect_match(html, "Greatest hits", fixed = TRUE)
  expect_match(html, "*Latest round", fixed = TRUE)
  expect_match(html, "Source: CB Insights", fixed = TRUE)
  # The classic tab stands upright, 5pt by 15pt, in Economist red.
  expect_match(html, "width:5pt;height:15pt;background:#e3120b", fixed = TRUE)
  expect_match(economist_table(stub_table(), style = "2017"), "width:15pt;height:5pt", fixed = TRUE)
})

test_that("economist_table escapes text, keeps line breaks and passes HTML through", {
  html <- as.character(economist_table(stub_table(), title = "A & B\nC", subtitle = htmltools::HTML("<i>x</i>")))
  expect_match(html, "A &amp; B<br>C", fixed = TRUE)
  expect_match(html, "<i>x</i>", fixed = TRUE)
})

test_that("economist_table leaves the random-number state alone and scopes its CSS the same each time", {
  withr::local_seed(1)
  before <- .Random.seed
  first <- as.character(economist_table(stub_table(), title = "Hits"))
  expect_identical(.Random.seed, before)
  scope <- function(html) regmatches(html, regexpr("ggthemes-economist-table-[0-9a-f]+", html))
  expect_identical(scope(first), scope(as.character(economist_table(stub_table(), title = "Hits"))))
  # Every selector of the frame's CSS is scoped to the frame.
  css <- sub(".*<style>(.*)</style>.*", "\\1", first)
  selectors <- unlist(strsplit(gsub("\\{[^}]*\\}", ",", css), ","))
  selectors <- trimws(selectors[nzchar(trimws(selectors))])
  expect_true(all(startsWith(selectors, paste0("#", scope(first)))))
})
