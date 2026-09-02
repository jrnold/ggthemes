# Helpers for the shape-table tests.
#
# The shape tables are scattered across `ggthemes_data` under per-source names
# (`$few$shapes`, `$tableau$`shape-palettes`$default`, ...) and do not all use
# the same column names: `stata$shapes` keys its rows on `symbolstyle` and
# spells its codepoint column `unicode_value`. `shape_tables()` collects them
# all under one normalised schema so the §4.3 validation can be asserted over
# every table at once rather than one call site at a time.

# Columns are referenced through the `.data` pronoun, which ggplot2 resolves
# from the data mask. The local binding exists only so that lintr's
# object_usage_linter can see where those names come from.
.data <- rlang::.data

# Every shape table in `ggthemes_data`, as a named list of data frames.
shape_tables <- function() {
  data <- ggthemes::ggthemes_data
  out <- list(
    "shapes/cleveland/overlap" = data$shapes$cleveland$overlap,
    "shapes/cleveland/default" = data$shapes$cleveland$default,
    "shapes/circlefill" = data$shapes$circlefill,
    "few/shapes" = data$few$shapes,
    "calc/shapes" = data$calc$shapes,
    "gdocs/shapes" = data$gdocs$shapes,
    "excel/shapes" = data$excel$shapes,
    "stata/shapes" = data$stata$shapes
  )
  for (nm in names(data$shapes$tremmel)) {
    out[[paste0("shapes/tremmel/", nm)]] <- data$shapes$tremmel[[nm]]
  }
  for (nm in names(data$tableau[["shape-palettes"]])) {
    out[[paste0("tableau/", nm)]] <- data$tableau[["shape-palettes"]][[nm]]
  }
  out
}

# `stata/shapes` spells its codepoint column `unicode_value`; everything else
# calls it `unicode`.
shape_unicode <- function(x) if ("unicode" %in% names(x)) x$unicode else x$unicode_value

# The codepoint a `unicode` field names. Some rows carry a variation selector
# ("U+2714 U+FE0E"), which selects a rendering of the same character rather
# than a different one, so only the first token identifies the shape.
unicode_codepoint <- function(x) {
  strtoi(sub("^U\\+", "", sub(" .*$", "", x)), base = 16L)
}

# The codepoint a `character` field actually holds, compared against the above.
character_codepoint <- function(x) {
  vapply(x, function(ch) utf8ToInt(ch)[[1]], integer(1), USE.NAMES = FALSE)
}

# pch values R can draw without consulting a font: the symbol set 0:25 and the
# ASCII range 32:127. NA means "this shape has no font-independent equivalent".
is_safe_pch <- function(x) is.na(x) | (x %in% c(0:25, 32:127))

# A grid of the shapes a palette actually emits: one row per palette, one point
# per shape, drawn at the pch the palette returns. A shape that changes
# identity, or a palette that truncates further than intended, shows up
# directly. Only the font-independent branch is drawn -- snapshotting glyph
# output would record the build machine's fonts as the expected result, which
# is the fragility this palette design exists to remove.
shape_swatch_plot <- function(palettes, title = NULL) {
  rows <- lapply(names(palettes), function(nm) {
    values <- palettes[[nm]]
    data.frame(
      palette = nm,
      index = seq_along(values),
      pch = as.integer(values),
      stringsAsFactors = FALSE
    )
  })
  df <- do.call(rbind, rows)
  # Draw the first palette at the top rather than the bottom.
  df$palette <- factor(df$palette, levels = rev(names(palettes)))

  ggplot2::ggplot(
    df,
    ggplot2::aes(x = .data$index, y = .data$palette, shape = .data$pch)
  ) +
    ggplot2::geom_point(size = 3) +
    ggplot2::scale_shape_identity() +
    ggplot2::scale_x_continuous(breaks = seq_len(max(df$index))) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(size = 6),
      plot.title = ggplot2::element_text(size = 8, face = "bold")
    )
}

# Every shape palette an exported function reaches, on its default branch, at
# its full length.
safe_shape_values <- function() {
  full <- function(pal) pal(attr(pal, "max_n"))
  list(
    "stata" = full(stata_shape_pal()),
    "few" = full(few_shape_pal()),
    "tremmel n=3" = tremmel_shape_pal()(3),
    "tremmel n=3 alt" = tremmel_shape_pal(alt = TRUE)(3),
    "tremmel n=2 overlap" = tremmel_shape_pal(overlap = TRUE)(2),
    "cleveland overlap" = full(cleveland_shape_pal(overlap = TRUE)),
    "cleveland default" = full(cleveland_shape_pal(overlap = FALSE)),
    "calc" = full(calc_shape_pal()),
    "tableau default" = full(tableau_shape_pal("default")),
    "tableau filled" = full(tableau_shape_pal("filled")),
    "tableau proportions" = full(tableau_shape_pal("proportions"))
  )
}
