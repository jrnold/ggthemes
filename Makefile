all: README.md

README.md: README.Rmd
	Rscript make-README.R $< $@
