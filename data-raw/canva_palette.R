#' Generate data/canva_palettes.rda
#'
#' The color list is from http://makeadifferencewithdata.com/2017/01/150-paletas-colores-tableau/,
#' and referenced here: https://policyviz.com/2017/01/12/150-color-palettes-for-excel/.
#'
library("xml2")
library("purrr")

color_palettes_url <- "http://makeadifferencewithdata.com/wp-content/uploads/2016/12/color-palettes.txt"

color_palettes_txt <- readLines(color_palettes_url)

tree <-
  read_xml(paste0("<palettes>",
                  paste0(color_palettes_txt, collapse = ""),
                  "</palettes>",
                  collapse = ""))

palette_names <- map_chr(xml_find_all(tree, "//color-palette"),
                         ~ xml_attr(.x, "name"))

palette_colors <- map(xml_find_all(tree, "//color-palette"),
                      ~ xml_text(xml_find_all(.x, "./color"))) %>%
  # one of the palettes has a bad HTML code. See #78
  map(str_sub, 1, 7)

canva_palettes  <- set_names(palette_colors, palette_names) %>%
  # drop bad Trendy and metropolitan. See #78
  discard(~ .x[1] == "#")

# Rename duplicate "Vintage charm"
names(canva_palettes)[(names(canva_palettes) == "Vintage charm") &
                        duplicated(names(canva_palettes))]  <- "Vintage charm 2"

# check that no duplicate names
stopifnot(!any(duplicated(names(canva_palettes))))

dir.create("data", showWarnings = FALSE)
save(canva_palettes, file = "data/canva_palettes.rda")
