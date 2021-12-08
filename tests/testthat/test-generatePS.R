library(PolymodalSpectrumGenerator)

test_that("Correct number of items added", {

  result <- generatePS("~/BCB410/PolymodalSpectrumGenerator/inst/extdata/aln-fasta.fasta",
            "~/BCB410/PolymodalSpectrumGenerator/inst/extdata/CONSENSUS.txt", N = 4)

  num = strtoi(substr(result, 18, 18))
  expect_equal(num, 2)

})
