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
N = 5

findKeySeqs(MSAfilepath, Consensusfilepath, 5)

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

      AAnum <- AAnum + 1

    }

    print(matches)
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
graphNames <- c(substr(left, 4, 9)) #Left protein name (aka best match)

for(j in 1:nrow(matchings)) {

  if (matchings[j,]$i %in% maxStrengthIndices) {

    graphScores <- c(graphScores, matchings[j,]$pos)

    varName <- names(mySequenceFile[matchings[j,]$i])

    graphNames <- c(graphNames, substr(varName, 4, 9))

  }
}



#Right protein data (aka worst match)
graphScores <- c(graphScores, 1)
graphNames <- c(graphNames, substr(right, 4, 9))

library(grid)
grid.newpage()
grid.xaxis(at=graphScores,
           vp=vpStack(viewport(height=unit(2,"lines")),
                      viewport(y=1, xscale = c(-0.5, 1.5), just="top")))

}

#plot(graphScores)
#text(graphScores, labels=graphNames, cex= 5, pos='bottom')


#ADD DOTS
