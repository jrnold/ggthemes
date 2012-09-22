\name{theme_economist}
\alias{theme_economist}
\title{ggplot color theme based on the Economist}
\usage{
  theme_economist(base_size = 10, base_family = "",
    horizontal = TRUE, dkpanel = FALSE, stata = FALSE)
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}

  \item{horizontal}{\code{logical}. Horizontal axis lines?}

  \item{dkpanel}{\code{logical} Darker background for panel
  region?}

  \item{stata}{\code{logical} Use RGB values from Stata's
  economist scheme.}
}
\description{
  Style plots similar to those in The Economist.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
q <- qplot(carat, price, data=dsamp, colour=clarity)
## Standard
q + theme_economist() + scale_colour_economist()
## Stata colors
q + theme_economist(stata=TRUE) + scale_colour_economist(stata=TRUE)
## Darker plot region
q + theme_economist(dkpanel=TRUE) + scale_colour_economist(stata=TRUE)
## Change axis lines to vertical
(q + theme_economist(horizontal=FALSE)
 + scale_colour_economist() + coord_flip()
 + ggtitle("Diamonds Are Forever"))
}
\seealso{
  Other themes: \code{\link{theme_excel2003}},
  \code{\link{theme_few}}, \code{\link{theme_igray}},
  \code{\link{theme_solarized}}, \code{\link{theme_stata}}
}

