# Module for my dice
# User Interface
diceUI <- function(id, label = "Dice x"){
  # FIRST capture the namespace
  ns <- NS(id)
  
  # Create the output
  # 1. input actionbutton
  # 2. the output with the number
  tagList(
    actionButton(ns("roll"), label = label),
    textOutput(ns("res"))
  )
}

# Server side
diceServer <- function(id){
  
  servfun <- function(input, output, session){
    value <- eventReactive(input$roll,{
      sample(1:6, 1)
    })
    output$res <- renderText({
      paste("The dice has value",value())
    })
    return(value)
  }
  
  moduleServer(id, servfun)
}

