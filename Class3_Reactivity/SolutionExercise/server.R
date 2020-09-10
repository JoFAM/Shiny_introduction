# The server function for the exercise
# ------------------------------------

function(input, output){
  
  #----------------------------
  # reactive values
  # Process the data. This needs to be a reactive value
  
  thedata <- reactive({
    req(input$thefile$datapath)
    read.csv(input$thefile$datapath)
  })
  # To not have to use req() everywhere, you can use a reactive object:
  # These contain character values with the names of the variables.
  # Using the req() prevents downstream code from running when they're
  # not available yet.
  namex <- reactive({
    req(input$x)
    input$x
  })
  namey <- reactive({
    req(input$y)
    input$y
  })
  
  # eventReactive gives you a reactive object!
  themodel <- eventReactive(input$Go,{
    # This returns the model object
    form <- as.formula(paste(namey(), namex(), sep = " ~ "))
    lm(form, data = thedata())
  })
  
  #----------------------------
  # renders
  output$varselect <- renderUI({
    thevars <- names(thedata())
    
    tagList(
      selectInput("x","Select the X variable",
                  choices = thevars,
                  selected = thevars[1]),
      selectInput("y", "Select the Y variable",
                  choices = thevars,
                  selected = thevars[2]),
      actionButton("Go",
                   "Run the model")
    )
  })
  
  # Histograms
  output$histX <- renderPlot({
    thex <- thedata()[[namex()]]
    
    validate(need(is.numeric(thex),
                  "Please select a numeric X variable."))
    
    hist(thex,
         main = namex())
  })
  output$histY <- renderPlot({
    they <- thedata()[[namey()]]
    
    validate(need(is.numeric(they),
                  "Please select a numeric Y variable."))
    hist(they,
         main = namey())
  })
  
  # Data table
  output$thetable <- renderDataTable({
    thedata()
  })
  
  output$themodel <- renderPrint({
    summary(themodel())

  })
  
  
}
