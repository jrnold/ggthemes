\name{theme_excel2003}
\alias{theme_excel2003}
\title{ggplot color theme based on Excel 2003 plots}
\usage{
  theme_excel2003(horizontal = TRUE, base_size = 12,
    base_family = "")
}
\arguments{
  \item{base_size}{base font size}

  \item{base_family}{base font family}

  \item{horizontal}{\code{logical}. Horizontal axis lines?}
}
\description{
  Theme to replicate the ugly monstrosity that was the
  Excel 2003 chart. Please never use this for anything
  other than irony.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- qplot(carat, price, data=dsamp, colour=clarity)
               + theme_economist()
               + scale_colour_economist() )
}
\seealso{
  Other themes: \code{\link{theme_economist}},
  \code{\link{theme_solarized}}, \code{\link{theme_stata}}
}

