library("scales")

# Stata 18 and later (the current factory default)
show_col(stata_pal("stcolor")(15))

# Stata 17 and earlier
show_col(stata_pal("s2color")(15))
show_col(stata_pal("s1rcolor")(15))
show_col(stata_pal("s1color")(15))
show_col(stata_pal("mono")(15))
