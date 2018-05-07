library("scales")

show_col(economist_pal()(6))
## fill palette
show_col(economist_pal(fill = TRUE)(6))
## RGB values from Stata's economist scheme
show_col(economist_pal(stata = TRUE)(16))
