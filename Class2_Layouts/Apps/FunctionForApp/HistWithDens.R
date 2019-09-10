# Create an app function
library(shiny)

# The function creates the app

ShowDensity <- function(){
  
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
      hist(samp, col = "blue", freq = FALSE)
      lines(dens)
    })
  }
  
  # Now create the app
  theApp <- shinyApp(UI, servfun)
  runApp(theApp, launch.browser = TRUE)
}




