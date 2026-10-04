library("scales")

## Print: the side-by-side bar order, the guide's default
show_col(economist_2017_pal()(6))

## Print, ordered for a line chart
show_col(economist_2017_pal(type = "line_side")(6))

## Print, the high-contrast supporting sets
show_col(economist_2017_pal(set = "bright")(4))
show_col(economist_2017_pal(set = "dark")(3))

## Web: nine colours
show_col(economist_2017_pal("web")(9))
