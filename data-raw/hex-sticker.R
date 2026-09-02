# Generate solarized scatterplots and the ggthemes hex sticker.
#
# Run from the project root with:
#   Rscript data-raw/hex-sticker.R

library(ggplot2)
library(grid)

dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

solarized <- c(
  base03 = "#002b36", base02 = "#073642", base01 = "#586e75",
  base0 = "#839496", base1 = "#93a1a1", base2 = "#eee8d5",
  base3 = "#fdf6e3", yellow = "#b58900", orange = "#cb4b16",
  blue = "#268bd2", cyan = "#2aa198"
)

set.seed(20260901)
scatter_x <- sort(runif(16, 0.85, 5.05))
points <- data.frame(
  x = scatter_x,
  y = pmax(0.9, pmin(5.2, 1 + 0.7 * scatter_x + rnorm(16, sd = 0.8))),
  colour = sample(rep(c("cyan", "blue", "orange"), length.out = 16))
)

scatter_plot <- function(light = TRUE, transparent = FALSE) {
  background <- if (light) solarized[["base3"]] else solarized[["base03"]]
  grid_colour <- if (light) solarized[["base2"]] else solarized[["base02"]]

  ggplot(points, aes(x = .data[["x"]], y = .data[["y"]], colour = .data[["colour"]])) +
    geom_hline(yintercept = 1:5, colour = grid_colour, linewidth = 0.45) +
    geom_vline(xintercept = 1:5, colour = grid_colour, linewidth = 0.45) +
    geom_smooth(
      aes(group = 1), method = "lm", se = FALSE,
      colour = solarized[["yellow"]], linewidth = 0.9
    ) +
    geom_point(size = 3.2) +
    scale_colour_manual(values = solarized[c("cyan", "blue", "orange")]) +
    coord_cartesian(xlim = c(0.65, 5.25), ylim = c(0.75, 5.7), expand = FALSE) +
    labs(x = NULL, y = NULL) +
    theme_void(base_family = "sans") +
    theme(
      legend.position = "none",
      plot.background = element_rect(
        fill = if (transparent) "transparent" else background, colour = NA
      ),
      panel.background = element_rect(
        fill = if (transparent) "transparent" else background, colour = NA
      ),
      plot.margin = margin(0, 0, 0, 0)
    )
}

save_plot <- function(plot, filename, width, height, dpi = 300, background = "transparent") {
  ragg::agg_png(filename, width = width, height = height, units = "in", res = dpi,
    background = background
  )
  on.exit(dev.off(), add = TRUE)
  print(plot)
}

save_plot(
  scatter_plot(light = FALSE), "man/figures/solarized-scatter-dark.png",
  width = 4, height = 3
)
save_plot(
  scatter_plot(light = TRUE), "man/figures/solarized-scatter-light.png",
  width = 4, height = 3
)

hex <- matrix(
  c(0.5, 0.02, 0.92, 0.26, 0.92, 0.74, 0.5, 0.98, 0.08, 0.74, 0.08, 0.26),
  ncol = 2, byrow = TRUE
)
left_hex <- matrix(c(0.5, 0.02, 0.5, 0.98, 0.08, 0.74, 0.08, 0.26), ncol = 2, byrow = TRUE)
right_hex <- matrix(c(0.5, 0.02, 0.92, 0.26, 0.92, 0.74, 0.5, 0.98), ncol = 2, byrow = TRUE)

draw_sticker <- function(filename, dpi) {
ragg::agg_png(
  filename, width = 2, height = 2.32,
  units = "in", res = dpi, background = "transparent"
)
on.exit(dev.off(), add = TRUE)
grid.newpage()

# A single hexagon split into the two canonical Solarized backgrounds.
grid.polygon(left_hex[, 1], left_hex[, 2], default.units = "npc", gp = gpar(fill = solarized[["base03"]], col = NA))
grid.polygon(right_hex[, 1], right_hex[, 2], default.units = "npc", gp = gpar(fill = solarized[["base3"]], col = NA))

# The small scatterplot remains intentionally sparse enough to read at sticker size.
pushViewport(viewport(x = 0.5, y = 0.54, width = 0.70, height = 0.43, clip = "on"))
grid.draw(ggplotGrob(scatter_plot(transparent = TRUE)))
popViewport()

# Draw the package name twice, clipped at the centre: pale over dark and dark over pale.
pushViewport(viewport(x = 0.25, y = 0.23, width = 0.5, height = 0.14, clip = "on"))
grid.text("ggthemes", x = 1.04, y = 0.5, just = "centre",
  gp = gpar(col = solarized[["base3"]], fontsize = 16, fontface = "bold", fontfamily = "sans")
)
popViewport()
pushViewport(viewport(x = 0.75, y = 0.23, width = 0.5, height = 0.14, clip = "on"))
grid.text("ggthemes", x = 0.04, y = 0.5, just = "centre",
  gp = gpar(col = solarized[["base03"]], fontsize = 16, fontface = "bold", fontfamily = "sans")
)
popViewport()

# Match each border half to its background's Solarized foreground colour.
grid.lines(
  c(0.5, 0.08, 0.08, 0.5), c(0.02, 0.26, 0.74, 0.98),
  default.units = "npc", gp = gpar(col = solarized[["base1"]], lwd = 5)
)
grid.lines(
  c(0.5, 0.92, 0.92, 0.5), c(0.02, 0.26, 0.74, 0.98),
  default.units = "npc", gp = gpar(col = solarized[["base01"]], lwd = 5)
)
}

# Keep the README logo high-density so the clipped two-tone wordmark remains
# sharp when pkgdown and GitHub scale it down.
draw_sticker("man/figures/ggthemes-hex-sticker.png", dpi = 600)
draw_sticker("man/figures/logo.png", dpi = 300)
