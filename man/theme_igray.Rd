\name{theme_igray}
\alias{theme_igray}
\title{Inverse gray theme}
\usage{
  theme_igray(base_size = 12, base_family = "")
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}
}
\description{
  Inverts the colors in the \code{\link{theme_gray}}, a
  white panel and a light gray area around it. This keeps a
  white background, but with more gray, it keeps the plot
  closer to the typographical color of the document, which
  was the motivation for using a gray background in
  \code{theme_gray}. This is also the style of plots in
  Stata and Tableau.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_igray())
}
\seealso{
  Other themes: \code{\link{theme_economist}},
  \code{\link{theme_excel2003}}, \code{\link{theme_few}},
  \code{\link{theme_solarized}}, \code{\link{theme_stata}}
}

