# THE MODULE FOR MY BEAVERS

# User interface for my module
slideplotUI <- function(id){
  ns <- NS(id)
  
  tagList(
    plotOutput(ns("theplot")),
    fluidRow(
      column(4, offset = 4,
             uiOutput(ns("slider"))
      )
  ))
}

# server side for my module
slideplotServer <- function(id, data, reactivecols){
  
  minmax <- range(data$tindex)
  
  servfun <- function(input, output, session){
    
    ns <- session$ns
    
    output$slider <- renderUI({
      sliderInput(ns("range"), "Select the X range", 
                  min = minmax[1],
                  max = minmax[2],
                  value = minmax)
    })
    
    output$theplot <- renderPlot({
      # generate bins based on input$bins from ui.R
      req(input$range)
      colid <- data$activ + 1
      cols <- reactivecols()
      
      ggplot(data, aes(x=tindex, y=temp)) + 
        geom_line(col = cols[colid], lwd = 2) +
        coord_cartesian(xlim = input$range) #Avoids warnings, contrary to lims() etc.
      
    })
    
  }
  
  moduleServer(id, servfun)
}
