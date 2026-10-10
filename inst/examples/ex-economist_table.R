if (requireNamespace("gt", quietly = TRUE)) {
  startups <- data.frame(
    company = c("Airbnb", "Dropbox", "Stripe", "Zenefits", "Instacart", "Docker"),
    value = c(25.5, 10, 5, 4.5, 2, 1.1),
    joined = c(2009, 2007, 2010, 2013, 2012, 2010)
  )
  tbl <- gt::gt(startups, rowname_col = "company") |>
    gt::fmt_number(value, decimals = 1) |>
    gt::cols_label(value = gt::html("Value*<br>$bn"), joined = gt::html("Date of<br>joining"))

  economist_table(
    tbl,
    title = "Greatest hits",
    subtitle = "Largest Y Combinator-funded startups",
    footnote = "*Latest funding round",
    source = "Sources: CB Insights; CrunchBase"
  )

  economist_table(
    tbl,
    title = "Greatest hits",
    subtitle = "Largest Y Combinator-funded startups",
    footnote = "*Latest funding round",
    source = "Sources: CB Insights; CrunchBase",
    style = "2017"
  )
}
