\name{scale_fill_solarized}
\alias{scale_color_solarized}
\alias{scale_colour_solarized}
\alias{scale_fill_solarized}
\title{Solarized color scales}
\usage{
  scale_fill_solarized(colors = NULL, ...)

  scale_colour_solarized(colors = NULL, ...)

  scale_color_solarized(colors = NULL, ...)
}
\arguments{
  \item{...}{Other arguments passed on to
  \code{\link{discrete_scale}} to control name, limits,
  breaks, labels and so forth.}

  \item{colors}{\code{character} vector of the names of
  Solarized colors to use and their order.}
}
\description{
  Accent color theme for Solarized. Primarily for use with
  \code{\link{theme_solarized}}.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_solarized()
               + scale_colour_solarized() )
}
\seealso{
  Other colour scales: \code{\link{scale_color_economist}},
  \code{\link{scale_color_stata}},
  \code{\link{scale_colour_economist}},
  \code{\link{scale_colour_stata}},
  \code{\link{scale_fill_economist}},
  \code{\link{scale_fill_stata}}
}

