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

#' Read Open Office Color Palette Files
#'
#' Read the XML files (\code{.soc}) that Libre Office and Open Office use for
#' color palettes.
#'
#' @param path Path to xml file
#' @return A data frame with two columns
#' \tabulate{
#'   \code{name} \tab \tab{character} \tab Color name \cr
#'   \code{color} \tab \tab{character} \tab RGB HEX value
#' }
#'
#' @references
#' \url{https://github.com/LibreOffice/core/blob/master/extras/source/palettes/}
#' @export
#' @importFrom xml2 xml_find_all read_xml
read_soc <- function(path) {
  map(xml_find_all(read_xml(path), "draw_color"), process_color)
}

soc_process_color <- function(x) {
  tibble(color = xml_attr(x, "name"),
         rgb = xml_attr(x, "color"))
}

read_soc <- function(path) {
  name <- tools::file_path_sans_ext(basename(path))
  map_df(xml_find_all(read_xml(path), "draw:color"), soc_process_color) %>%
    mutate(name = name)
}

palettes <-
  c("chart-palettes",
    "freecolour-hlc",
    "html",
    "libreoffice",
    "standard",
    "tonal")

palette_url <- function(name) {
  str_c("https://raw.githubusercontent.com/LibreOffice/core/",
         "master/extras/source/palettes/", name, ".soc")
}

libre_office_palettes <-
  map(palettes, palette_url) %>%
  map_df(read_soc)
