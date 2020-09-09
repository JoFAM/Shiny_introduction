# The server function for the exercise
# ------------------------------------

function(input, output){
  
  #----------------------------
  # reactive values
  # Process the data. This needs to be a reactive value
  
  thedata <- reactive({
    read.csv(input$thefile$datapath)
  })
  
  #----------------------------
  # renders
  output$thetable <- renderDataTable({
    thedata()
  })
  
  
}
