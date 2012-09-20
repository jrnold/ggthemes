# ggplotJrnold

Some extra themes and scales for [ggplot](http://had.co.nz/ggplot2/),

## Geoms

- Tufte range frame
- Tufte box plot

## Themes 

- Tufte minimal ink theme
- [Solarized](http://ethanschoonover.com/solarized)
- [Stata](http://stata.com/) themes 
- [The Economist](http://www.economist.com/)
- Excel (the ugly gray background one)

## Scales

- [Solarized](http://ethanschoonover.com/solarized) colors
- The Economist colors.
- Stata colors, shapes, and linetypes
- Excel colors (old and new)
- [Tableau](http://www.tableausoftware.com/) colors and shapes
- Shape scales from William S. Cleveland's *Elements of Graphing Data*,
  Tremmel (1995), and Lewandowsky and Spence (1989).
- Color scale based on Stephen Few's ["Practical Rules for Using Color in Charts"](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).

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

![plot of chunk unnamed-chunk-3](http://i.imgur.com/ugn1m.png) 


The Tufte minimal boxplot.


```r
(ggplot(mtcars, aes(factor(cyl), mpg)) + theme_tufte(ticks = FALSE) + 
    geom_tufteboxplot())
```

![plot of chunk unnamed-chunk-4](http://i.imgur.com/wpHpV.png) 


## Economist theme

A theme that approximates the style of plots in The Economist
magazine.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_economist() + 
    scale_colour_economist() + ggtitle("Diamonds Are Forever"))
```

![plot of chunk unnamed-chunk-5](http://i.imgur.com/yYTRV.png) 


## Solarized theme

A theme and color and fill scales based on the Solarized palette.

The light theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized() + 
    scale_colour_solarized("blue"))
```

![plot of chunk unnamed-chunk-6](http://i.imgur.com/Pd3QU.png) 


The dark theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized(light = FALSE) + 
    scale_colour_solarized("red"))
```

![plot of chunk unnamed-chunk-7](http://i.imgur.com/2Nn7O.png) 


## Stata theme 

Themes and scales (color, fill, linetype, shapes) based on the graph
schemes in Stata.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_stata() + 
    scale_colour_stata() + ggtitle("Plot Title"))
```

![plot of chunk unnamed-chunk-8](http://i.imgur.com/Ommq8.png) 


## Excel 2003 theme

For that classic ugly look and feel. For ironic purposes only. 3D bars
and pies not included. Please never use this theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_excel2003() + 
    scale_colour_excel2003())
```

![plot of chunk unnamed-chunk-9](http://i.imgur.com/U8Dfn.png) 



```r
(ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() + scale_fill_excel2003() + 
    theme_excel2003())
```

![plot of chunk unnamed-chunk-10](http://i.imgur.com/BHX8v.png) 


## Inverse Gray Theme

Inverse of `theme_gray`, i.e. white plot area and gray background.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray())
```

![plot of chunk unnamed-chunk-11](http://i.imgur.com/2TWLG.png) 



## Tableau Scales

Color, fill, and shape scales based on those used in the Tableau softare.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray() + 
    scale_colour_tableau())
```

![plot of chunk unnamed-chunk-12](http://i.imgur.com/7DHn1.png) 



```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray() + 
    scale_colour_tableau("colorblind10"))
```

![plot of chunk unnamed-chunk-13](http://i.imgur.com/XLjKW.png) 


## Stephen Few's Practical Rules for Using Color ...

Color palette and theme based on Stephen Few's ["Practical Rules for Using Color in Charts"](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_few() + 
    scale_colour_few())
```

![plot of chunk unnamed-chunk-14](http://i.imgur.com/NkIH8.png) 


