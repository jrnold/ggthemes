##' Wall Street Journal theme
##'
##' Theme based on the plots in \emph{The Wall Street Journal}.
##' Colloections of these plots can be found on the WSJ Graphics
##' \href{https://twitter.com/WSJGraphics}{Twitter} feed and
##' \href{http://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}.
##'
##' \pkg{ggthemes} does not currently have corresponding color and
##' fill scales for this theme. See the
##' \href{http://pinterest.com/wsjgraphics/wsj-graphics/}{Pinterest}
##' page or the
##' \href{https://github.com/jrnold/ggthemes/wiki/theme_wsj}{Github
##' wiki} for suitable palettes.
##'
##' @param base_size Base font size.
##' @param bgcolor One of \code{"brown", "gray", "green", "blue"}. The background color of
##' the plot.
##' @param title_family Plot title font family.
##' @param base_family Plot text font family.
##'
##' @examples
##' (qplot(hp, mpg, data=mtcars, geom="point")
##'  + theme_wsj())
theme_wsj <- function(base_size=12, bgcolor="brown", base_family="sans", title_family="serif") {

    bgcolorhex <- switch(bgcolor,
                         gray="#efefef",
                         green="#e9f3ea",
                         blue="#d4dee7",
                         brown="#f8f2e4") 
    (theme_base()
     + theme(
         line=element_line(linetype=1, colour="black"),
         rect=element_rect(fill=bgcolor, linetype=0, colour=NA),
         text=element_text(colour="black", family=base_family),
         title=element_text(family=title_family, size=rel(2)),
         axis.title=element_blank(),
         axis.text=element_text(face="bold", size=rel(1)),
         axis.text.x=element_text(colour=NULL),
         axis.text.y=element_text(colour=NULL),
         axis.ticks=element_line(colour=NULL),
         axis.ticks.y=element_blank(),
         axis.ticks.x=element_line(colour=NULL),
         axis.line=element_line(),
         axis.line.y=element_blank(),
         legend.background=element_rect(),
         legend.position="top",
         legend.direction="horizontal",
         legend.box="vertical",
         panel.grid=element_line(colour=NULL, linetype = 3),
         panel.grid.major=element_line(colour="black"),
         panel.grid.major.x=element_blank(),
         panel.grid.minor=element_blank(),
         plot.title=element_text(hjust=0, face="bold"),
         plot.margin = unit(c(1, 1, 1, 1), "lines"),
         strip.background=element_rect()))
}

