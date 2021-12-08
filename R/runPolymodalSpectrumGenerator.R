


runTestingPackage <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "PolymodalSpectrumGenerator")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
