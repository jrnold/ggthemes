## R CMD check notes

-   "Author field differs from that derived from Authors@R" is due to use of
    an ORCID identifier.

-   "found ... marked UTF-8 strings": The UTF strings are necessary to the package.
    They encode specific non-ASCII characters to use as symbols.

-   URLs from jstor.org and twitpic.com are valid but sometimes return status 
    391 or 503 due to redirection.
    
-   The URL https://policyviz.com/2017/01/12/150-color-palettes-for-excel/
    sometimes times out.

-   In `DESCRIPTION`, the words "Geoms", "Stata", "Tufte", "Tufte's", 
    and "geoms" are not mis-spelled.
    
-   The URLs https://www.canva.com/learn/ returns status 403 errors but are valid.

-   The URL https://twitter.com/WSJGraphics seometimes returns status 400 but is valid.

-   The URL http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf sometimes produces libcurl error 6 with message: "could not resolve host: www.perceptualedge.com" but is valid.
