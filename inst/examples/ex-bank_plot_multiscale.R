library("ggplot2")

y <- as.numeric(sunspot.year)
p <- ggplot(data.frame(x = seq_along(y), y = y), aes(x = x, y = y)) +
  geom_line()

# One plot per scale of interest, named by frequency index.
plots <- bank_plot_multiscale(p)
names(plots)

## Low-frequency trend across sunspot cycles
plots[[1]]

## The individual 11-year cycles
plots[[2]]
