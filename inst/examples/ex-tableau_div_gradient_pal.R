x <- seq(-1, 1, length = 100)
r <- sqrt(outer(x ^ 2, x ^ 2, "+"))
image(r,
      col = tableau_div_gradient_pal()(seq(0, 1, length = 12)))
image(r,
      col = tableau_div_gradient_pal("Orange-Blue")(seq(0, 1, length = 12)))
image(r,
      col = tableau_div_gradient_pal("Temperature")(seq(0, 1, length = 12)))
