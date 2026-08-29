library("scales")

for (i in names(ggthemes::ggthemes_data$excel$themes)) {
  show_col(excel_new_pal(theme = i)(6))
}
