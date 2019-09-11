# Exercise App class 3

library(shiny)
library(broom)
library(tibble)
library(ggplot2)

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
                        choices = thevars),
            actionButton("buildModel","Build model")
        )
    })
    
    # reactive expr for x and y
    xdata <- reactive({
        req(input$varx)
        out <- thedata()[[input$varx]]
        validate(need(is.numeric(out),
                      "Please choose a numeric variable"))
        out
    })
    
    ydata <- reactive({
        req(input$vary)
        out <- thedata()[[input$vary]]
        validate(need(is.numeric(out),
                      "Please choose a numeric variable"))
        out
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
    
    # Create the models
    
    pdata <- eventReactive(input$buildModel,{
        pdata <- tibble(x=xdata(),y=ydata())
    })
    
    output$modplot <- renderPlot({
        xname <- isolate(input$varx)
        yname <- isolate(input$vary)
        ggplot(pdata(), aes(x,y)) +
            geom_point() +
            geom_smooth(method = "lm") +
            labs(x = xname, y=yname)
            
    })
    
    themodel <- eventReactive(input$buildModel,{
        
        req(xdata(),ydata())
        
        formula <- paste(input$vary,input$varx,sep = "~")
        lm(formula, thedata())
    })
    
    output$modtable <- renderTable({
        broom::tidy(summary(themodel()))
    })

})