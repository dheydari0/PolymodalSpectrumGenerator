# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#if (!requireNamespace("BiocManager", quietly=TRUE))
# install.packages("BiocManager")
#BiocManager::install("msa")

MSAfilepath = "~/BCB410/PolymodalSpectrumGenerator/R/aln-fasta.fasta"
Consensusfilepath = "~/BCB410/PolymodalSpectrumGenerator/R/CONSENSUS.txt"
N = 3

findKeySeqs <- function(MSAfilepath, Consensusfilepath, N) {

  library(msa) #To Test install

  mySequenceFile <- readAAStringSet(MSAfilepath) #Load MSA file in .fasta format
  myClustalAlignment <- msa(mySequenceFile, "ClustalOmega") # Read MSA, ClustalOmega version
  print(myClustalAlignment, showNames=TRUE, show="complete")  # Show just the alignment

  consens <- toString(readAAStringSet(Consensusfilepath))

  seqList <- list()

  i = 1
  while (i <= length(mySequenceFile)) {

    print(mySequenceFile[i])

    seqList[i] <- (toString(mySequenceFile[i]))

    i <- i + 1
  }


  consensAAs <- strsplit(consens, "")[[1]] # Split characters

  conSeqScores <- list()

  i <- 1

  while (i <= length(seqList)) { #Iterate through our given seqs
    splitseqs <- strsplit(seqList[[i]], "")[[1]]   #Split the string into AAs

    n = 1
    z <- 0

    for (AA in consensAAs) { #Iterate through each consesus seq AA

      if (splitseqs[n] == AA) { #Add to score for match
        z <- z + 1
      }

      n <- n + 1

    }

    conSeqScores[i] = z #Set score
    i <- i + 1

  }

  maxnum <- which.max(conSeqScores)

  minnum <- which.min(conSeqScores)

  maxMatch <- names(mySequenceFile)[maxnum] #Get nametag of best match

  minMatch <- names(mySequenceFile)[minnum] #Get nametag of worst match

  index <- c('Index')

  maxMatch <- c(0)

  minMatch <- c(0)

    i = 1
    while (i <= length(mySequenceFile)) {
      if (i != maxnum && i != minnum) {

        maxMatches <- 0
        minMatches <- 0

        splitseqs <- strsplit(seqList[[i]], "")[[1]] #split AAs of seq i
        maxAAs <- strsplit(seqList[[maxnum]], '')[[1]] #split AAs of Max
        minAAs <- strsplit(seqList[[minnum]], '')[[1]] #split AAs of Min


        n = 1
        for (AA in splitseqs) {

          if (AA == maxAAs[n]) {
            maxMatches <- maxMatches + 1
          }

          if (AA == minAAs[n]) {
            minMatches <- minMatches + 1
          }
          n <- n + 1
        }

        strength <- minMatches + maxMatches
        pos <- round(minMatches/strength, digits=2)

        matchings <- data.frame(i, maxMatches, minMatches, pos, strength)
      }

      i <- i + 1
    }
}

#Then run:

left <- names(mySequenceFile[maxnum])
right <- names(mySequenceFile[minnum])

cat("The left bound is the sequence: " , toString(left))

i = 1
while (i <= (N-2)) {
  data <- matchings[i,]

  cat("The third sequence lies at", matchings[i,]$pos, "(+ towards left)")

  i <- i + 1
}

cat("The right bound is the sequence: ", toString(right))

matchings


# Getting Indices to be Graphed by top Strength

for (i in 2:(N-1)) { # Loop until N-2 items have been added to Spectrum

  tempIndex <- 0 # placeholder
  maxStrengthValue <- 0 # max Strength iterator holder
  maxStrengthIndices <- c(-100) # List of the strongest indices

  for(j in 1:nrow(matchings)) {  #Loop over rows

    if (matchings[j,]$strength > maxStrengthValue) {

      if (matchings[j,]$i %in% maxStrengthIndices == FALSE) {

        tempIndex <- matchings[j,]$i

      }

    }

  }

  maxStrengthIndices <- c(maxStrengthIndices, tempIndex)

}

# maxStrengthIndices : vector of N-2 highest strengths

# Now, Get pos scores and names of these strongest ones

graphScores <- c(0)
graphNames <- c(substr(left, 4, 9)) #Left protein name (aka best match)

for(j in 2:nrow(matchings)) {

  if (matchings[j,]$i %in% maxStrengthIndices) {

    graphScores <- c(graphScores, matchings[j,]$pos)

    varName <- names(mySequenceFile[i])

    graphNames <- c(graphNames, substr(varName, 4, 9))

  }

}

#Right protein data (aka worst match)
graphScores <- c(graphScores, 1)
graphNames <- c(graphNames, substr(right, 4, 9))

plot(0, xlim = c(0, 3.5), axes=FALSE, type = "n", xlab = "", ylab = "") # Linedraw
axis(1, at = graphScores , labels = graphScores) # Linedraw




