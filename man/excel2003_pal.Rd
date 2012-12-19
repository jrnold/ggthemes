\name{excel2003_pal}
\alias{excel2003_pal}
\title{Excel 2003 color palette (discrete)}
\usage{
  excel2003_pal(fill = FALSE)
}
\arguments{
  \item{fill}{\code{logical} Use the fill palette?}
}
\description{
  Color palettes from Excel 2003. For ironical purposes
  only.
}
\examples{
library(scales)
show_col(excel2003_pal()(8))
show_col(excel2003_pal(fill=TRUE)(8))
}
\seealso{
  Other colour excel: \code{\link{excel10_pal}},
  \code{\link{scale_color_excel10}},
  \code{\link{scale_color_excel2003}},
  \code{\link{scale_colour_excel10}},
  \code{\link{scale_colour_excel2003}},
  \code{\link{scale_fill_excel10}},
  \code{\link{scale_fill_excel2003}}
}

