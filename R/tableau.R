## HEX values agree with those at http://vis.stanford.edu/color-names/analyzer/
tableau_palettes <- list()
tableau_palettes$colors <-
    list(
        tableau20 =
        c("1F77B4",
          "AEC7E8",
          "FF7F0E",
          "FFBB78",
          "2CA02C",
          "98DF8A",
          "D62728",
          "FF9896",
          "9467BD",
          "C5B0D5",
          "8C564B",
          "C49C94",
          "E377C2",
          "F7B6D2",
          "7F7F7F",
          "C7C7C7",
          "BCBD22",
          "DBDB8D",
          "17BECF",
          "9EDAE5"),
        ## Tablau10 are odd, Tableau10-light are even
        tableau10medium =
        c("729ECE",
          "FF9E4A",
          "67BF5C",
          "ED665D",
          "AD8BC9",
          "A8786E",
          "ED97CA",
          "A2A2A2",
          "CDCC5D",
          "6DCCDA"),
        gray5 =
        c("60636A",
          "A5ACAF",
          "414451",
          "8F8782",
          "CFCFCF"),
        colorblind10 =
        c("006BA4",
          "FF800E",
          "ABABAB",
          "595959",
          "5F9ED1",
          "C85200",
          "898989",
          "A2C8EC",
          "FFBC79",
          "CFCFCF"),
        trafficlight =
        c("B10318",
          "DBA13A",
          "309343",
          "D82526",
          "FFC156",
          "69B764",
          "F26C64",
          "FFDD71",
          "9FCD99"),
        purplegray12 =
        c("7B66D2",
          "A699E8",
          "DC5FBD",
          "FFC0DA",
          "5F5A41",
          "B4B19B",
          "995688",
          "D898BA",
          "AB6AD5",
          "D098EE",
          "8B7C6E",
          "DBD4C5"),
        ## purplegray6 is oddd
        bluered12 =
        c("2C69B0",
          "B5C8E2",
          "F02720",
          "FFB6B0",
          "AC613C",
          "E9C39B",
          "6BA3D6",
          "B5DFFD",
          "AC8763",
          "DDC9B4",
          "BD0A36",
          "F4737A"),
        ## bluered6 is odd
        greenorange12 =
        c("32A251",
          "ACD98D",
          "FF7F0F",
          "FFB977",
          "3CB7CC",
          "98D9E4",
          "B85A0D",
          "FFD94A",
          "39737C",
          "86B4A9",
          "82853B",
          "CCC94D")
        ## greenorange6 is odd
        )
tableau_palettes$shapes <-
    list(proportions = c(#
         -0x25CBL, # White circle
         -0x25DL, # CIRCLE WITH UPPER RIGHT QUADRANT BLACK
         -0x25D1L, #CIRCLE WITH RIGHT HALF BLACK
         -0x25D5L, # CIRCLE WITH ALL BUT UPPER LEFT QUADRANT BLACK
         -0x25CFL # Black Circle
         ),
         default = c(
         1L, # circle
         0L, # square
         3L, # plus
         4L, # x
         -0x2217L, # multiplication symbol
         5L, # diamond
         -0x25B3L, # WHITE UP-POINTING TRIANGLE
         -0x25BDL, # WHITE DOWN-POINTING TRIANGLE
         -0x25B7L, # WHITE RIGHT-POINTING TRIANGLE
         -0x25C1L # WHITE LEFT-POINTING TRIANGLE
         ),
         filled = c(
         16L, # black circle
         15L, # black square
         -0x2795L, # heavy plus sign
         -0x2716L, # heavy multiplication x
         -0x2605L, # black star
         18L, # diamond
         -0x25B2L, # WHITE UP-POINTING TRIANGLE
         -0x25BCL, # WHITE DOWN-POINTING TRIANGLE
         -0x25B6L, # WHITE RIGHT-POINTING TRIANGLE
         -0x25C0L # WHITE LEFT-POINTING TRIANGLE
         ),
         gender =
         c(-0x2642L, # male
           -0x2640L # female
           ),
         kpi =
         c(-0x2713L, # check mark
          21L, # exclamation point
          4L, # x
          16L, # solid circle
          17L, # solid triangle
          18L # solid diamond
          ),
         thin_arrows =
         c(-0x2193L, # downwards
           -0x2198L, # southeast
           -0x2192L, # rightwards
           -0x2197L, # northeast
           -0x2191L, # upwards
           -0x2196L, # north west
           -0x2190L, # leftwards
           -0x2199L # south west
           ),
         weather =
         c(-0x2600L, # black sun with rays
           -0x2601L, # coloud
           -0x2602L, # umbrella
           -0x2603L # snowman
         ))

tableau_color_pal <- function(palette = "tableau10dark") {
    palettelist <- tableau_palettes$colors
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
    manual_pal(tableau_palettes$shapes[palette])
}
scale_shape_tableau <- function (..., palette = "default") {
    discrete_scale("shape", "tableau", tableau_shape_pal(palette), ...)
}

## See also
## Stephen Few, "Practical Rules for Using Color in Charts",
## Visual Business Intelligence Newsletter, February 2008
## \url{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}
