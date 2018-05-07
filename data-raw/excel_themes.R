# Extract Color Schemes from Excel
#
# See
#
# -   https://support.office.com/en-us/article/change-a-theme-and-make-it-the-default-in-word-or-excel-c846f997-968e-4daa-b2d4-42bd2afef904?ui=en-US&rs=en-US&ad=US
# -   https://msdn.microsoft.com/en-us/library/cc964302(v=office.12).aspx
# -   https://support.office.com/en-us/article/open-xml-formats-and-file-name-extensions-5200d93c-3449-4380-8e11-31ef14555b18
#

library("xml2")
library("tidyverse")

theme_dir <- "/Applications/Microsoft Excel.app/Contents/Resources/Office Themes"
color_dir <- file.path(theme_dir, "Theme Colors")

themes <- dir(theme_dir, pattern = "\\.thmx$", full.names = TRUE)
color_themes <- dir(color_dir, pattern = "\\.xml$", full.names = TRUE)

process_color <- function(x) {
  name <- xml_name(x)
  clr <- xml_child(x)
  if (xml_name(clr) == "srgbClr") {
    val <- xml_attr(clr, "val")
  } else if (xml_name(clr) == "sysClr") {
    val <- xml_attr(clr, "lastClr")
  }
  set_names(list(val), name)
}

process_clrScheme <- function(path) {
  clrScheme <- xml_find_first(x, ".//a:clrScheme")
  scheme_name <- xml_attr(clrScheme, "name")
  browser()
  list(
    colors = flatten(map(xml_children(clrScheme), process_color)),
    url = scheme_url,
    name = scheme_name)
}

read_office_color_theme <- function(path) {
  process_clrScheme(xml_read(path))
}

read_thmx_colors <- function(path) {
  theme1 <- read_xml(unz(path, "theme/theme/theme1.xml"))
  read_office_color_theme(theme1)
}

map(themes, read_thmx_colors)
