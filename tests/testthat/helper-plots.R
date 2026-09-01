# Shared figures for the visual regression tests.
#
# Every theme baseline is generated from one identical plot, so that a diff
# isolates the theme rather than an incidental difference between figures.

# Columns are referenced through the `.data` pronoun, which ggplot2 resolves
# from the data mask. The local binding exists only so that lintr's
# object_usage_linter can see where those names come from.
.data <- rlang::.data

# A small faceted scatter plot that exercises the elements themes actually
# customise: panel background and grid, axis text/titles/ticks, facet strips,
# the legend, and the title/subtitle/caption block.
theme_test_plot <- function() {
  df <- data.frame(
    x = rep(1:5, times = 4),
    y = c(2, 4, 3, 5, 4, 5, 3, 6, 4, 7, 3, 5, 4, 6, 5, 6, 4, 7, 5, 8),
    z = rep(c("a", "b"), each = 10),
    panel = rep(c("I", "II"), times = 10)
  )
  ggplot2::ggplot(df, ggplot2::aes(x = .data$x, y = .data$y, colour = .data$z)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~panel) +
    ggplot2::labs(
      title = "Title",
      subtitle = "Subtitle",
      caption = "Caption",
      x = "X axis",
      y = "Y axis",
      colour = "Group"
    )
}

# A swatch grid: one palette per row, one tile per colour, drawn in the order
# the palette defines. An out-of-family colour in an ordered ramp shows up as a
# visible band, which is the failure mode that shipped undetected in #217.
swatch_plot <- function(palettes, title = NULL) {
  rows <- lapply(names(palettes), function(nm) {
    colours <- palettes[[nm]]
    data.frame(
      palette = nm,
      index = seq_along(colours),
      colour = colours,
      stringsAsFactors = FALSE
    )
  })
  df <- do.call(rbind, rows)
  # Draw the first palette at the top rather than the bottom.
  df$palette <- factor(df$palette, levels = rev(names(palettes)))

  ggplot2::ggplot(
    df,
    ggplot2::aes(x = .data$index, y = .data$palette, fill = .data$colour)
  ) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_identity() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ggplot2::theme_void() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(
        size = 5,
        hjust = 1,
        margin = ggplot2::margin(r = 2)
      ),
      plot.title = ggplot2::element_text(size = 8, face = "bold")
    )
}
