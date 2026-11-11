if (requireNamespace("gt", quietly = TRUE)) {
  startups <- data.frame(
    company = c("Airbnb", "Dropbox", "Stripe", "Zenefits", "Instacart", "Docker"),
    value = c(25.5, 10, 5, 4.5, 2, 1.1),
    joined = c(2009, 2007, 2010, 2013, 2012, 2010)
  )
  tbl <- gt::gt(startups, rowname_col = "company", id = "startups") |>
    gt::cols_label(value = "Value, $bn", joined = "Date of joining")

  # The classic print table: dotted rules between the rows, bold row headers
  gt_theme_economist(tbl)

  # The 2017 print table: every second row filled
  gt_theme_economist_2017(tbl)
}
