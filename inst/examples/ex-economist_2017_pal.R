library("scales")

## The side-by-side bar order, the guide's default
show_col(economist_2017_pal()(6))

## Ordered for a line chart
show_col(economist_2017_pal(type = "line_side")(6))

## The high-contrast supporting sets
show_col(economist_2017_pal(set = "bright")(4))
show_col(economist_2017_pal(set = "dark")(3))

## Web charts use the same palettes
identical(economist_2017_pal("web")(6), economist_2017_pal("print")(6))
