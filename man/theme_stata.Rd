\name{theme_stata}
\alias{theme_stata}
\title{ggplot theme based on Stata graph schemes}
\usage{
  theme_stata(scheme = "s2color", base_size = 11,
    base_family = "sans")
}
\arguments{
  \item{scheme}{One of "s2color", "s2mono", "s1color",
  "s1rcolor", or "s1mono", "s2manual", "s1manual", or "sj"}

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
  These themes should be used in conjunction with
  \code{\link{scale_colour_stata}}, see the examples.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
q1 <- (qplot(carat, price, data=dsamp, colour=clarity)
       + ggtitle("Diamonds"))
q2 <- (qplot(carat, price, data=dsamp)
       + facet_wrap(~ clarity)
       + ggtitle("Diamonds"))
q1mono <- (qplot(carat, price, shape=clarity, color=clarity,
           data=dsamp)
           + scale_shape_stata()
           + ggtitle("Diamonds"))
## s2color
(q1 + theme_stata() + scale_colour_stata("s2color"))
(q2 + theme_stata())
## s2mono
(q1mono + theme_stata("s2mono") + scale_colour_stata("mono"))
(q2 + theme_stata("s2mono"))
## s1color
(q1 + theme_stata("s1color") + scale_colour_stata("s1color"))
(q2 + theme_stata("s1color"))
\dontrun{
## s1rcolor
(q1 + theme_stata("s1rcolor") + scale_colour_stata("s1rcolor"))
(ggplot(dsamp, aes(x=carat, y=price)) + geom_point(colour="white")
 + facet_wrap(~ clarity) + scale_colour_stata("s1rcolor")
 + ggtitle("Diamonds"))
## s1mono
(q1mono + theme_stata("s1mono") + scale_colour_stata("mono"))
(q2 + theme_stata("s1mono"))
}
}
\references{
  \url{http://www.stata.com/help.cgi?schemes}
}

