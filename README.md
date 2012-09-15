# ggplotJrnold

Some extra themes and scales for [ggplot](http://had.co.nz/ggplot2/),

## Geoms

- Tufte range frame
- Tufte box plot

## Themes 

- Tufte minimal ink theme
- [Solarized](http://ethanschoonover.com/solarized)
- Stata themes 
- The Economist
- Excel (the ugly gray background one)

## Scales

- [Solarized](http://ethanschoonover.com/solarized) colors
- The Economist colors.
- Stata colors, shapes, and linetypes
- Excel colors (old and new)
- Tableau colors and shapes
- Shape scales from William S. Cleveland's *Elements of Graphing Data*,
  Tremmel (1995), and Lewandowsky and Spence (1989).

# Install 

It is probably easiest to use the **devtools** package to install the latest version:




```r
library("devtools")
install_github("ggplotJrnold", "jrnold")
```

# Examples


```r
library("ggplot2")
library("ggplotJrnold")
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
```


## Tufte theme and geoms

Minimal theme and geoms based on plots in *The Visual Display of
Quantitative Information*.


```r
(ggplot(mtcars, aes(wt, mpg)) + geom_point() + geom_rangeframe() + 
    theme_tufte())
```

![plot of chunk unnamed-chunk-3](http://i.imgur.com/38YrW.png) 


The Tufte minimal boxplot.


```r
(ggplot(mtcars, aes(factor(cyl), mpg)) + theme_tufte(ticks = FALSE) + 
    geom_tufteboxplot())
```

![plot of chunk unnamed-chunk-4](http://i.imgur.com/qRSvB.png) 


## Economist theme

A theme that approximates the style of plots in The Economist
magazine.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_economist() + 
    scale_colour_economist())
```

![plot of chunk unnamed-chunk-5](http://i.imgur.com/9tfDX.png) 


## Solarized theme

A theme and color and fill scales based on the Solarized palette.

The light theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized() + 
    scale_colour_solarized("blue"))
```

![plot of chunk unnamed-chunk-6](http://i.imgur.com/SIl8p.png) 


The dark theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized(light = FALSE) + 
    scale_colour_solarized("red"))
```

![plot of chunk unnamed-chunk-7](http://i.imgur.com/UNXzy.png) 


## Stata theme 

Themes and scales (color, fill, linetype, shapes) based on the graph
schemes in Stata.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_stata() + 
    scale_colour_stata() + ggtitle("Plot Title"))
```

![plot of chunk unnamed-chunk-8](http://i.imgur.com/wNUQK.png) 


## Excel 2003 theme

For that classic ugly look and feel. For ironic purposes only. 3D bars
and pies not included. Please never use this theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_excel2003() + 
    scale_colour_excel2003())
```

![plot of chunk unnamed-chunk-9](http://i.imgur.com/QHsOg.png) 



```r
(ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() + scale_fill_excel2003() + 
    theme_excel2003())
```

![plot of chunk unnamed-chunk-10](http://i.imgur.com/BRFfq.png) 


## Tableau Scales

Color, fill, and shape scales based on those used in the Tableau softare.





