library("scales")

for (i in names(ggthemes::ggthemes_data$excel$palettes)) {
  show_col(excel_pal(theme = i))(6)
}
