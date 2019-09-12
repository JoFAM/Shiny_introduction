# Example of a very basic gadget
library(shiny)
library(miniUI)
pickAcolor <- function(){
  
  ui <- miniPage(
    gadgetTitleBar("Select a color"),
    miniContentPanel(
      selectInput("col", "Pick a color",
                  choices = c("red","green","blue"))
    ))
  
  server <- function(input, output, session){
    observeEvent(input$done, {
      returnValue <- input$col
      stopApp(returnValue)
    })
  }
  runGadget(ui,server)
}