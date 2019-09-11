# Exercise App class 3

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # Upload the data
    
    thedata <- reactive({
        fname <- input$file$datapath
        read.csv(fname)
    })
    
    # Create the table
    output$datatable <- renderDataTable({
        thedata()
    })

})
