# Create an app function
library(shiny)

# The function creates the app

ShowDensity <- function(color = "blue"){
  
  # First create the UI
  UI <- fluidPage(
    titlePanel("A simple Shiny app"),
    fluidRow(
      column(4, wellPanel(
        sliderInput("obs","Number observations",
                    min = 1, max = 200, value = 30)
      )),
      column(6, offset = 2,
             plotOutput("histplot"))
    )
  )
  
  # Then add the server
  servfun <- function(input, output){
    output$histplot <- renderPlot({
      samp <- rnorm(input$obs)
      dens <- density(samp)
      hist(samp, col = color, freq = FALSE)
      lines(dens)
    })
    
    # Make sure that the app ends when the window is closed
    onStop(stopApp)
  }
  
  # Now create the app
  theApp <- shinyApp(UI, servfun)
  # Run the app in a web browser
  runApp(theApp, launch.browser = TRUE)
}




