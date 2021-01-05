## R CMD check notes

-   "Author field differs from that derived from Authors@R" is due to use of
    an ORCID identifier.

-   "found ... marked UTF-8 strings": The UTF strings are necessary to the package.
    They encode specific non-ASCII characters to use as symbols.

-   URLs from jstor.org and twitpic.com are valid but sometimes return status 
    391 or 503 due to redirection.
    
-   The URL https://policyviz.com/2017/01/12/150-color-palettes-for-excel/
    sometimes times out.
    
-   The URLs https://www.canva.com/learn/ return status 403 errors but are valid.

=   Highcharts JS is not

-   In `DESCRIPTION`, the words "Geoms", "Stata", "Tufte", "Tufte's", 
    and "geoms" are not mis-spelled.
