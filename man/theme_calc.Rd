\name{theme_calc}
\alias{theme_calc}
\title{Theme Calc}
\usage{
  theme_calc(base_size = 10, base_family = "sans")
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}
}
\description{
  Theme similar to the default settings of LibreOffice Calc
  charts.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
  + theme_calc())
}

