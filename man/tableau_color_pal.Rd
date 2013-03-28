\name{tableau_color_pal}
\alias{tableau_color_pal}
\title{Color Palettes based on Tableau (discrete)}
\usage{
  tableau_color_pal(palette = "tableau10")
}
\arguments{
  \item{palette}{Palette name:
  \Sexpr[results=rd,stage=build]{ggthemes::charopts(c(names(ggthemes_data$tableau$colors),
  c("tableau10", "tableau10light", "purplegray6",
  "bluered6", "greenorange6")))}}
}
\description{
  Color palettes used in
  \href{http://www.tableausoftware.com/}{Tableau}.
}
\examples{
library(scales)
show_col(tableau_color_pal("tableau20")(20))
show_col(tableau_color_pal("tableau10")(10))
show_col(tableau_color_pal("tableau10medium")(10))
show_col(tableau_color_pal("tableau10light")(10))
show_col(tableau_color_pal("colorblind10")(10))
show_col(tableau_color_pal("trafficlight")(10))
show_col(tableau_color_pal("purplegray12")(12))
show_col(tableau_color_pal("bluered12")(12))
show_col(tableau_color_pal("greenorange12")(12))
show_col(tableau_color_pal("cyclic")(20))
}
\references{
  \url{http://vis.stanford.edu/color-names/analyzer/}

  Maureen Stone, "Designing Colors for Data" (slides), at
  the International Symposium on Computational Aesthetics
  in Graphics, Visualization, and Imaging, Banff, AB,
  Canada, June 22, 2007
  \url{http://www.stonesc.com/slides/CompAe\%202007.pdf}.

  Heer, Jeffrey and Maureen Stone, 2012 "Color Naming
  Models for Color Selection, Image Editing and Palette
  Design", ACM Human Factors in Computing Systems (CHI)
  \url{http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf}.
}
\seealso{
  Other colour tableau: \code{\link{scale_color_tableau}},
  \code{\link{scale_colour_tableau}},
  \code{\link{scale_fill_tableau}}
}

