# Extract Color Schemes from Excel
#
# Extract colors for all color themes on an installed version of Excel
# and save them to a YAML file.
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

thmx_files <- dir(theme_dir, pattern = "\\.thmx$", full.names = TRUE)
color_theme_files <- dir(color_dir, pattern = "\\.xml$", full.names = TRUE)

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

process_clrScheme <- function(x) {
  scheme_name <- xml_attr(x, "name")
  colors <- flatten_chr(map(xml_children(x), process_color))
  list(
    colors = list(
      accents = str_c("#",
                      unname(colors[str_subset(names(colors), "^accent")])),
      dk = str_c("#", unname(colors[c("dk1", "dk2")])),
      lt = str_c("#", unname(colors[c("lt1", "lt2")])),
      hlink = list(
        "default" = str_c("#", colors[["hlink"]]),
        "followed" = str_c("#", colors[["folHlink"]])
      )
    ),
    name = scheme_name
  )
}

read_office_color_theme <- function(path) {
  tree <- read_xml(path)
  process_clrScheme(xml_find_first(tree, "//a:clrScheme"))
}

read_thmx_colors <- function(path) {
  theme1 <- unz(path, "theme/theme/theme1.xml")
  read_office_color_theme(theme1)
}

themes <- c(map(thmx_files, read_thmx_colors),
            map(color_theme_files, read_office_color_theme))

names(themes) <- map_chr(themes, "name")
for (i in names(themes)) {
  themes[[i]] <- themes[[i]][["colors"]]
}

cat(as.yaml(themes),
    file = here("data-raw", "theme-data", "excel-themes.yml"))
