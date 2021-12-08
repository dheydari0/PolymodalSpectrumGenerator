#' Generate the ui for the PolymodalSpectrumGenerator Shiny app.
#'
#' The UI contains the file input buttons and text input buttons to
#' get the input parameters required to run generatePS().
#'
#'
#' @return Output is an event, which should be input$submit1
#'
#' @references
#' Winston Chang, Joe Cheng, JJ Allaire, Carson Sievert, Barret Schloerke, Yihui Xie, Jeff Allen, Jonathan McPherson, Alan Dipert and Barbara Borges (2021). shiny: Web Application
#'     Framework for R. R package version 1.7.1. https://CRAN.R-project.org/package=shiny
#'
#'

ui <- fluidPage(

  # Webapp Title
  titlePanel(tags$h1(tags$b("PolymodalSpectrumGenerator:"),"")),

  # Left side bar
  sidebarLayout(

    # Sidebar Inputs
    sidebarPanel(
      tags$p("Identify anynumber of the strongest variants in a set of proteins,
             with a MSA (Multiple Sequence Alignment, in .fasta format),and a
             specified 'n', the number of groups you want identified."),

      tags$br(),

      #Closing
      tags$p("-------------------------------------------------"),


      #================== Input for function 1: generatePS()

      tags$h5("Use the following paramter inputs if you wish to use function generatePS()"),

      fileInput("fastaFILE", "Choose a .fasta input file for generatePS() ", accept = c("text/fasta",".fasta")),
      fileInput("consensusFILE", "Choose a .txt consensus file for generatePS() ", accept = c("text/plain",".txt")),
      textInput("n", "Enter the number of key varaints you want mapped", ""),

      #outputFile
      #fileInput("fileFunc1Out", "Choose the .csv output file for filterData() ", accept = c("text/csv", "text/comma-separated-values,text/plain",".csv")),

      #Closing


      tags$p("-------------------------------------------------"),



      # Submit Button
      actionButton(inputId = "submit1", label = "Submit"),

      br(),
      ),

      mainPanel(

      downloadButton("download", "Download Spectrum as .pdf"),

      tabsetPanel(type = "tabs", tabPanel("PolymodalSpectrum", plotOutput("plot"))

      )
    )
  )
)





# Server logic for Polymodal Spectrum Generator
server <- function(input, output) {

  #Submit button initiates this
  processInput <- eventReactive(eventExpr = input$submit1, {

      generatePS(input$fastaFILE$datapath, input$consensusFILE$datapath, strtoi(input$n))

  })

  # Display the plot/spectrum from generatePS
  output$plot <- renderPlot ({
    validate(need(input$n> 0, message=FALSE))
    processInput()$outputPlot
  })

}

shinyApp(ui = ui, server = server)

# [END]

