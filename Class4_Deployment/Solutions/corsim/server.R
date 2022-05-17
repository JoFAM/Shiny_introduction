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
  
  n <- reactive({
    hideFeedback("nval")
    n <- input$nval
    req(input$nval)
    if(n < 0){
      showFeedbackDanger("nval","Negative observations don't make sense")
    } else if( n <= 5 || n > 1000){
      showFeedbackWarning("nval", "Observations should be between 5 and 1000")
    }
    
    validate(need( n > 5 && n <= 1000 ,
                   "Check your input for N"))
    n
  })
  
  x <- reactive({
    f <- getfun(input$distx)
    f(n())
  })
  
  simdata <- reactive({
    rho <- input$cor
    rho_ok <- rho > -1 && rho < 1
    feedbackWarning("cor", !rho_ok,
                    text = "Correlation should not be exactly (-)1")
    validate(need(rho_ok, "Check your input for Rho"))
    x <- x()
    f <- getfun(input$disty)
    tmp <- corsim(x,f(n()), rho)
    data.frame(x = x,
               y = tmp)
  })
  
  observeEvent({input$distx ; input$disty},{
    showNotification("Distribution changed")
  }, ignoreInit = TRUE)
  
  output$corplot <- renderPlot({
    pdata <- simdata()
    
    ggscatterhist(pdata, x = "x", y = "y",
                  margin.params = list(fill = "Red", 
                                       color = "black", 
                                       size = 0.2))
  
    
  })

})
