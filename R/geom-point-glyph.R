#' Points drawn from the shapes font
#'
#' `geom_point_glyph()` is [ggplot2::geom_point()] for the shape palettes made
#' with `unicode = TRUE`. It draws their shapes from the font that ships with
#' ggthemes (see [shapes_font()]), reading the font file itself, so the shapes
#' come out at a common size without setting a font family on the device or a
#' viewport, and the plot can be saved with [ggplot2::ggsave()].
#'
#' # Devices
#'
#' A device that can draw glyphs from a font file draws the shapes that way.
#' That needs R 4.3 or later and a device that reports
#' `dev.capabilities()$glyphs`, such as `pdf()`, the \pkg{ragg} devices and
#' the quartz devices. Other devices, such as `postscript()` and
#' \pkg{svglite}, draw the shapes as ordinary points in the font family
#' `"ggthemes shapes"`, which ggthemes registers with \pkg{systemfonts} when
#' it loads. Devices that read fonts through \pkg{systemfonts} find it there;
#' the rest fall back to their own fonts.
#'
#' `pdf()` refers to the font without embedding it, so the file draws the
#' shapes only where the font is installed. [embed_shapes_font()] embeds it.
#'
#' Shapes the font does not have, such as the pictographs of
#' `tableau_shape_pal("weather", unicode = TRUE)`, and base `pch` shapes are
#' drawn as [ggplot2::geom_point()] draws them.
#'
#' @section Aesthetics:
#' The aesthetics of [ggplot2::geom_point()]: `x`, `y`, `alpha`, `colour`,
#' `fill`, `shape`, `size` and `stroke`. A shape drawn from the font is a
#' single solid glyph, so `fill` applies only to base `pch` shapes 21 to 25.
#'
#' @inheritParams ggplot2::geom_point
#' @returns A ggplot2 layer.
#' @family shapes
#' @export
#' @example inst/examples/ex-geom_point_glyph.R
geom_point_glyph <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE, # nolint: object_name_linter
  show.legend = NA, # nolint: object_name_linter
  inherit.aes = TRUE # nolint: object_name_linter
) {
  check_installed("systemfonts", reason = "to read the shapes font.")
  use_shapes_font()
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointGlyph,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' @rdname geom_point_glyph
#' @usage NULL
#' @format NULL
#' @export
# nolint start: object_name_linter
GeomPointGlyph <- ggplot2::ggproto(
  "GeomPointGlyph",
  ggplot2::GeomPoint,
  draw_panel = function(self, data, panel_params, coord, na.rm = FALSE) {
    from_font <- shape_in_font(data[["shape"]])
    grobs <- list()
    if (!all(from_font)) {
      grobs[["points"]] <- ggplot2::GeomPoint$draw_panel(
        data[!from_font, , drop = FALSE],
        panel_params,
        coord,
        na.rm = na.rm
      )
    }
    if (any(from_font)) {
      coords <- coord$transform(data[from_font, , drop = FALSE], panel_params)
      grobs[["glyphs"]] <- glyph_points_grob(coords)
    }
    ggname("geom_point_glyph", gTree(children = do.call(gList, unname(grobs))))
  },
  draw_key = function(data, params, size) {
    data[["shape"]] <- data[["shape"]] %||% 19
    if (!shape_in_font(data[["shape"]])) {
      return(ggplot2::draw_key_point(data, params, size))
    }
    # The defaults `draw_key_point()` uses.
    data[["colour"]] <- data[["colour"]] %||% "black"
    data[["size"]] <- data[["size"]] %||% 1.5
    data[["stroke"]] <- data[["stroke"]] %||% 0.5
    data[["x"]] <- 0.5
    data[["y"]] <- 0.5
    glyph_points_grob(data)
  }
)
# nolint end

#' Which shapes the shapes font draws
#'
#' A negative pch asks the font for the codepoint `-pch`. Only those the
#' font has are drawn from it; the rest, and every base or named shape, are
#' left to `GeomPoint`.
#' @noRd
shape_in_font <- function(shape) {
  if (!is.numeric(shape)) {
    return(rep(FALSE, length(shape)))
  }
  out <- !is.na(shape) & shape < 0
  out[out] <- shapes_font_metrics(-shape[out])[["index"]] > 0
  out
}

#' Glyph indices and centring offsets in the shapes font
#'
#' Offsets are per point of font size. They reproduce how R centres a
#' character pch: horizontally on its advance width and vertically on its ink.
#' Measured once per codepoint and cached, since the font never changes.
#' @noRd
shapes_font_metrics <- function(codepoints) {
  cache <- shapes_font_state[["metrics"]] %||% list()
  keys <- as.character(codepoints)
  new <- unique(keys[!keys %in% names(cache)])
  if (length(new)) {
    info <- systemfonts::glyph_info(
      intToUtf8(as.integer(new), multiple = TRUE),
      path = shapes_font_path(),
      index = 0,
      size = 100,
      res = 72
    )
    bbox <- do.call(rbind, info[["bbox"]])
    measured <- Map(
      function(index, x_mid, y_mid) list(index = index, x_mid = x_mid, y_mid = y_mid),
      ifelse(is.na(info[["index"]]), 0L, info[["index"]]),
      info[["x_advance"]] / 2 / 100,
      (bbox[, "ymin"] + bbox[, "ymax"]) / 2 / 100
    )
    cache[new] <- measured
    shapes_font_state[["metrics"]] <- cache
  }
  rows <- cache[keys]
  list(
    index = vapply(rows, `[[`, integer(1), "index", USE.NAMES = FALSE),
    x_mid = vapply(rows, `[[`, numeric(1), "x_mid", USE.NAMES = FALSE),
    y_mid = vapply(rows, `[[`, numeric(1), "y_mid", USE.NAMES = FALSE)
  )
}

#' A grob of points drawn from the shapes font
#'
#' The choice between glyph drawing and the fallback depends on the device,
#' which is known only at draw time, so it is made in `makeContent()`.
#' @noRd
glyph_points_grob <- function(data) {
  gp <- ggplot2::gg_par(pointsize = data[["size"]], stroke = data[["stroke"]])
  gTree(
    x = data[["x"]],
    y = data[["y"]],
    codepoint = -as.integer(data[["shape"]]),
    col = alpha(data[["colour"]], data[["alpha"]]),
    fontsize = gp[["fontsize"]],
    cl = "ggthemes_glyph_points"
  )
}

#' @importFrom grid makeContent
#' @export
makeContent.ggthemes_glyph_points <- function(x) {
  child <- if (device_draws_glyphs()) glyph_child(x) else glyph_fallback_child(x)
  grid::setChildren(x, gList(child))
}

# `glyphInfo()` and friends arrived in R 4.3; the package supports 4.1, so
# they are looked up rather than referenced.
glyph_api <- function() {
  grdevices <- asNamespace("grDevices")
  api <- list(
    info = get0("glyphInfo", envir = grdevices, inherits = FALSE),
    font = get0("glyphFont", envir = grdevices, inherits = FALSE),
    font_list = get0("glyphFontList", envir = grdevices, inherits = FALSE),
    anchor = get0("glyphAnchor", envir = grdevices, inherits = FALSE),
    grob = get0("glyphGrob", envir = asNamespace("grid"), inherits = FALSE)
  )
  if (any(vapply(api, is.null, logical(1)))) {
    return(NULL)
  }
  api
}

device_draws_glyphs <- function() {
  !is.null(glyph_api()) && isTRUE(grDevices::dev.capabilities()[["glyphs"]])
}

# Glyph positions are absolute, in big points from the viewport's lower left
# corner, so the block they form is anchored there with a zero size.
glyph_child <- function(x) {
  api <- glyph_api()
  metrics <- shapes_font_metrics(x[["codepoint"]])
  fontsize <- rep_len(x[["fontsize"]], length(x[["codepoint"]]))
  xs <- grid::convertX(unit(x[["x"]], "native"), "bigpts", valueOnly = TRUE)
  ys <- grid::convertY(unit(x[["y"]], "native"), "bigpts", valueOnly = TRUE)
  font <- api$font(shapes_font_path(), 0L, shapes_font_family, 400, "normal")
  info <- api$info(
    id = metrics[["index"]],
    x = xs - metrics[["x_mid"]] * fontsize,
    y = ys - metrics[["y_mid"]] * fontsize,
    font = 1L,
    size = fontsize,
    fontList = api$font_list(font),
    width = 0,
    height = 0,
    hAnchor = api$anchor(0, "left"),
    vAnchor = api$anchor(0, "bottom"),
    col = rep_len(x[["col"]], length(x[["codepoint"]]))
  )
  api$grob(info, x = 0, y = 0, hjust = "left", vjust = "bottom")
}

glyph_fallback_child <- function(x) {
  grid::pointsGrob(
    x[["x"]],
    x[["y"]],
    pch = -x[["codepoint"]],
    default.units = "native",
    gp = gpar(col = x[["col"]], fontsize = x[["fontsize"]], fontfamily = shapes_font_family)
  )
}
