##' Wall Street Journal theme
##'
##' Theme based on the
##'
##' @param base_family
##' @param base_size
##'
##' @examples
##' (qplot(hp, mpg, data=mtcars, geom="point")
##'  + theme_wsj())

theme_wsj <- function(base_size=12, base_family="sans", title_family="serif") {
    bgcolor <- "#F8F2E4" ## Brownish
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

