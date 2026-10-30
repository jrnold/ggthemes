# Embed the shapes font in a PDF file

[`grDevices::pdf()`](https://rdrr.io/r/grDevices/pdf.html) draws the
glyphs of
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md)
by referring to the shapes font without embedding it, so the file shows
the shapes only on a system where the font is installed.
`embed_shapes_font()` embeds the shapes it uses, with Ghostscript
through
[`grDevices::embedGlyphs()`](https://rdrr.io/r/grDevices/embedFonts.html).

## Usage

``` r
embed_shapes_font(file, outfile = file)
```

## Arguments

- file:

  Path to a PDF file written by
  [`grDevices::pdf()`](https://rdrr.io/r/grDevices/pdf.html).

- outfile:

  Path to write the PDF with the font embedded. The default overwrites
  `file`.

## Value

`outfile`, invisibly. It is `file` unless `outfile` is given, so the
result is always the path of the PDF with the font embedded.

## Details

Requires R 4.3 or later and Ghostscript (see
[`tools::find_gs_cmd()`](https://rdrr.io/r/tools/find_gs_cmd.html)).
Only files written by [`pdf()`](https://rdrr.io/r/grDevices/pdf.html)
need it: ragg and the other raster devices draw the glyphs into the
image.

## See also

[`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md)
for the font itself.

Other shapes:
[`cleveland_shape_pal()`](https://jrnold.github.io/ggthemes/reference/cleveland_shape_pal.md),
[`geom_point_glyph()`](https://jrnold.github.io/ggthemes/reference/geom_point_glyph.md),
[`register_shapes_font()`](https://jrnold.github.io/ggthemes/reference/register_shapes_font.md),
[`scale_shape_cleveland()`](https://jrnold.github.io/ggthemes/reference/scale_shape_cleveland.md),
[`scale_shape_tremmel()`](https://jrnold.github.io/ggthemes/reference/scale_shape_tremmel.md),
[`tremmel_shape_pal()`](https://jrnold.github.io/ggthemes/reference/tremmel_shape_pal.md)

## Examples

``` r
library("ggplot2")
p <- ggplot(mtcars, aes(wt, mpg, shape = factor(gear))) +
  geom_point_glyph(size = 3) +
  scale_shape_cleveland(unicode = TRUE)
path <- tempfile(fileext = ".pdf")
ggsave(path, p, device = pdf, width = 5, height = 4)
embed_shapes_font(path)
```
