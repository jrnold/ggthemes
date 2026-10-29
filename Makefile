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

.PHONY: setup
setup:
	prek install

# Every check, including the slow pre-push ones; the hooks live in .pre-commit-config.yaml
.PHONY: lint
lint:
	prek run --all-files
	prek run --all-files --hook-stage pre-push

.PHONY: fix
fix:
	-prek run --all-files
	-typos --write-changes

# Run one hook on every file, e.g. `make hook id=lintr`
.PHONY: hook
hook:
	prek run $(id) --all-files

.PHONY: style
style:
	./scripts/format

README.md: README.Rmd
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@", quiet = TRUE)'
