library(ggplot2)

# Base pch symbols, which every font can draw: five for data where overlap
# causes problems, and two (a solid and an open circle) for little overlap.
ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(gear))) +
  geom_point(size = 3) +
  scale_shape_cleveland(unicode = FALSE)

ggplot(mtcars, aes(x = wt, y = mpg, shape = factor(am))) +
  geom_point(size = 3) +
  scale_shape_cleveland(overlap = FALSE, unicode = FALSE)

# The default, unicode = TRUE, draws all five symbols of either set with the
# device font. The font that ships with ggthemes gives them a common size.
# Register it before building the scale, and set its family on a grid
# viewport, for devices that read fonts through the systemfonts package, such
# as ragg. `cut` has five levels, one per symbol.
if (rlang::is_installed(c("systemfonts", "ragg")) && interactive()) {
  family <- shapes_font()
  diamonds_sample <- head(diamonds, 200)
  p <- ggplot(diamonds_sample, aes(x = carat, y = price, shape = cut)) +
    geom_point(size = 3) +
    scale_shape_cleveland(overlap = FALSE)
  ragg::agg_png(tempfile(fileext = ".png"), width = 640, height = 480)
  print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
  dev.off()

  # The symbols of the revised (second) edition
  p <- ggplot(diamonds_sample, aes(x = carat, y = price, shape = cut)) +
    geom_point(size = 3) +
    scale_shape_cleveland(edition = "1994")
  ragg::agg_png(tempfile(fileext = ".png"), width = 640, height = 480)
  print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
  dev.off()
}
