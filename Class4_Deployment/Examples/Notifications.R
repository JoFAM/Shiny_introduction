ui <- fluidPage(
  textOutput("text"),
  actionButton("go","Click for the model")
)

server <- function(input, output){
  output$text <- renderText({
    "Something"
  })
  
  observeEvent(input$go,{
    id <- showNotification("Clicked the button.",
                           duration = NULL,
                           closeButton = FALSE)
    on.exit(removeNotification(id))
    Sys.sleep(2)
    showNotification("Data is reading in", id = id,
                     duration = NULL,
                     closeButton = FALSE,
                     type = "error")
    Sys.sleep(2)
    showNotification("Building the model", id = id,
                     duration = NULL,
                     closeButton = FALSE,
                     type = "message")
    Sys.sleep(3)
    
  })
}

shinyApp(ui, server)