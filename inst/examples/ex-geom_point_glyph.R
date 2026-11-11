library(ggplot2)

# geom_point_glyph() reads the font with the systemfonts package.
if (rlang::is_installed("systemfonts")) {
  # The five symbols of Cleveland's set for little overlap, drawn from the
  # shapes font at a common size. `cut` has five levels, one per symbol.
  diamonds_sample <- head(diamonds, 200)
  ggplot(diamonds_sample, aes(x = carat, y = price, shape = cut)) +
    geom_point_glyph(size = 3) +
    scale_shape_cleveland(overlap = FALSE, unicode = TRUE)

  # Arrows have no base pch, so they need `unicode = TRUE`.
  directions <- data.frame(x = 1:8, y = 1, direction = factor(1:8))
  ggplot(directions, aes(x, y, shape = direction)) +
    geom_point_glyph(size = 8) +
    scale_shape_tableau("arrows", unicode = TRUE) +
    theme_void() +
    theme(legend.position = "none")
}
