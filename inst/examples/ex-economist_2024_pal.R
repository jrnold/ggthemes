library("scales")
show_col(economist_2024_pal("print")(6))
show_col(economist_2024_pal("web")(6))
# One color is the brighter red of single-series charts
economist_2024_pal("web")(1)
