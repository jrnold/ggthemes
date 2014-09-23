#!/bin/env Rscript
# Create README using version of package in the directory
args <- commandArgs(TRUE)
library(devtools)
dev_mode(on = TRUE, path = tempdir())
install(quick=TRUE)
library(ggthemes)
library(knitr)
knit(args[1], output = args[2])