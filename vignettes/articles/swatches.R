# Swatch figures for palette galleries, shared by README.Rmd and
# vignettes/articles/palettes.Rmd.

# Columns are referenced through the `.data` pronoun; the local binding lets
# lintr's object_usage_linter see where that name comes from.
.data <- rlang::.data

# Lay palettes out on a grid where one swatch is one unit square: each row is
# a right-aligned label followed by its swatches, and long families wrap into
# `ncol` columns. Drawing everything in one panel (rather than facets) keeps
# every column's swatches full size whatever the label lengths.
tile <- 0.22 # inches per swatch
char <- 0.075 / tile # width of one 9pt monospace character, in swatch units

swatch_layout <- function(rows, ncol = 1) {
  per_col <- ceiling(length(rows) / ncol)
  label_w <- max(nchar(names(rows))) * char + 0.6
  col_w <- label_w + max(lengths(rows)) + 1.5
  k <- seq_along(rows)
  list(
    labels = data.frame(
      x = ((k - 1) %/% per_col) * col_w + label_w - 0.4,
      y = -((k - 1) %% per_col),
      label = names(rows)
    ),
    tiles = do.call(
      rbind,
      lapply(k, function(j) {
        data.frame(
          x = ((j - 1) %/% per_col) * col_w + label_w + seq_along(rows[[j]]) - 0.5,
          y = -((j - 1) %% per_col),
          colour = unname(rows[[j]])
        )
      })
    ),
    width = ncol * col_w,
    height = per_col
  )
}

swatch_plot <- function(rows, ncol = 1) {
  l <- swatch_layout(rows, ncol)
  ggplot2::ggplot() +
    ggplot2::geom_tile(
      ggplot2::aes(.data$x, .data$y, fill = .data$colour),
      data = l$tiles,
      width = 0.9,
      height = 0.8,
      # A faint outline keeps white and near-white swatches visible.
      colour = "grey80",
      linewidth = 0.2
    ) +
    ggplot2::geom_text(
      ggplot2::aes(.data$x, .data$y, label = .data$label),
      data = l$labels,
      hjust = 1,
      family = "mono",
      size = 9 / ggplot2::.pt
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::coord_cartesian(xlim = c(0, l$width), ylim = c(-l$height + 0.5, 0.5), expand = FALSE) +
    ggplot2::theme_void()
}

# Figure size in inches that makes each swatch `tile` inches square.
swatch_width <- function(rows, ncol = 1) swatch_layout(rows, ncol)$width * tile
swatch_height <- function(rows, ncol = 1) swatch_layout(rows, ncol)$height * tile
