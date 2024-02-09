RSCRIPT = Rscript

all: build

.PHONY: build
build: docs site data

.PHONY: test
test:
	$(RSCRIPT) -e 'devtools::check()'

.PHONY: docs
docs:
	$(RSCRIPT) -e 'devtools::document()'

.PHONY: site
site:
	$(RSCRIPT) -e 'pkgdown::build_site()'

.PHONY: data
data:
	$(RSCRIPT) data-raw/build.R

.PHONY: style
style:
	$(RSCRIPT) scripts/style.R
