
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#' Generates the Polymodal Spectrum
#'
#' With a filepath to the multiple sequence alignment, and consensus sequence
#' for a set of proteins, and a specified n, which is the number of desired
#' variants to be shown, the program returns of plot of the n most significant
#' varaints in the set.
#'
#' The variant which matches the consensus sequence the best is position at the
#' origin (0), and the variant which is the worst match with the consensus is at 1.
#' The other n - 2 variants are positioned based off of the relative number of
#' matches they have with the best and worst matches. The variants are also assigned
#' a strength, which is their number of matches with the best and worst, which is
#' used to give priority to the varaints with the most matches.
#'
#'
#' @param MSAfilepath A string representation of the filepath for the .fasta
#'                    file containing the aligned protein sequences
#' @param Consensusfilepath A string representation of the filepath for the
#'                          .txt file containing the protein consensus sequence
#' @param N The number of key variants you want to be visualized
#'
#' @return Output is a spectrum plot of the variants, position based on their
#'         relatedness, 0 being the variant most similar to the consensus, and 1
#'         being the variant with the fewest consensus matches
#'
#' @examples
#' \dontrun{
#' # For a set of aligned hemoglobin subunit proteins, map the relative positioning of the
#' 5 variants
#'
#' MSAfilepath = "~/BCB410/PolymodalSpectrumGenerator/inst/extdata/aln-fasta.fasta"
#' Consensusfilepath = "~/BCB410/PolymodalSpectrumGenerator/inst/extdata/CONSENSUS.txt"
#' N = 5
#'
#' generatePS(MSAfilepath, Consensusfilepath, N)
#'
#' @references
#' Bodenhofer U, Bonatesta E, Horejs-Kainrath C, Hochreiter S (2015). “msa: an R package for multiple sequence alignment.” Bioinformatics, 31(24), 3997–3999. doi: 10.1093/bioinformatics/btv494.
#' Murrell, P. (2005). R Graphics. Chapman & Hall/CRC Press.
#' Pagès H, Aboyoun P, Gentleman R, DebRoy S (2021). Biostrings: Efficient manipulation of biological strings. R package version 2.62.0, https://bioconductor.org/packages/Biostrings.
#' R Core Team (2021). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.
#' Winston Chang, Joe Cheng, JJ Allaire, Carson Sievert, Barret Schloerke, Yihui Xie, Jeff Allen, Jonathan McPherson, Alan Dipert and Barbara Borges (2021). shiny: Web Application
#'     Framework for R. R package version 1.7.1. https://CRAN.R-project.org/package=shiny
#'
#' @export
#' @import grid
#' @import msa
#' @import Biostrings

