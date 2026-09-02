# tableau_color_pal raises error with invalid palette

    Code
      tableau_color_pal("dsaga")
    Condition
      Error in `tableau_color_pal()`:
      ! `palette` must be one of "Tableau 10", "Tableau 20", "Color Blind", "Seattle Grays", "Traffic", "Miller Stone", "Superfishel Stone", "Nuriel Stone", "Jewel Bright", "Summer", "Winter", "Green-Orange-Teal", "Blue-Red-Brown", "Purple-Pink-Gray", "Hue Circle", "Classic 10", "Classic 10 Medium", "Classic 10 Light", ..., "Classic Blue-Red 12", and "Classic Cyclic", not "dsaga".

# tableau_shape_pal raises error with bad palette

    Code
      tableau_shape_pal(palette = "gender")
    Condition
      Error in `tableau_shape_pal()`:
      ! `palette` must be one of "default", "filled", or "proportions", not "gender".

# tableau_color_pal accepts a deprecated palette name with a warning

    Code
      pal <- tableau_color_pal("Red-Blue-Brown")
    Condition
      Warning:
      Tableau palette "Red-Blue-Brown" is deprecated; use "Blue-Red-Brown" instead.

# tableau_gradient_pal accepts a deprecated palette name with a warning

    Code
      pal <- tableau_gradient_pal("Classic Area-Brown", type = "ordered-sequential")
    Condition
      Warning:
      Tableau palette "Classic Area-Brown" is deprecated; use "Classic Area Brown" instead.

