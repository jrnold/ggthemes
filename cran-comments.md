This is a resubmission to fix the R CMD check problem:

```
* checking R code for possible problems ... NOTE
theme_par: no visible global function definition for 'par'
Undefined global functions or variables:
  par
Consider adding
  importFrom("graphics", "par")
to your NAMESPACE.
```

## R CMD check

* In `DESCRIPTION`, the words "Fivethirtyeight", "Geoms", "Stata", "Tufte", 
  "Tufte's", geoms", and "ggplot" are not mis-spelled.

* URLs http://www.jstor.org/stable/1390760, http://www.jstor.org/stable/2289649
  are valid but sometimes return status 391 or 503 due to redirection.
