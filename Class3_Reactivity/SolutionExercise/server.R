# The server function for the exercise
# ------------------------------------

function(input, output){
  
  #----------------------------
  # reactive values
  # Process the data. This needs to be a reactive value
  counter <- reactiveVal(value = 0)
  
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
  
  output$thesummary <- renderPrint({
    summary(themodel())

  })
  
  # Make the plot only when the model is run
  modelplot <- eventReactive(input$Go,{
    symx <- sym(namex())
    symy <- sym(namey())
    ggplot(thedata(), aes(x = !!symx, y = !!symy )) +
      geom_point() +
      geom_smooth(method = "lm", formula = y ~ x)
  })
  
  output$modelplot <- renderPlot({
    modelplot()
  })
  
  # Downloads
  # reactive object with the output
  preds <- reactive({
    # The model should be present
    req(themodel())
    cbind(thedata()[c(namex(), namey())],
          predictions = predict(themodel()))
  })
  
  output$downloadpred <- downloadHandler(
    filename = "predictions.csv",
    content = function(x){
      write.csv(preds(), x, row.names = FALSE)
    }
  )
  
  output$downloadplot <- downloadHandler(
    filename = "plot.png",
    content = function(x){
      newval <- counter() + 1
      counter(newval)
      # Don't create a new file if not necessary
      # Keep in mind that this is tricky, as the download dialog
      # will still pop up.
      if(counter() < 2){
        ggsave(x,modelplot(), width = 6, height = 4)
      }
    }
  )
  
  # Observers
  # When the counter rises to 2, notify the user they did download already.
  observeEvent(counter(),{
    if(counter() > 1)
    showModal(modalDialog("You've downloaded the graph already.",
                          title = "Important!",
                          easyClose = TRUE))
  })
  # This resets the counter back to 0.
  observeEvent(input$Go,{
    counter(0)
  })
  
}
