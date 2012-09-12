\docType{data}
\name{ggplotJrnoldPalettes}
\alias{ggplotJrnoldPalettes}
\title{Palette data for ggplotJrnold package}
\format{A \code{list}.
\describe{
\item{economist}{
Colors from The Economist magazine. RGB values taken from
the economist scheme in Stata. \code{bg} are background
colors, \code{fg} are foreground colors.
}
\item{excel}{
\code{list} Various Excel color palettes.
\code{excel2003} The Excel 2003 line color palette.
\code{excel2003fill} The Excel 2003 bar chart color palette.
\code{excel10} Color palette from more recent versions of Excel.
Color RGB values from \url{http://vis.stanford.edu/color-names/analyzer/}.
}
\item{solarized}{
Names and RGB values of the Solarized palette.
\url{http://ethanschoonover.com/solarized}.
\code{base} Base colors.
\code{accent} Accent colors.
}
\item{stata}{
Colors, shapes, and linetypes used by Stata
\code{colors} RBG values of of all Stata colors.
\code{shapes} R shape values of of all Stata symbol types.
\code{linetype} Equivalent R linepattern for all Stata linepattern sytles. \url{http://www.stata.com/help.cgi?symbolstyle}.
}
\item{few}{Qualitative color palettes from Stephen Few, \href{http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf}{"Practical Rules for Using Color in Charts"}. He suggests using \code{medium}, except for thin lines and small points, for which use \code{dark}.}
}}
\usage{
  ggplotJrnoldPalettes
}
\description{
  List with the data used by palettes in the ggplotJrnold
  package.
}
\keyword{datasets}

