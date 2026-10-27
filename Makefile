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

# Lint baseline: the hooks in .pre-commit-config.yaml are the single source of truth;
# these targets just run them.

# Install the git hooks (pre-commit and pre-push)
.PHONY: setup
setup:
	prek install

# Every check, including the slow pre-push ones
.PHONY: lint
lint:
	prek run --all-files
	prek run --all-files --hook-stage pre-push

# Apply fixes: formatters, then typos' safe fixes
.PHONY: fix
fix:
	-prek run --all-files
	-typos --write-changes

# Run one hook on every file, e.g. `make hook HOOK=lintr`
.PHONY: hook
hook:
	prek run $(HOOK) --all-files

.PHONY: style
style:
	./scripts/format

README.md: README.Rmd
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@", quiet = TRUE)'
