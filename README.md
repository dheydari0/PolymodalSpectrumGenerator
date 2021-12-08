
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PolymodalSpectrumGenerator

<!-- badges: start -->
<!-- badges: end -->

The goal of PolymodalSpectrumGenerator is to easily generate key
groupings of variants of interests in protein sequences. By inputing a
set of sequences, a consensus sequence, and indicating the desired
number of groupings, the package will return a plot of the desired
number of core variant groups, as well as visual representation of
position relative to other variants.

Developped using: - R version 4.1.1 (2021-08-10) – “Kick Things” -
x86\_64-w64-mingw32/x64 (64-bit) Windows

## Installation

You can install the development version of PolymodalSpectrumGenerator
like so:

``` r
require("devtools")
devtools::install_github("dheydari0/PolymodalSpectrumGenerator", build_vignettes = TRUE)
library("PolymodalSpectrumGenerator")
```

## Overview

``` r
ls("package:PolymodalSpectrumGenerator")
```

To use this package:

1.  Generate an MSA of protein sequences of interest in .fasta format
    (Clustal Omega)
2.  Generate a consensus sequence using (EMBOSS Cons)
3.  Input your files, input your desired number of groupings, and run

<div style="text-align:center">
<img src="./inst/extdata/+.png" width="600"/>
<div style="text-align:left">



## Contributions

This package made good use of the “msa” package, “An R Package for
Multiple Sequence Alignment” developed by Enrico Bonatesta, Christoph
Kainrath, and Ulrich Bodenhofer.

## References

Bodenhofer U, Bonatesta E, Horejs-Kainrath C, Hochreiter S (2015). “msa:
an R package for multiple sequence alignment.” Bioinformatics, 31(24),
3997–3999. doi: 10.1093/bioinformatics/btv494.

Madeira F, Park YM, Lee J, et al. The EMBL-EBI search and sequence
analysis tools APIs in 2019. Nucleic Acids Research. 2019
Jul;47(W1):W636-W641. DOI: 10.1093/nar/gkz268. PMID: 30976793; PMCID:
PMC6602479.

Murrell, P. (2005). R Graphics. Chapman & Hall/CRC Press.

Pagès H, Aboyoun P, Gentleman R, DebRoy S (2021). Biostrings: Efficient
manipulation of biological strings. R package version 2.62.0,
<https://bioconductor.org/packages/Biostrings>.

R Core Team (2021). R: A language and environment for statistical
computing. R Foundation for Statistical Computing, Vienna, Austria. URL
<https://www.R-project.org/>.

U. Bodenhofer, E. Bonatesta, C. Horejs-Kainrath, and S. Hochreiter
(2015). msa: an ˇ R package for multiple sequence alignment.
Bioinformatics 31(24):3997–3999. DOI: bioinformatics/btv494.

Winston Chang, Joe Cheng, JJ Allaire, Carson Sievert, Barret Schloerke,
Yihui Xie, Jeff Allen, Jonathan McPherson, Alan Dipert and Barbara
Borges (2021). shiny: Web Application Framework for R. R package version
1.7.1. <https://CRAN.R-project.org/package=shiny>

## Acknowledgements

This package was developed as part of an assessment for 2021 BCB410H:
Applied Bioinfor-matics, University of Toronto, Toronto, CANADA.
