\docType{data}
\name{stata_symbols}
\alias{stata_symbols}
\title{Mapping from Stata Symbol Names to R shape numbers}
\format{Named \code{character} vector with the names corresponding
to a Stata symbol name, and the values corresponding to an R
shape.}
\usage{
  stata_symbols
}
\description{
  Character vector of the hex RGB values of the named
  colors in Stata. Useful for translating Stata schemes to
  ggplot themes. This mapping does not distinguish between
  small and large symbols. E.g. both "circle" and
  "smcircle" correspond to the R symbol 16.
}
\references{
  \url{http://www.stata.com/help.cgi?symbolstyle}
}
\keyword{datasets}

