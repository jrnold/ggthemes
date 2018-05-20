library("maps")
library("ggplot2")

us <- fortify(map_data("state"), region = "region")
gg <- ggplot() +
  geom_map(data  =  us, map = us,
             aes(x = long, y = lat, map_id = region, group = group),
             fill = "white", color = "black", size = 0.25) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  theme_map()
gg
