#' Generate data/canva_palettes.rda
#'
#' The color list is from http://makeadifferencewithdata.com/2017/01/150-paletas-colores-tableau/,
#' and referenced here: https://policyviz.com/2017/01/12/150-color-palettes-for-excel/.
#'
library("xml2")
library("purrr")

color_palettes_url <- "http://makeadifferencewithdata.com/wp-content/uploads/2016/12/color-palettes.txt"

color_palettes_txt <- readLines(url(color_palettes_url))
color_palettes_xml <-
  read_xml(paste0("<palettes>",
                  paste0(color_palettes_txt, collapse = ""),
                  "</palettes>",
                  collapse = ""))

palette_names <- map_chr(xml_find_all(tree, "//color-palette"),
                         ~ xml_attr(.x, "name"))

palette_colors <- map(xml_find_all(tree, "//color-palette"),
                      ~ xml_text(xml_find_all(.x, "./color")))

canva_palettes  <- set_names(palette_colors, palette_names)

dir.create("data", showWarnings = FALSE)
save(canva_palettes, file = "data/canva_palettes.rda")
