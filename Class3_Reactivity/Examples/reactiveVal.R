library(shiny)
ui <- fluidPage(
  actionButton("plus","Add five"),
  actionButton("minus", "substract five"),
  actionButton("diag","Show the dialog"),
  span(textOutput("res"),
       style = "font-size:30px;color:red")
)

server <- function(input, output){
  
  number <- reactiveVal(value = 10)
  
  observeEvent(input$plus,{
    newval <- number() + 5
    number(newval)
  })
  
  observeEvent(input$minus,{
    newval <- number() - 5
    number(newval)
  })
  
  observeEvent({input$diag},{
    showModal(modalDialog(
      title = "Important message",
      "This is how you see a dialog.",
      easyClose = TRUE
    ))
  })
  
  output$res <- renderText({
    paste("The result is",number())
  })
  
}
runApp(shinyApp(ui, server))
