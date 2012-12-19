\name{excel_pal}
\alias{excel_pal}
\title{Excel color palette (discrete)}
\usage{
  excel_pal(palette = "line")
}
\arguments{
  \item{palette}{One of "old", "fill", or "new".}
}
\description{
  Color palettes from Excel, both current and the pre-2007
  ugly palettes.
}
\details{
  The color palettes are \describe{ \item{line}{Excel 2003
  default color palette.} \item{fill}{Excel 2003 bar chart
  color palette.} \item{new}{Color palette from newer Excel
  versions.} }
}
\examples{
library(scales)
show_col(excel_pal()(8))
show_col(excel_pal("fill")(8))
show_col(excel_pal("new")(10))
}

