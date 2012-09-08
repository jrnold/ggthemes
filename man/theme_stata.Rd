\name{theme_stata}
\alias{theme_stata}
\title{ggplot theme based on Stata graph schemes}
\usage{
  theme_stata(scheme = "s2color", base_size = 12,
    base_family = "")
}
\arguments{
  \item{scheme}{One of "s2color", "s2mono", "s1color",
  "s1rcolor", or "s1mono"}

  \item{base_size}{base font size}

  \item{base_family}{base font family}
}
\description{
  Themes which replicate Stata graph schemes.
}
\note{
  Stata graph schemes include what ggplot seperates into
  themes and scales, as well as defaults specific to
  different graph types (which ggplot does not support).
  The theme "s2color" corresponds to Stata schemes
  "s2color" and "s2gcolor"; "s2mono" corresponds to Stata
  schemes "s2mono", "s2gmanual", and "sj"; "s1rcolor" to
  "s1rcolor"; "s1color" to "s1color"; "s1mono" to "s1mono"
  and "s1manual".
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(qplot(carat, price, data=dsamp, colour=clarity)
               + theme_stata()
               + scale_colour_stata("s2color"))
(qplot(carat, price, data=dsamp, colour=clarity)
               + theme_stata("s1color")
               + scale_colour_stata("s1color"))
(qplot(carat, price, data=dsamp, colour=clarity)
               + theme_stata("s1rcolor")
               + scale_colour_stata("s1rcolor"))
(qplot(carat, price, data=dsamp, colour=clarity)
+ theme_stata("s2mono")
+ scale_colour_stata("mono"))
(qplot(carat, price, data=dsamp, colour=clarity)
+ theme_stata("s1mono")
+ scale_colour_stata("mono"))
}
\references{
  \url{http://www.stata.com/help.cgi?schemes}
}
\seealso{
  Other themes: \code{\link{theme_economist}},
  \code{\link{theme_excel2003}},
  \code{\link{theme_solarized}}
}

