# The eight shapes with a font-independent equivalent.
show_shapes(tableau_shape_pal()(8))

\dontrun{
  # All ten, drawn from the device font. Needs a font covering Geometric
  # Shapes, such as DejaVu Sans.
  show_shapes(tableau_shape_pal(unicode = TRUE)(10))
}
