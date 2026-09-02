# Generate Solarized scatterplots and split ggthemes hex-sticker alternatives.
#
# Run from the project root with:
#   Rscript data-raw/hex-sticker.R

library(ggplot2)
library(grid)

dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

solarized <- c(
  base03 = "#002b36",
  base02 = "#073642",
  base01 = "#586e75",
  base0 = "#839496",
  base1 = "#93a1a1",
  base2 = "#eee8d5",
  base3 = "#fdf6e3",
  yellow = "#b58900",
  orange = "#cb4b16",
  blue = "#268bd2",
  cyan = "#2aa198"
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
      aes(group = 1),
      method = "lm",
      se = FALSE,
      colour = solarized[["yellow"]],
      linewidth = 0.9
    ) +
    geom_point(size = 3.2) +
    scale_colour_manual(values = solarized[c("cyan", "blue", "orange")]) +
    coord_cartesian(xlim = c(0.65, 5.25), ylim = c(0.75, 5.7), expand = FALSE) +
    labs(x = NULL, y = NULL) +
    theme_void(base_family = "sans") +
    theme(
      legend.position = "none",
      plot.background = element_rect(
        fill = if (transparent) "transparent" else background,
        colour = NA
      ),
      panel.background = element_rect(
        fill = if (transparent) "transparent" else background,
        colour = NA
      ),
      plot.margin = margin(0, 0, 0, 0)
    )
}

save_plot <- function(plot, filename, width, height, dpi = 300, background = "transparent") {
  ragg::agg_png(filename, width = width, height = height, units = "in", res = dpi, background = background)
  on.exit(dev.off(), add = TRUE)
  print(plot)
}

save_plot(
  scatter_plot(light = FALSE),
  "man/figures/solarized-scatter-dark.png",
  width = 4,
  height = 3
)
save_plot(
  scatter_plot(light = TRUE),
  "man/figures/solarized-scatter-light.png",
  width = 4,
  height = 3
)

hex <- matrix(
  c(0.5, 0.02, 0.92, 0.26, 0.92, 0.74, 0.5, 0.98, 0.08, 0.74, 0.08, 0.26),
  ncol = 2,
  byrow = TRUE
)
left_hex <- matrix(c(0.5, 0.02, 0.5, 0.98, 0.08, 0.74, 0.08, 0.26), ncol = 2, byrow = TRUE)
right_hex <- matrix(c(0.5, 0.02, 0.92, 0.26, 0.92, 0.74, 0.5, 0.98), ncol = 2, byrow = TRUE)

draw_split_wordmark <- function(left_colour, right_colour) {
  # Splitting the text itself, rather than clipping two full copies, places
  # the centre seam precisely between the h and e in ggth|emes.
  grid.text(
    "ggth",
    x = 0.5,
    y = 0.23,
    just = c("right", "centre"),
    gp = gpar(col = left_colour, fontsize = 16, fontface = "bold", fontfamily = "sans")
  )
  grid.text(
    "emes",
    x = 0.5,
    y = 0.23,
    just = c("left", "centre"),
    gp = gpar(col = right_colour, fontsize = 16, fontface = "bold", fontfamily = "sans")
  )
}

