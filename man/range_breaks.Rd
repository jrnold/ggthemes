\name{extended_range_breaks}
\alias{extended_range_breaks}
\alias{scales_extended_range_breaks}
\title{Pretty axis breaks inclusive of extreme values}
\usage{
extended_range_breaks(dmin, dmax, n = 5, Q = c(1, 5, 2, 2.5, 4, 3),
  w = c(0.25, 0.2, 0.5, 0.05))

scales_extended_range_breaks(expand = c(0, 0), ...)
}
\arguments{
  \item{dmin}{minimum of the data range}

  \item{dmax}{maximum of the data range}

  \item{n}{desired number of breaks}

  \item{Q}{set of nice numbers}

  \item{w}{weights applied to the four optimization
  components (simplicity, coverage, density, and
  legibility)}

  \item{expand}{see \code{\link{scale_x_continuous}}.}

  \item{...}{other arguments passed to
  \code{extended_range_breaks}}
}
\value{
For \code{extended_range_breaks}, the vector of axis label
locations. For \code{scales_extended_range_breaks}, a
function which takes a single argument, a vector of data,
and returns the vector of axis label locations.
}
\description{
This function returns pretty axis breaks that always
include the extreme values of the data. This works by
calling the extended Wilkinson alogorithm (Talbot et. al,
2010), constrained to solutions interior to the data range.
Then, the minimum and maximum labels are moved to the
minimum and maximum of the data range.
}
\details{
\code{extended_range_breaks} implements the algorithm and
returns the break values.
\code{scales_extended_range_breaks} uses the conventions of
the \pkg{scales} package, and returns a function.
}
\author{
Justin Talbot \email{jtalbot@stanford.edu}, Jeffrey B.
Arnold, Baptiste Auguie
}
\references{
Talbot, J., Lin, S., Hanrahan, P. (2010) An Extension of
Wilkinson's Algorithm for Positioning Tick Labels on Axes,
InfoVis 2010.
}
\seealso{
\code{\link{scale_y_tufte}}, \code{\link{scale_x_tufte}}
}

