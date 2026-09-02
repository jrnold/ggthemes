# Generate alternative, theme-specific hex stickers for ggthemes and animate
# them into a looping GIF.
#
# The split-background Solarized sticker in data-raw/hex-sticker.R is the
# package's actual logo and stays untouched. This script produces one
# flat-background sticker per point-colour palette (the qualitative,
# discrete palettes meant for colouring points by group) -- including
# Solarized's own light and dark variants -- each restyled with that
# theme's own background, gridlines, and palette, all drawn from the same
# scatterplot data so the frames read as one plot repainted in every theme.
#
# Sequential/gradient palettes (economist_seq_pal(), tableau_gradient_pal()
# and friends), point-shape-only palettes, and the deprecated ptol_pal() are
# out of scope: they aren't the "colour points by group" palettes this
# gallery is about.
#
# Run from the project root with:
#   Rscript data-raw/theme-stickers.R

library(ggplot2)
library(grid)
devtools::load_all(".", quiet = TRUE)

dir.create("man/figures/stickers", recursive = TRUE, showWarnings = FALSE)

set.seed(20260902)
scatter_x <- sort(runif(16, 0.85, 5.05))
points <- data.frame(
  x = scatter_x,
  y = pmax(0.9, pmin(5.2, 1 + 0.7 * scatter_x + rnorm(16, sd = 0.8))),
  group = sample(rep(c(1, 2, 3), length.out = 16))
)

default_trend_colour <- "#404040"
default_wordmark_colour <- "#22292f"

theme_specs <- list(
  list(
    id = "solarized-light",
    background = ggthemes:::solarized_rebase(light = TRUE)[["rebase03"]],
    grid_colour = ggthemes:::solarized_rebase(light = TRUE)[["rebase02"]],
    show_grid = TRUE,
    colours = solarized_pal()(3)
  ),
  list(
    id = "solarized-dark",
    background = ggthemes:::solarized_rebase(light = FALSE)[["rebase03"]],
    grid_colour = ggthemes:::solarized_rebase(light = FALSE)[["rebase02"]],
    show_grid = TRUE,
    colours = solarized_pal()(3),
    wordmark_colour = ggthemes:::solarized_rebase(light = FALSE)[["rebase1"]],
    trend_colour = ggthemes:::solarized_rebase(light = FALSE)[["rebase1"]]
  ),
  list(
    id = "economist",
    background = "#e9edf0",
    grid_colour = "#b7c6cf",
    show_grid = TRUE,
    colours = economist_pal()(3)
  ),
  list(
    id = "fivethirtyeight",
    background = "#F0F0F0",
    grid_colour = "#D2D2D2",
    show_grid = TRUE,
    colours = fivethirtyeight_pal()(3)
  ),
  list(id = "few", background = "#FFFFFF", grid_colour = NA, show_grid = FALSE, colours = few_pal()(3)),
  list(id = "wsj", background = "#f8f2e4", grid_colour = "#000000", show_grid = TRUE, colours = wsj_pal()(3)),
  list(id = "stata", background = "#eaf2f3", grid_colour = "#d9e6e8", show_grid = TRUE, colours = stata_pal()(3)),
  list(
    id = "tableau",
    background = "#FFFFFF",
    grid_colour = "#e6e6e6",
    show_grid = TRUE,
    colours = tableau_color_pal()(3)
  ),
  list(id = "gdocs", background = "#FFFFFF", grid_colour = "#cccccc", show_grid = TRUE, colours = gdocs_pal()(3)),
  list(id = "calc", background = "#FFFFFF", grid_colour = "#B3B3B3", show_grid = TRUE, colours = calc_pal()(3)),
  list(id = "excel", background = "#FFFFFF", grid_colour = "#D9D9D9", show_grid = TRUE, colours = excel_new_pal()(3)),
  list(id = "canva", background = "#FFFFFF", grid_colour = "#e6e6e6", show_grid = TRUE, colours = canva_pal()(3)),
  list(id = "hc", background = "#FFFFFF", grid_colour = "#e6e6e6", show_grid = TRUE, colours = hc_pal()(3)),
  list(
    id = "colorblind",
    background = "#FFFFFF",
    grid_colour = "#e6e6e6",
    show_grid = TRUE,
    colours = colorblind_pal()(3)
  ),
  list(id = "numbers", background = "#FFFFFF", grid_colour = "#AAAAAA", show_grid = TRUE, colours = numbers_pal()(3)),
  # Tufte has no colour palette -- "maximal data, minimal ink" means no
  # gridlines and every point in a single black ink, not grouped by hue.
  list(id = "tufte", background = "#FFFFFF", grid_colour = NA, show_grid = FALSE, colours = rep("#000000", 3))
)

scatter_plot <- function(spec, transparent = FALSE) {
  plot <- ggplot(points, aes(x = .data[["x"]], y = .data[["y"]], colour = factor(.data[["group"]])))
  if (spec$show_grid) {
    plot <- plot +
      geom_hline(yintercept = 1:5, colour = spec$grid_colour, linewidth = 0.45) +
      geom_vline(xintercept = 1:5, colour = spec$grid_colour, linewidth = 0.45)
  }
  plot +
    geom_smooth(
      aes(group = 1),
      method = "lm",
      se = FALSE,
      colour = spec$trend_colour %||% default_trend_colour,
      linewidth = 0.9
    ) +
    geom_point(size = 3.2) +
    scale_colour_manual(values = spec$colours) +
    coord_cartesian(xlim = c(0.65, 5.25), ylim = c(0.75, 5.7), expand = FALSE) +
    labs(x = NULL, y = NULL) +
    theme_void(base_family = "sans") +
    theme(
      legend.position = "none",
      plot.background = element_rect(
        fill = if (transparent) "transparent" else spec$background,
        colour = NA
      ),
      panel.background = element_rect(
        fill = if (transparent) "transparent" else spec$background,
        colour = NA
      ),
      plot.margin = margin(0, 0, 0, 0)
    )
}

hex <- matrix(
  c(0.5, 0.02, 0.92, 0.26, 0.92, 0.74, 0.5, 0.98, 0.08, 0.74, 0.08, 0.26),
  ncol = 2,
  byrow = TRUE
)

draw_sticker <- function(spec, filename, dpi) {
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

  grid.polygon(hex[, 1], hex[, 2], default.units = "npc", gp = gpar(fill = spec$background, col = NA))

  pushViewport(viewport(x = 0.5, y = 0.54, width = 0.70, height = 0.43, clip = "on"))
  grid.draw(ggplotGrob(scatter_plot(spec, transparent = TRUE)))
  popViewport()

  grid.text(
    "ggthemes",
    x = 0.5,
    y = 0.23,
    just = "centre",
    gp = gpar(
      col = spec$wordmark_colour %||% default_wordmark_colour,
      fontsize = 16,
      fontface = "bold",
      fontfamily = "sans"
    )
  )

  # The point palette's own first colour traces the border, so each sticker
  # still reads as "that theme" even before the wordmark or plot register.
  grid.polygon(
    hex[, 1],
    hex[, 2],
    default.units = "npc",
    gp = gpar(fill = NA, col = spec$colours[[1]], lwd = 5)
  )
}

frame_files <- vapply(
  theme_specs,
  function(spec) {
    filename <- sprintf("man/figures/stickers/%s-hex-sticker.png", spec$id)
    draw_sticker(spec, filename, dpi = 300)
    filename
  },
  character(1)
)

gifski::gifski(
  frame_files,
  gif_file = "man/figures/stickers/ggthemes-theme-stickers.gif",
  width = 600,
  height = 696,
  delay = 1,
  loop = TRUE
)
