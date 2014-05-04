all: README.md

README.md: README.Rmd
	Rscript -e 'library(knitr); knit("$<", output = "$@")'
