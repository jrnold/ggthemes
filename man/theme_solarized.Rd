\name{theme_solarized}
\alias{theme_solarized}
\title{ggplot color theme based on the Solarized palette}
\usage{
  theme_solarized(base_size = 12, base_family = "",
    light = TRUE)
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}

  \item{light}{\code{logical}. Light or dark theme?}
}
\description{
  See \url{http://ethanschoonover.com/solarized} for a
  description of the Solarized palette.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_solarized()
               + scale_colour_solarized("blue"))
}
\seealso{
  Other themes: \code{\link{theme_economist}},
  \code{\link{theme_stata}}
}

