# The seven shapes with a font-independent equivalent.
show_shapes(calc_shape_pal()(7))

\dontrun{
  # All thirteen, drawn from the device font. Needs a font covering Geometric
  # Shapes, Dingbats and Miscellaneous Mathematical Symbols-B, such as
  # Noto Sans Symbols 2.
  show_shapes(calc_shape_pal(unicode = TRUE)(13))
}
