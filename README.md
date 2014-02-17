


# ggthemes

Some extra geoms, scales, and themes for
[ggplot](http://had.co.nz/ggplot2/), including

## Geoms

- ``geom_rangeframe`` : Tufte's range frame
- ``geom_tufteboxplot``: Tufte's box plot

## Themes 

- ``theme_tufte``: a minimal ink based on Tufte's *The Visual Display of
Quantitative Information*.
- ``theme_solarized``: a theme using the [solarized](http://ethanschoonover.com/solarized) color palette.
- ``theme_stata``: themes based on [Stata](http://stata.com/) graph schemes.
- ``theme_economist``: a theme based on the plots in the [The Economist](http://www.economist.com/) magazine.
- ``theme_excel``: a theme replicating the classic ugly gray charts in Excel
- ``theme_wsj``: a theme based on the plots in the [The Economist](http://www.economist.com/) magazine.
- ``theme_few``: theme from Stephen Few's
  ["Practical Rules for Using Color in Charts"](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).
- ``theme_calc``: a theme based on LibreOffice Calc.
- ``theme_gdocs``: a theme based on Google Docs.

## Scales

- ``scale_color_solarized``: [Solarized](http://ethanschoonover.com/solarized) colors
- ``scale_color_economist``: colors used in plots in plots in *The Economist*.
- ``scale_color_stata``, ``scale_shapes_stata``, ``scale_linetype_stata``: color, shape, and linetype palettes from Stata graph schemes.
- ``scale_color_excel``: colors from new and old Excel.
- ``scale_color_tableau``, ``scale_shape_tableau``: color and shape palettes from [Tableau](http://www.tableausoftware.com/).
- ``scale_shape_cleveland``, ``scale_shape_tremmel``, ``scale_shape_circlefill``: shape scales from classic works in visual perception: Cleveland, Tremmel (1995), and Lewandowsky and Spence (1989).
- ``scale_color_few``: color palettes from Stephen Few's ["Practical Rules for Using Color in Charts"](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).
- ``scale_color_colorblind``: Colorblind safe palette from <http://jfly.iam.u-tokyo.ac.jp/color/>.
- ``scale_color_gdocs``: color palette from Google Docs.
- ``scale_color_calc``, ``scale_shape_calc``: color and shape palettes from LibreOffice Calc.
  
# Install 

To install the stable version from CRAN,

```r
install.packages('ggthemes', dependencies = TRUE)
```

Or, to install the development version from github, use the
**devtools** package,

```r
library("devtools")
install_github("ggthemes", "jrnold")
```

Windows users also must first install
[Rtools](http://cran.rstudio.com/bin/windows/Rtools/).

# Contribute

Contributions are welcome! If you would like to add a theme, scales,
etc., fork the repository, add your theme, and submit a pull request.

# Examples


```r
library("ggplot2")
library("ggthemes")
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
```


## Tufte theme and geoms

Minimal theme and geoms based on plots in *The Visual Display of
Quantitative Information*.


```r
(ggplot(mtcars, aes(wt, mpg)) + geom_point() + geom_rangeframe() + theme_tufte() + 
    scale_x_continuous(breaks = tufte_breaks(mtcars$wt), labels = as.character(tufte_breaks(mtcars$wt))) + 
    scale_y_continuous(breaks = tufte_breaks(mtcars$mpg), labels = as.character(tufte_breaks(mtcars$mpg))))
```

![plot of chunk tufte-rangeframe](http://i.imgur.com/KjCV720.png) 


The Tufte minimal boxplot.


```r
(ggplot(mtcars, aes(factor(cyl), mpg)) + theme_tufte(ticks = FALSE) + geom_tufteboxplot())
```

![plot of chunk tufteboxplot](http://i.imgur.com/PBskTXE.png) 


## Economist theme

A theme that approximates the style of plots in The Economist
magazine.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_economist() + scale_colour_economist() + 
    ggtitle("Diamonds Are Forever"))
```

![plot of chunk economist](http://i.imgur.com/7IPX6eG.png) 

==================
## Solarized theme

A theme and color and fill scales based on the Solarized palette.

The light theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized() + scale_colour_solarized("blue"))
```

![plot of chunk solarized-light](http://i.imgur.com/QcODKmj.png) 


The dark theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized(light = FALSE) + 
    scale_colour_solarized("red"))
```

![plot of chunk solarized-dark](http://i.imgur.com/YtLpIxP.png) 


An alternative theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_solarized_2() + scale_colour_solarized("blue"))
```

![plot of chunk solarized-alt](http://i.imgur.com/EiLK02F.png) 



## Stata theme 

Themes and scales (color, fill, linetype, shapes) based on the graph
schemes in Stata.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_stata() + scale_colour_stata() + 
    ggtitle("Plot Title"))
```

![plot of chunk stata](http://i.imgur.com/NVqdAU3.png) 


## Excel 2003 theme

For that classic ugly look and feel. For ironic purposes only. 3D bars
and pies not included. Please never use this theme.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_excel() + scale_colour_excel())
```

![plot of chunk excel1](http://i.imgur.com/HZGNCHx.png) 



```r
(ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() + scale_fill_excel() + 
    theme_excel())
```

![plot of chunk excel2](http://i.imgur.com/0wCRXmY.png) 


## Inverse Gray Theme

Inverse of `theme_gray`, i.e. white plot area and gray background.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray())
```

![plot of chunk igray](http://i.imgur.com/GeAaTr5.png) 



## Tableau Scales

Color, fill, and shape scales based on those used in the Tableau softare.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray() + scale_colour_tableau())
```

![plot of chunk tableau](http://i.imgur.com/zG7HoB9.png) 



```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_igray() + scale_colour_tableau("colorblind10"))
```

![plot of chunk tableau-colorbind10](http://i.imgur.com/mpVAgP9.png) 


## Stephen Few's Practical Rules for Using Color ...

Color palette and theme based on Stephen Few's ["Practical Rules for Using Color in Charts"](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf).


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_few() + scale_colour_few())
```

![plot of chunk few](http://i.imgur.com/3Q8GBm7.png) 


## Wall Street Journal

Theme and some color palettes based on plots in the *The Wall Street Journal*.


```r
(qplot(carat, price, data = dsamp, colour = cut) + theme_wsj() + scale_colour_wsj("colors6", 
    "") + ggtitle("Diamond Prices"))
```

![plot of chunk wsj](http://i.imgur.com/iakI2dk.png) 


## GDocs Theme

Theme and color palettes based on the defaults in Google Docs.


```r
(qplot(carat, price, data = dsamp, colour = clarity) + theme_gdocs() + ggtitle("Diamonds") + 
    scale_color_gdocs())
```

![plot of chunk gdocs](http://i.imgur.com/feNzIGo.png) 


## Calc Theme

Theme and color and shape palettes based on the defaults in LibreOffice Calc.


```r
(qplot(carat, price, data = dsamp, colour = clarity) + theme_calc() + ggtitle("Diamonds") + 
    scale_color_calc())
```

![plot of chunk calc](http://i.imgur.com/XxEhqFo.png) 


