
#' Launch Polymodal Spectrum Generator's Shiny App
#'
#' This function launches the Shiny app for the Polymodal Spectrum Generator
#' program
#'
#' @return No value, opens a Shiny page
#'
#' @examples
#' \dontrun{
#'
#' PolymodalSpectrumGenerator::runPSG()
#'
#'
#' @references
#' Winston Chang, Joe Cheng, JJ Allaire, Carson Sievert, Barret Schloerke, Yihui Xie, Jeff Allen, Jonathan McPherson, Alan Dipert and Barbara Borges (2021). shiny: Web Application
#'     Framework for R. R package version 1.7.1. https://CRAN.R-project.org/package=shiny
#'
#' @export
#' @importFrom shiny runApp

runPSG <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "PolymodalSpectrumGenerator")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}



