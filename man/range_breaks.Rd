\name{extended_range}
\alias{extended_range}
\alias{range_breaks}
\title{Pretty axis breaks inclusive of extreme values}
\usage{
extended_range(dmin, dmax, m, Q = c(1, 5, 2, 2.5, 4, 3), w = c(0.25, 0.2,
  0.5, 0.05))

range_breaks(n = 5, expand = c(0, 0), ...)
}
\arguments{
  \item{dmin}{minimum of the data range}

  \item{dmax}{maximum of the data range}

  \item{m}{desired number of axis labels}

  \item{Q}{set of nice numbers}

  \item{w}{weights applied to the four optimization
  components (simplicity, coverage, density, and
  legibility)}

  \item{n}{desired number of breaks}

  \item{...}{other arguments passed to
  \code{extended_range}}
}
\value{
vector of axis label locations
}
\description{
This function returns pretty axis breaks that always
include the extreme values of the data. This works by
calling the extended Wilkinson alogorithm (Talbot et. al,
2010), constrained to solutions interior to the data range.
Then, the minimum and maximum labels are moved to the
minimum and maximum of the data range.
}
\author{
Justin Talbot \email{jtalbot@stanford.edu}, Jeffrey B.
Arnold, baptise \email{baptiste.auguie@gmail.com}
}
\references{
Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of
Wilkinson's Algorithm for Positioning Tick Labels on Axes,
InfoVis 2010.
}
\seealso{
\code{\link{scale_y_tufte}}, \code{\link{scale_x_tufte}}
}

