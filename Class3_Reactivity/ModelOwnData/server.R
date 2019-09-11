# Exercise App class 3

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # Upload the data
    
    thedata <- reactive({
        req(input$file)
        fname <- input$file$datapath
        read.csv(fname)
    })
    
    # Create the table
    output$datatable <- renderDataTable({
        thedata()
    })
    
    # Create the UI to select the variables
    output$varselect <- renderUI({
        req(thedata())
        thevars <- names(thedata())
        tagList(
            selectInput("varx","Select the X variable",
                        choices = thevars),
            selectInput("vary","Select a Y variable",
                        choices = thevars)
        )
    })
    
    # reactive expr for x and y
    xdata <- reactive({
        req(input$varx)
        thedata()[[input$varx]]
    })
    
    ydata <- reactive({
        req(input$vary)
        thedata()[[input$vary]]
    })
    
    # Create the histograms and summaries
    output$histx <- renderPlot({
        hist(xdata(), col = "blue")
    })
    output$tablex <- renderTable({
        broom::tidy(summary(xdata()))
    })
    
    output$histy <- renderPlot({
        hist(ydata(), col = "green")
    })
    output$tabley <- renderTable({
        broom::tidy(summary(ydata()))
    })

})
