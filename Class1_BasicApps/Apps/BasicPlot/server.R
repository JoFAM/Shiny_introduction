#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    x <- reactive({
        f <- switch(input$b1, norm = rnorm, exp = rexp)
        f(50)
    })
    y <- reactive({
        f <- switch(input$b2, norm = rnorm, exp = rexp)
        f(50)
    })
    
    output$myplot <- renderPlot({
        plot(x(), y(),
             pch = 20, col = "black")
        })

})
