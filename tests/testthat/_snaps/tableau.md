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
      The Tableau palette name "Red-Blue-Brown" was deprecated in ggthemes 7.0.0.
      i Please use the name "Blue-Red-Brown" instead.

# tableau_gradient_pal accepts a deprecated palette name with a warning

    Code
      pal <- tableau_gradient_pal("Classic Area-Brown", type = "ordered-sequential")
    Condition
      Warning:
      The Tableau palette name "Classic Area-Brown" was deprecated in ggthemes 7.0.0.
      i Please use the name "Classic Area Brown" instead.

# tableau_gradient_pal() rejects an unknown palette

    Code
      tableau_gradient_pal("Chartreuse")
    Condition
      Error in `tableau_gradient_pal()`:
      ! `palette` must be one of "Blue-Green Sequential", "Blue Light", "Orange Light", "Blue", "Orange", "Green", "Red", "Purple", "Brown", "Gray", "Gray Warm", "Blue-Teal", "Orange-Gold", "Green-Gold", "Red-Gold", "Classic Green", "Classic Gray", "Classic Blue", ..., "Classic Area Green", and "Classic Area Brown", not "Chartreuse".

---

    Code
      tableau_seq_gradient_pal("Chartreuse")
    Condition
      Error in `tableau_gradient_pal()`:
      ! `palette` must be one of "Blue-Green Sequential", "Blue Light", "Orange Light", "Blue", "Orange", "Green", "Red", "Purple", "Brown", "Gray", "Gray Warm", "Blue-Teal", "Orange-Gold", "Green-Gold", "Red-Gold", "Classic Green", "Classic Gray", "Classic Blue", ..., "Classic Area Green", and "Classic Area Brown", not "Chartreuse".

# tableau gradient palette helpers reject extra arguments

    Code
      tableau_seq_gradient_pal("Blue", extra = 1)
    Condition
      Error in `tableau_seq_gradient_pal()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = 1

---

    Code
      tableau_div_gradient_pal(extra = 1)
    Condition
      Error in `tableau_div_gradient_pal()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = 1

# scale_colour_tableau() takes type and direction by name only

    Code
      scale_colour_tableau("Tableau 20", "regular")
    Condition
      Error in `scale_colour_tableau()`:
      ! Arguments in `...` must be named.
      x Unnamed argument in position 1.

---

    Code
      scale_fill_tableau("Tableau 20", "regular")
    Condition
      Error in `scale_fill_tableau()`:
      ! Arguments in `...` must be named.
      x Unnamed argument in position 1.

