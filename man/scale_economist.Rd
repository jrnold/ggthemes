\name{scale_colour_economist}
\alias{scale_colour_economist}
\alias{scale_fill_economist}
\title{Economist color scales}
\usage{
  scale_colour_economist(...)

  scale_fill_economist(...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}
}
\description{
  Color scales using the colors in the Economist graphics.
  These scales use RGB values and ordering of the colors in
  the State economist scheme.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_economist()
               + scale_colour_economist() )
}
\seealso{
  Other colour.scales:
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_fill_solarized}}
}

