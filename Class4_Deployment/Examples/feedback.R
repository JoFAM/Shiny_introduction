library(shiny)
library(shinyFeedback)

ui <- fluidPage(
  useShinyFeedback(),
  numericInput("n2", "Give us a positive even number", value = 10),
  textOutput("choice")
)

server <- function(input, output){
  observeEvent(input$n2,{
    hideFeedback("n2")
    req(input$n2)
    if(input$n2 < 0){
      showFeedbackDanger("n2", "Negative number")
    } else if(input$n2 %% 2 != 0){
      showFeedbackWarning("n2", "Not an even number")
    } else {
      showFeedbackSuccess("n2", "Good choice")
    }
  })
  output$choice <- renderText({
    paste("You've chosen",input$n2)
  })
  
}

myApp <- shinyApp(ui, server)