draw_solarized_sticker <- function(filename, dpi) {
  ragg::agg_png(
    filename,
    width = 2,
    height = 2.32,
    units = "in",
    res = dpi,
    background = "transparent"
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

  draw_split_wordmark(solarized[["base3"]], solarized[["base03"]])

  # Match each border half to its background's Solarized foreground colour.
  grid.lines(
    c(0.5, 0.08, 0.08, 0.5),
    c(0.02, 0.26, 0.74, 0.98),
    default.units = "npc",
    gp = gpar(col = solarized[["base1"]], lwd = 5)
  )
  grid.lines(
    c(0.5, 0.92, 0.92, 0.5),
    c(0.02, 0.26, 0.74, 0.98),
    default.units = "npc",
    gp = gpar(col = solarized[["base01"]], lwd = 5)
  )
}

# Keep the original Solarized split logo and also publish it under an explicit
# theme-specific filename.
draw_solarized_sticker("man/figures/ggthemes-hex-sticker.png", dpi = 600)
draw_solarized_sticker("man/figures/ggthemes-solarized-hex-sticker.png", dpi = 600)
draw_solarized_sticker("man/figures/logo.png", dpi = 300)

excel <- c(
  background = "#C0C0C0",
  magenta = "#FF00FF",
  yellow = "#FFFF00",
  cyan = "#00FFFF"
)

excel_tufte_scatter_plot <- function() {
  split_x <- 3
  fit <- coef(lm(y ~ x, data = points))
  left_points <- points[points[["x"]] <= split_x, , drop = FALSE]
  right_points <- points[points[["x"]] > split_x, , drop = FALSE]

  ggplot(points, aes(x = .data[["x"]], y = .data[["y"]])) +
    # Old Excel's heavy horizontal grid stops at the theme boundary.
    geom_segment(
      data = data.frame(y = 1:5),
      aes(x = 0.65, xend = split_x, y = .data[["y"]], yend = .data[["y"]]),
      inherit.aes = FALSE,
      colour = "black",
      linewidth = 0.45
    ) +
    # The fitted relationship is continuous across both theme treatments.
    geom_abline(intercept = fit[[1]], slope = fit[[2]], colour = "black", linewidth = 0.9) +
    geom_point(data = left_points, aes(colour = .data[["colour"]]), size = 3.2) +
    geom_point(data = right_points, colour = "black", size = 3.2) +
    scale_colour_manual(values = setNames(unname(excel[c("magenta", "yellow", "cyan")]), c("cyan", "blue", "orange"))) +
    coord_cartesian(xlim = c(0.65, 5.25), ylim = c(0.75, 5.7), expand = FALSE) +
    labs(x = NULL, y = NULL) +
    theme_void(base_family = "sans") +
    theme(
      legend.position = "none",
      plot.background = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.margin = margin(0, 0, 0, 0)
    )
}

draw_excel_tufte_sticker <- function(filename, dpi) {
  ragg::agg_png(filename, width = 2, height = 2.32, units = "in", res = dpi, background = "transparent")
  on.exit(dev.off(), add = TRUE)
  grid.newpage()

  grid.polygon(left_hex[, 1], left_hex[, 2], default.units = "npc", gp = gpar(fill = excel[["background"]], col = NA))
  grid.polygon(right_hex[, 1], right_hex[, 2], default.units = "npc", gp = gpar(fill = "white", col = NA))

  # One continuous chart changes from Excel to Tufte at the centre seam.
  pushViewport(viewport(x = 0.5, y = 0.54, width = 0.70, height = 0.43, clip = "on"))
  grid.draw(ggplotGrob(excel_tufte_scatter_plot()))
  popViewport()

  draw_split_wordmark("black", "black")
  grid.polygon(hex[, 1], hex[, 2], default.units = "npc", gp = gpar(fill = NA, col = "black", lwd = 3))
}

render_favicon <- function(source, filename, size) {
  system2(
    "magick",
    c(
      source,
      "-background",
      "white",
      "-alpha",
      "remove",
      "-resize",
      sprintf("%dx%d", size, size),
      "-gravity",
      "center",
      "-extent",
      sprintf("%dx%d", size, size),
      filename
    )
  )
}

draw_excel_tufte_sticker("man/figures/ggthemes-excel-tufte-hex-sticker.png", dpi = 600)

# The Excel--Tufte split is the site icon; the README uses the theme-sticker GIF.
favicon_source <- "man/figures/ggthemes-excel-tufte-hex-sticker.png"
dir.create("pkgdown/favicon", recursive = TRUE, showWarnings = FALSE)
render_favicon(favicon_source, "pkgdown/favicon/favicon-96x96.png", 96)
render_favicon(favicon_source, "pkgdown/favicon/apple-touch-icon.png", 180)
render_favicon(favicon_source, "pkgdown/favicon/web-app-manifest-192x192.png", 192)
render_favicon(favicon_source, "pkgdown/favicon/web-app-manifest-512x512.png", 512)
favicon_svg <- paste0(
  '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="278" viewBox="0 0 240 278">',
  '<image width="240" height="278" href="data:image/png;base64,',
  base64enc::base64encode(favicon_source),
  '"/></svg>'
)
writeLines(favicon_svg, "pkgdown/favicon/favicon.svg")
system2(
  "magick",
  c(
    favicon_source,
    "-background",
    "white",
    "-alpha",
    "remove",
    "-define",
    "icon:auto-resize=16,32,48,96",
    "pkgdown/favicon/favicon.ico"
  )
)
