x <- seq(-1, 1, length = 100)
r <- sqrt(outer(x ^ 2, x ^ 2, "+"))

palettes <-
  ggthemes_data[["tableau"]][["color-palettes"]][["ordered-diverging"]]
for (palname in names(palettes)) {
  col <-  tableau_div_gradient_pal(palname)(seq(0, 1, length = 12))
  image(r, col = col)
  title(main = palname)
}
