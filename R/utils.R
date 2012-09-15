## Taken from ggplot2
rd_aesthetics <- function(name, geom) {
    aes <- ggplot2:::aesthetics(geom)
    paste("\\code{", name, "} ", "understands the following aesthetics (required aesthetics are in bold):\n\n",
        "\\itemize{\n", paste("  \\item \\code{", aes, "}", collapse = "\n",
            sep = ""), "\n}\n", sep = "")
}

}
