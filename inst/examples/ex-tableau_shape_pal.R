# The eight shapes with a font-independent equivalent.
show_shapes(tableau_shape_pal()(8))

\dontrun{
  # All ten, drawn from the device font. Needs a font covering Geometric
  # Shapes, such as DejaVu Sans.
  show_shapes(tableau_shape_pal(unicode = TRUE)(10))
}

# Arrows, signs and pictographs have no base pch, so those palettes need
# `unicode = TRUE`. The font from `register_shapes_font()` draws the arrows at
# a common size.
if (rlang::is_installed(c("systemfonts", "ragg")) && interactive()) {
  library("ggplot2")
  family <- register_shapes_font()
  directions <- data.frame(x = 1:8, y = 1, direction = factor(1:8))
  p <- ggplot(directions, aes(x, y, shape = direction)) +
    geom_point(size = 8) +
    scale_shape_tableau("arrows", unicode = TRUE) +
    theme_void() +
    theme(legend.position = "none")
  ragg::agg_png(tempfile(fileext = ".png"), width = 640, height = 160)
  print(p, vp = grid::viewport(gp = grid::gpar(fontfamily = family)))
  dev.off()
}
