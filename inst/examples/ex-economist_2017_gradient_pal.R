library("scales")

show_col(economist_2017_gradient_pal("blue")(seq(0, 1, length.out = 6)))
show_col(economist_2017_gradient_pal("red", direction = -1)(seq(0, 1, length.out = 6)))
