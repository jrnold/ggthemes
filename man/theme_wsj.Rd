\name{theme_wsj}
\alias{theme_wsj}
\title{Wall Street Journal theme}
\usage{
  theme_wsj(base_size = 12, bgcolor = "brown",
    base_family = "sans", title_family = "serif")
}
\arguments{
  \item{base_size}{Base font size.}

  \item{bgcolor}{One of \code{"brown", "gray", "green",
  "blue"}. The background color of the plot.}

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
\details{
  \pkg{ggthemes} does not currently have corresponding
  color and fill scales for this theme. See the
  \href{http://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}
  page or the
  \href{https://github.com/jrnold/ggthemes/wiki/theme_wsj}{Github
  wiki} for suitable palettes.
}
\examples{
(qplot(hp, mpg, data=mtcars, geom="point")
 + theme_wsj())
}

