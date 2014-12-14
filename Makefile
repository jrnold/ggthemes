all: README.md

README = README.md
RMD_CHILDREN = $(wildcard vignettes/children/*.Rmd)

all: $(README)

$(README): $(README:%.md=%.Rmd) $(RMD_CHILDREN)
	Rscript make-README.R $< $@
