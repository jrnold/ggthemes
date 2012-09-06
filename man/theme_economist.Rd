\name{theme_economist}
\alias{theme_economist}
\title{ggplot color theme based on the Economist}
\usage{
  theme_economist(base_size = 12, base_family = "",
    horizontal = TRUE, inner = FALSE)
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}
}
\description{
  Style plots similar to those in The Economist.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity) +
               + theme_economist()
               + scale_colour_economist() )
}
\seealso{
  Other res: \code{\link{scale_colour_economist}},
  \code{\link{scale_fill_economist}}
}

