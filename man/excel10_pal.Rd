\name{excel10_pal}
\alias{excel10_pal}
\title{Excel Colors}
\usage{
  excel10_pal()
}
\description{
  Current Excel color palette. Color RGB values from
  \url{http://vis.stanford.edu/color-names/analyzer/}.
}
\examples{
library(scales)
show_col(excel10_pal()(10))
}
\seealso{
  \code{\link{excel2003_pal}} for an uglier color palette,
  and \code{\link{scale_colour_excel10}} for examples.
}

