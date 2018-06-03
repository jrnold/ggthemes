---
output: markdown_doc
---

[![Build Status](https://travis-ci.org/jrnold/ggthemes.svg?branch=master)](https://travis-ci.org/jrnold/ggthemes)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/ggthemes)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/ggthemes)](http://cran.rstudio.com/web/packages/ggthemes)
[![Coverage status](https://codecov.io/gh/jrnold/ggthemes/branch/master/graph/badge.svg)](https://codecov.io/github/jrnold/ggthemes?branch=master)

```{r header,echo=FALSE,results='hide'}
knitr::opts_chunk$set(fig.width = 5.25,
               fig.height = 3.75,
               cache = FALSE,
               dev = 'png')
```

Some extra geoms, scales, and themes for
[ggplot](http://ggplot2.org), including:


## Install 

To install the stable version from CRAN,

```r
install.packages('ggthemes', dependencies = TRUE)
```

Or, to install the development version from github, use the
**devtools** package,

```r
library("devtools")
install_github(c("hadley/ggplot2", "jrnold/ggthemes"))
```
