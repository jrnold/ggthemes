library("ggplot2")

if (requireNamespace("maps", quietly = TRUE) && requireNamespace("mapproj", quietly = TRUE)) {
  us <- map_data("state")
  gg <- ggplot(us, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", color = "black", linewidth = 0.25) +
    coord_map("albers", lat0 = 39, lat1 = 45) +
    theme_map()
  gg
}
