# The simple module

clickUI <- function(id, label = "Click me!"){
  #FIRST capture the namespace
  ns <- NS(id)
  
  # Return a taglist with UI objects
  tagList(
    actionButton(ns("button"), label = label),
    span(textOutput(ns("res")),
         style = "font-size:30px")
  )
}



clickServer <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      value <- eventReactive(input$button,{
        sample(1:6, 1)
      })
      output$res <- renderText({
        paste("We rolled the dice and got:", value())
      })
      return(value)
    } #END function
  ) # END moduleServer
} # END clickServer


