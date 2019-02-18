RSCRIPT = Rscript

all:

.PHONY: test
test: 
	$(RSCRIPT) -e 'devtools::check()'

.PHONY: docs
docs:
	$(RSCRIPT) -e 'devtools::build_docs()'

.PHONY: site
site:
	$(RSCRIPT) -e 'pkgdown::build_site()'
