\name{solarized_pal}
\alias{solarized_pal}
\title{Solarized color palette (discrete)}
\usage{
  solarized_pal(accent = "blue")
}
\arguments{
  \item{accent}{\code{character} Primary accent color.}
}
\description{
  Solarized accents palette from
  \url{http://ethanschoonover.com/solarized}. The colors
  chosen are the combination of colors that maximize the
  total Euclidean distance between colors in L*a*b space,
  given a primary accent.
}
\examples{
library(scales)
show_col(solarized_pal()(2))
show_col(solarized_pal()(3))
show_col(solarized_pal("red")(4))
}

