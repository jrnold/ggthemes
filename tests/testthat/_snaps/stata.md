# stata_pal works

    Code
      x <- stata_pal("s2color")(100)
    Condition
      Warning:
      This manual palette can handle a maximum of 15 values. You have supplied 100

# theme_state raises error with invallid scheme

    Code
      theme_stata(scheme = "dsagasagdadgaga")
    Condition
      Error in `theme_stata_colors()`:
      ! `scheme` must be one of "s1color", "s1manual", "s1mono", "s1rcolor", "s2color", "s2manual", "s2mono", "sj", "stcolor", "stcolor_alt", "stmono1", "stmono2", and "stsj", not "dsagasagdadgaga".

# stata_shape_pal works

    Code
      x <- p(100)
    Condition
      Warning:
      This palette can handle a maximum of 10 values. You have supplied 100.

