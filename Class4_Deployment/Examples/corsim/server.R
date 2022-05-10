# Server function
library(shiny)
library(ggplot2)
library(ggpubr)
source("corsim_function.R")

getfun <- function(x){
  switch(x,
         Normal = rnorm,
         Uniform = runif,
         Exponential = rexp)
}

shinyServer(function(input, output) {
  
  x <- reactive({
    f <- getfun(input$distx)
    f(input$nval)
  })
  
  simdata <- reactive({
    x <- x()
    f <- getfun(input$disty)
    tmp <- corsim(x,f(input$nval), input$cor)
    data.frame(x = x,
               y = tmp)
  })
  
  output$corplot <- renderPlot({
    pdata <- simdata()
    
    ggscatterhist(pdata, x = "x", y = "y",
                  margin.params = list(fill = "Red", color = "black", size = 0.2))
  
    
  })

})
