# shapes_font() errors when the font file is missing

    Code
      shapes_font()
    Condition
      Error in `shapes_font()`:
      ! Can't find the shapes font in the installed ggthemes.
      x 'fonts/ggthemes-shapes.ttf' is missing from the package directory.
      i Reinstall ggthemes.

# embed_shapes_font() errors for a file that does not exist

    Code
      embed_shapes_font("no-such-file.pdf")
    Condition
      Error in `embed_shapes_font()`:
      ! `file` must be the path to an existing PDF file.

