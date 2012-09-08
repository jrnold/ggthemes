\name{theme_economist}
\alias{theme_economist}
\title{ggplot color theme based on the Economist}
\usage{
  theme_economist(base_size = 12, base_family = "",
    horizontal = TRUE, dkplot = FALSE)
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}

  \item{horizontal}{\code{logical}. Horizontal axis lines?}

  \item{dkplot}{\code{logical} Darker background for plot
  region?}
}
\description{
  Style plots similar to those in The Economist.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_economist()
               + scale_colour_economist() )
}
\seealso{
  Other themes: \code{\link{theme_solarized}},
  \code{\link{theme_stata}}
}

