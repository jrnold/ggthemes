library("scales")

x <- seq(0, 1, length = 25)
r <- sqrt(outer(x ^ 2, x ^ 2, "+"))
palettes <-
  ggthemes_data[["tableau"]][["color-palettes"]][["ordered-sequential"]]
for (palname in names(palettes)) {
  col <- tableau_seq_gradient_pal(palname)(seq(0, 1, length = 12))
  image(r, col = col)
  title(main = palname)
}
