
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
#' FastRPA::runFastRPA()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp

runPSG <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "PolymodalSpectrumGenerator")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}



