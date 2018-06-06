library("tidyverse")
library("xml2")

# https://www.openoffice.org/xml/xml_specification.pdf
#
# LibreOffice colors can be found at
# https://design.blog.documentfoundation.org/2016/11/11/additions-to-libreoffice/
# Also see: https://community.kde.org/KDE_Visual_Design_Group/HIG/Color

#' @importFrom xml2 xml_attr
soc_process_color <- function(x) {
  list(name = xml_attr(x, "draw:name"),
       color = xml_attr(x, "draw:color"))
}


soc_process_color <- function(x) {
  tibble(name = xml_attr(x, "name"),
         value = xml_attr(x, "color"))
}

read_soc <- function(path) {
  name <- tools::file_path_sans_ext(basename(path))
  map_dfr(xml_find_all(read_xml(path), "draw:color"), soc_process_color)
}

palettes <-
  c("chart-palettes")
    #"freecolour-hlc",
    #"html",
    #"libreoffice",
    #"standard",
    #"tonal")

palette_url <- function(name) {
  str_c("https://raw.githubusercontent.com/LibreOffice/core/",
         "master/extras/source/palettes/", name, ".soc")
}

chart_palette <- read_soc(palette_url("chart-palettes"))

cat(yaml::as.yaml(chart_palette, column.major = FALSE))

