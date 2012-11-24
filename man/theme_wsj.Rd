\name{theme_wsj}
\alias{theme_wsj}
\title{Wall Street Journal theme}
\usage{
  theme_wsj(base_size = 12, color = "gray",
    base_family = "sans", title_family = "Courier")
}
\arguments{
  \item{base_size}{Base font size.}

  \item{color}{The background color of plot. One of
  \code{"brown", "gray", "green", "blue"}, the names of
  values in \code{ggthemes_data$wsj$bg}.}

  \item{title_family}{Plot title font family.}

  \item{base_family}{Plot text font family.}
}
\description{
  Theme based on the plots in \emph{The Wall Street
  Journal}. Colloections of these plots can be found on the
  WSJ Graphics
  \href{https://twitter.com/WSJGraphics}{Twitter} feed and
  \href{http://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}.
}
\examples{
(qplot(hp, mpg, data=mtcars, geom="point")
 + theme_wsj())
## Use a gray background instead
(qplot(hp, mpg, data=mtcars, geom="point")
 + theme_wsj(color="brown"))
}

