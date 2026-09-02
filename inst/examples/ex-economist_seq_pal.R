library("scales")

# the six steps of one hue, darkest first
show_col(economist_seq_pal("blue")(6))
show_col(economist_seq_pal("red")(6))

# interpolated for continuous data
show_col(economist_gradient_pal("green")(seq(0, 1, length.out = 10)))
