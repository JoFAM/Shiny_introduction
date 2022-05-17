# Shows how you can change the position of the notification to eg top center.

library(shiny)

ui <- fluidPage(
    tags$head(
      tags$style("
#shiny-notification-panel {
  top: 0;
  bottom: unset;
  left: 0;
  right: 0;
  margin-left: auto;
  margin-right: auto;
  width: 100%;
  max-width: 450px;
}
             "
      )
    ),
    textInput("txt", "Text field", "Text on notification"),
    radioButtons("duration", "Seconds before fading out",
                 choices = c("2", "5", "10", "Never"),
                 inline = TRUE
    ),
    radioButtons("type", "Type",
                 choices = c("default", "message", "warning", "error"),
                 inline = TRUE
    ),
    actionButton("show", "Show")
  )

server <- function(input, output) {
    id <- NULL
    
    observeEvent(input$show, {
      if (input$duration == "Never")
        duration <- NA
      else 
        duration <- as.numeric(input$duration)
      
      type <- input$type
      if (is.null(type)) type <- NULL
      
      id <<- showNotification(
        input$txt,
        duration = duration, 
        closeButton = TRUE,
        type = type
      )
    })
    
    observeEvent(input$remove, {
      removeNotification(id)
    })
}

runApp(shinyApp(ui=ui, server = server))
