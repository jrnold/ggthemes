# register_shapes_font() errors when the font file is missing

    Code
      register_shapes_font()
    Condition
      Error in `register_shapes_font()`:
      ! Can't find the shapes font in the installed ggthemes.
      x 'fonts/ggthemes-shapes.ttf' is missing from the package directory.
      i Reinstall ggthemes.

# embed_shapes_font() errors for a file that does not exist

    Code
      embed_shapes_font("no-such-file.pdf")
    Condition
      Error in `embed_shapes_font()`:
      ! Can't find the PDF file 'no-such-file.pdf'.

# embed_shapes_font() errors for paths that are not single strings

    Code
      embed_shapes_font(c("a.pdf", "b.pdf"))
    Condition
      Error in `embed_shapes_font()`:
      ! `file` must be a single string, not a character vector.

---

    Code
      embed_shapes_font(path, outfile = NULL)
    Condition
      Error in `embed_shapes_font()`:
      ! `outfile` must be a single string, not NULL.

