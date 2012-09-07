\name{scale_colour_economist}
\alias{scale_color_economist}
\alias{scale_color_stata}
\alias{scale_colour_economist}
\alias{scale_colour_stata}
\alias{scale_fill_economist}
\alias{scale_fill_stata}
\title{Economist color scales}
\usage{
  scale_colour_economist(...)

  scale_color_economist(...)

  scale_fill_economist(...)

  scale_colour_stata(scheme = "s2", ...)

  scale_fill_stata(scheme = "", ...)

  scale_color_stata(scheme = "s2", ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{scheme}{\code{character}. One of "s2color",
  "s1rcolor", "s1color", or "mono".}
}
\description{
  Color scales using the colors in the Economist graphics.
  These scales use RGB values and ordering of the colors in
  the State economist scheme.

  Color scales using the color palettes from Stata.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_economist()
               + scale_colour_economist() )
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_bw()
               + scale_color_stata())
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_bw()
               + scale_color_stata("s1color"))
}
\seealso{
  Other colour scales: \code{\link{scale_color_solarized}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_fill_solarized}}

  Other colour scales: \code{\link{scale_color_solarized}},
  \code{\link{scale_colour_solarized}},
  \code{\link{scale_fill_solarized}}
}

