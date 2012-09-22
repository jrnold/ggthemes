\name{stata_pal}
\alias{stata_pal}
\title{Stata color palettes (discrete)}
\usage{
  stata_pal(scheme = "s2color")
}
\arguments{
  \item{scheme}{\code{character}. One of "s2color",
  "s1rcolor", "s1color", or "mono".}
}
\description{
  Stata color palettes.  See Stata documentation for
  schemes: \url{http://www.stata.com/help.cgi?schemes}
}
\examples{
library(scales)
show_col(stata_pal("s2color")(15))
show_col(stata_pal("s1rcolor")(15))
show_col(stata_pal("s1color")(15))
show_col(stata_pal("mono")(15))
}