generatePS <- function(MSAfilepath, Consensusfilepath, N) {

  library(grid)
  library(msa)
  library(Biostrings)

  mySequenceFile <- readAAStringSet(MSAfilepath) #Load MSA file in .fasta format
  myClustalAlignment <- msa(mySequenceFile, "ClustalOmega") # Read MSA, ClustalOmega version

  #print(myClustalAlignment, showNames=TRUE, show="complete")  # Show just the alignment

  consens <- toString(readAAStringSet(Consensusfilepath))

  seqList <- list()

  i = 1
  while (i <= length(mySequenceFile)) {

    #print(mySequenceFile[i])

    seqList[[i]] <- (toString(mySequenceFile[i]))

    i <- i + 1
  }


  consensAAs <- strsplit(consens, "")[[1]] # Split characters

  conSeqScores <- list()

  i = 1
  for (i in 1:length(seqList)) { #Iterate through our given seqs
    splitseqs <- strsplit(seqList[[i]], "")[[1]]   #Split the string into AAs

    matches <- 0

    for (j in 1:min(length(splitseqs),length(consensAAs))) { #Iterate through each consesus seq AA

      if (splitseqs[j] == consensAAs[j]) { #Add to score for match
        matches <- matches + 1
      }

    }

    #print(matches)
    conSeqScores[i] = matches #Set score
  }

  maxnum <- which.max(conSeqScores)

  minnum <- which.min(conSeqScores)

  maxMatch <- names(mySequenceFile)[maxnum] #Get nametag of best match

  minMatch <- names(mySequenceFile)[minnum] #Get nametag of worst match

  index <- c()

  maxMatch <- c()

  minMatch <- c()

  pos <- c()

  strength <- c()

    i = 1
    while (i <= length(mySequenceFile)) {
      if (i != maxnum && i != minnum) {

        maxMatches <- 0
        minMatches <- 0

        splitseqs <- strsplit(seqList[[i]], "")[[1]] #split AAs of seq i
        maxAAs <- strsplit(seqList[[maxnum]], '')[[1]] #split AAs of Max
        minAAs <- strsplit(seqList[[minnum]], '')[[1]] #split AAs of Min


        for (j in 1:min(length(splitseqs),length(maxAAs), length(minAAs))) {


          if (splitseqs[j] == maxAAs[j]) {
            maxMatches <- maxMatches + 1
          }

          if (splitseqs[j] == minAAs[j]) {
            minMatches <- minMatches + 1
          }

        }


        strengthVal <- minMatches + maxMatches
        posVal <- round(minMatches/strengthVal, digits=2)



        index <- c(index, i)
        maxMatch <- c(maxMatch, maxMatches)
        minMatch <- c(minMatch, minMatches)
        pos <- c(pos, posVal)
        strength <- c(strength, strengthVal)
      }

      i <- i + 1
    }

    matchings <- data.frame(index, maxMatch, minMatch, pos, strength)


  # Getting Indices to be Graphed by top Strength

  maxStrengthIndices <- c() # List of the strongest indices
  maxStrengthStrengths <- c() # List of the strongest strengths

  for (i in 1:(N-2)) {
    maxStrengthIndices <- c(maxStrengthIndices, 0)
  }

  for (i in 1:(N-2)) {
    maxStrengthStrengths <- c(maxStrengthStrengths, 0)
  }


  for (i in 1:(N-2)) { # Loop until N-2 items have been added to maxStrengthIndices

    for(j in 1:nrow(matchings)) {  #Loop over rows

      minStrength <- min(maxStrengthStrengths)
      minStrengthIndex <- which.min(maxStrengthIndices)

      if (matchings[j,]$strength > minStrength) {

        maxStrengthStrengths[minStrengthIndex] = matchings[j,]$strength
        maxStrengthIndices[minStrengthIndex] = matchings[j,]$i

      }

    }

  }

  # maxStrengthIndices : vector of N-2 highest strengths

  # Now, Get pos scores and names of these strongest ones

  graphScores <- c(0)
  graphNames <- c(substr(names(mySequenceFile[maxnum]), 4, 9)) #Left protein name (aka best match)

  for(j in 1:nrow(matchings)) {

    if (matchings[j,]$i %in% maxStrengthIndices) {

      graphScores <- c(graphScores, matchings[j,]$pos)

      varName <- names(mySequenceFile[matchings[j,]$i])

      graphNames <- c(graphNames, substr(varName, 4, 9))

    }
  }



  #Right protein data (aka worst match)
  graphScores <- c(graphScores, 1)
  graphNames <- c(graphNames, substr(names(mySequenceFile[minnum]), 4, 9))
  graphLabel <- c()

  i <- 1
  for (item in graphScores) {

    label <- paste(toString(item), "\n", graphNames[i])
    i <- i + 1
    graphLabel <- c(graphLabel, label)
  }



  grid.newpage()

  grid.text(label = "PolymodalSpectrum", gp=gpar(fontsize=12, col='black'))

  grid.xaxis(at=graphScores, label=graphLabel,  gp=gpar(fontsize=8, col='black'),
             vp=vpStack(viewport(height=unit(2,"lines")),
                        viewport(y=1, xscale = c(-0.1, 1.05), just="top")))

}

#Example use! Files are included in inst so you can uncomment and run

#MSAfilepath = "~/BCB410/PolymodalSpectrumGenerator/inst/extdata/aln-fasta.fasta"
#Consensusfilepath = "~/BCB410/PolymodalSpectrumGenerator/inst/extdata/CONSENSUS.txt"
#N = 5

#generatePS(MSAfilepath, Consensusfilepath, N)


