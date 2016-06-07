## ----header,echo=FALSE,results='hide'------------------------------------
library("knitr")
opts_chunk$set(fig.width = 5.25, fig.height = 3.75, cache=FALSE)

## ----dsamp---------------------------------------------------------------
library("ggplot2")
library("ggthemes")

p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  ggtitle("Cars")

p2 <- ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars")

p3 <- p2 + facet_wrap(~ am)



## ----tufte-rangeframe----------------------------------------------------
p + geom_rangeframe() +
  theme_tufte() + 
  scale_x_continuous(breaks = extended_range_breaks()(mtcars$wt)) +
  scale_y_continuous(breaks = extended_range_breaks()(mtcars$mpg))

## ----tufteboxplot--------------------------------------------------------
p4 <- ggplot(mtcars, aes(factor(cyl), mpg))

p4 + theme_tufte(ticks=FALSE) + geom_tufteboxplot()


## ----tufteboxplot2-------------------------------------------------------
p4 + theme_tufte(ticks=FALSE) +
  geom_tufteboxplot(median.type = "line")

## ----tufteboxplot3-------------------------------------------------------
p4 + theme_tufte(ticks=FALSE) +
  geom_tufteboxplot(median.type = "line", whisker.type = 'point', hoffset = 0)


## ----tufteboxplot4-------------------------------------------------------
p4 + theme_tufte(ticks=FALSE) +
  geom_tufteboxplot(median.type = "line", whisker.type = 'line', hoffset = 0, width = 3)


## ----economist-----------------------------------------------------------
p2 + theme_economist() + scale_colour_economist() 

## ----solarized-light-----------------------------------------------------
p2 + theme_solarized() +
  scale_colour_solarized("blue")

## ----solarized-dark------------------------------------------------------
p2 + theme_solarized(light = FALSE) +
  scale_colour_solarized("red")


## ----solarized-alt-------------------------------------------------------
p2 + theme_solarized_2(light = FALSE) +
  scale_colour_solarized("blue")


## ----stata---------------------------------------------------------------
p2 + theme_stata() + scale_colour_stata()
                             

## ----excel1--------------------------------------------------------------
p2 + theme_excel() + scale_colour_excel()


## ----excel2--------------------------------------------------------------
ggplot(diamonds, aes(x = clarity, fill = cut)) +
  geom_bar() +
  scale_fill_excel() +
  theme_excel()


## ----igray---------------------------------------------------------------
p2 + theme_igray()


## ----fivethirtyeight-----------------------------------------------------
p2 + geom_smooth(method = "lm", se = FALSE) +
  scale_color_fivethirtyeight("cyl") +
  theme_fivethirtyeight()


## ----paultol-------------------------------------------------------------
p2 + geom_smooth(method = "lm", se = FALSE) +
  scale_color_ptol("cyl",palette="ptol3_qual") +
  theme_fivethirtyeight()

## ----paultol-barplot-----------------------------------------------------
ggplot(diamonds, aes(x = clarity, fill = cut)) +
  geom_bar() +
  theme_fivethirtyeight() +
  scale_fill_ptol(palette="ptol5_qual")

## ----tableau-------------------------------------------------------------
p2 + theme_igray() + scale_colour_tableau()


## ----tableau-colorbind10-------------------------------------------------
p2 + theme_igray() + scale_colour_tableau("colorblind10")


## ----few-----------------------------------------------------------------
p2 + theme_few() + scale_colour_few()

## ----wsj-----------------------------------------------------------------
p2 + theme_wsj() + scale_colour_wsj("colors6", "")

## ------------------------------------------------------------------------
p2 + theme_base()

## ------------------------------------------------------------------------
par(fg = "blue", bg = "gray", col.lab = "red", font.lab = 3)
p2 + theme_par()

## ----gdocs---------------------------------------------------------------
p2 + theme_gdocs() + scale_color_gdocs()


## ----calc----------------------------------------------------------------
p2 + theme_calc() + scale_color_calc()

## ----pander-scatterplot--------------------------------------------------
p2 + theme_pander() + scale_colour_pander()
 

## ----pander-barplot------------------------------------------------------
ggplot(diamonds, aes(x = clarity, fill = cut)) +
  geom_bar() +
  theme_pander() +
  scale_fill_pander()
  

## ----hc-default----------------------------------------------------------
p2 + theme_hc() + scale_colour_hc()
 

## ----hc-darkunica--------------------------------------------------------
p2 + theme_hc(bgcolor = "darkunica") +
  scale_colour_hc("darkunica")

## ----dtemp---------------------------------------------------------------
dtemp <- data.frame(months = factor(rep(substr(month.name,1,3), 4), levels = substr(month.name,1,3)),
                    city = rep(c("Tokyo", "New York", "Berlin", "London"), each = 12),
                    temp = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6,
                             -0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5,
                             -0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0,
                             3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8))

## ----hc-default-line-----------------------------------------------------
ggplot(dtemp, aes(x = months, y = temp, group = city, color = city)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Monthly Average Temperature") +
  theme_hc() +
  scale_colour_hc()

## ----hc-darkunica-line---------------------------------------------------
ggplot(dtemp, aes(x = months, y = temp, group = city, color = city)) +
  geom_line() + 
  geom_point(size = 1.1) + 
  ggtitle("Monthly Average Temperature") +
  theme_hc(bgcolor = "darkunica") +
  scale_fill_hc("darkunica")

## ----map,message=FALSE---------------------------------------------------
library("maps")
us <- fortify(map_data("state"), region = "region")
ggplot() +
  geom_map(data  =  us, map = us,
           aes(x = long, y = lat, map_id = region, group = group),
           fill = "white", color = "black", size = 0.25) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  theme_map()


