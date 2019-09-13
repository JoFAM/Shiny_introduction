# The module for the plot

## UI side

rangeplotUI <- function(id, label = "Pick a range for the X axis"){
  ns <- NS(id)
  tagList(
    plotOutput(ns("timeplot")),
    fluidRow(
      column(4, offset = 4, uiOutput(ns("slider")))
    )
  )
}

## SERVER side

rangeplot <- function(input, output, session, dataset, cols){
  
  ns <- session$ns
  
  output$slider <- renderUI({
    minmax <- range(dataset$tindex)
    tagList(
    sliderInput(ns("range"), "Select the X range", 
                min = minmax[1],
                max = minmax[2],
                value = minmax)
    )
  })
  
  output$timeplot <- renderPlot({
    # generate bins based on input$bins from ui.R
    req(input$range)
    colid <- dataset$activ + 1
    cols <- cols()
    ggplot(dataset, aes(x=tindex, y=temp)) + 
      geom_line(col = cols[colid], lwd = 2) +
      coord_cartesian(xlim = input$range) #Avoids warnings, contrary to lims() etc.
})
  

}
