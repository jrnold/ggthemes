### Name: scale_linetype_stata
### Title: Stata linetype palette (discrete)
### Aliases: scale_linetype_stata

### ** Examples

library("reshape2") # for melt
library("plyr") # for ddply
library("ggplot2")
ecm <- melt(economics, id = "date")
rescale01 <- function(x) {(x - min(x)) / diff(range(x))}
ecm <- ddply(ecm, "variable", transform, value = rescale01(value))
ggplot(ecm, aes(x = date, y = value, linetype=variable)) +
  geom_line() +
  scale_linetype_stata()



