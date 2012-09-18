\name{economist_pal}
\alias{economist_pal}
\title{Economist color palette (discrete)}
\usage{
  economist_pal(stata = FALSE)
}
\arguments{
  \item{stata}{Use the palette in the Stata economist
  scheme.}
}
\description{
  Economist color palette (discrete)
}
\examples{
library(scales)
show_col(economist_pal()(10))
## RGB values from Stata's economist scheme
show_col(economist_pal(stata=TRUE)(16))
}

