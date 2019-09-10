library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    mysamples <- reactive({
        fdist <- switch(input$dist,
                        Normal = rnorm,
                        Exponential = rexp,
                        Poisson = function(n) rpois(n,4))
        replicate(input$p, fdist(input$n))
    })
    
    output$thehist <- renderPlot({
        hist(colMeans(mysamples()),
             col = "blue")
    })

})
