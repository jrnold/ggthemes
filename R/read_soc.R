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
