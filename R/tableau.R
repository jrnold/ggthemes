## HEX values agree with those at http://vis.stanford.edu/color-names/analyzer/
tableau_color_pal <- function(palette = "tableau10dark") {
    palettelist <- ggplotJrnoldPalettes$tableau$colors
    if (! palette %in%
        c(names(palettelist), "tableau10", "tableau10light",
          "purplegray6", "bluered6", "greenorange6")) {
        stop(sprintf("%s is not a valid palette name", palette))
    }
    if (palette == "tableau10") {
        types <- palettelist[["tableau20"]][seq(1, 20, by=2)]
    } else if (palette == "tableau10light") {
        types <- palettelist[["tableau20"]][seq(2, 20, by=2)]
    } else if (palette == "purplegray6") {
        types <- palettelist[["purplegray12"]][seq(1, 12, by=2)]
    } else if (palette == "bluered6") {
        types <- palettelist[["bluered12"]][seq(1, 12, by=2)]
    } else if (palette == "greenorange6") {
        types <- palettelist[["greenorange12"]][seq(1, 12, by=2)]
    } else {
        types <- palettelist[[palette]]
    }
    function(n) {
        types[seq_len(n)]
    }
}

scale_colour_tableau <- function (..., palette = "tableau10") {
    discrete_scale("colour", "tableau", tableau_color_pal(palette), ...)
}
scale_fill_tableau <- function (..., palette = "tableau10") {
    discrete_scale("fill", "tableau", tableau_color_pal(palette), ...)
}
scale_color_tableau <- scale_colour_tableau

tableau_shape_pal <- function(palette) {
    manual_pal(ggplotJrnoldPalettes$tablea$shapes[palette])
}
scale_shape_tableau <- function (..., palette = "default") {
    discrete_scale("shape", "tableau", tableau_shape_pal(palette), ...)
}

## See also
## Stephen Few, "Practical Rules for Using Color in Charts",
## Visual Business Intelligence Newsletter, February 2008
## \url{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}
