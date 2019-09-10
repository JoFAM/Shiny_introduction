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

    output$regPlot <- renderPlot({
        
        symx <- sym(input$xvar)
        symy <- sym(input$yvar)
        
        ggplot(iris , aes(x = !!symx, y = !!symy)) +
            geom_point() + geom_smooth(method = "lm")
    })
    
    output$thesummary <- renderPrint({
        theformula <- as.formula(
            paste(input$yvar, input$xvar, sep = "~")
        )
        reg <- lm(theformula, data = iris)
        summary(reg)
    })
})
