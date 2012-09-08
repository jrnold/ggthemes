\name{theme_stata}
\alias{theme_stata}
\title{ggplot theme based on Stata graph schemes}
\usage{
  theme_stata(scheme = "s2color", base_size = 12,
    base_family = "")
}
\arguments{
  \item{scheme}{"s2color" or "s1color"}

  \item{base_size}{base font size}

  \item{base_family}{base font family}
}
\description{
  Theme which replicate Stata graph schemes.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(qplot(carat, price, data=dsamp, colour=clarity)
               + theme_stata()
               + scale_colour_stata("s2color"))
(qplot(carat, price, data=dsamp, colour=clarity)
               + theme_stata("s1color")
               + scale_colour_stata("s1color"))
}
\seealso{
  Other themes: \code{\link{theme_economist}},
  \code{\link{theme_excel2003}},
  \code{\link{theme_solarized}}
}

