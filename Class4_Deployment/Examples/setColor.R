# A more elaborate example to create a plot
#
# This shows how a gadget can also take some input.

library(miniUI)
library(ggplot2)
library(dplyr)

makePlot <- function(data, var1, var2){
  
  colorUI <- miniButtonBlock(
    selectInput("col", "Pick a color",
                choices = c("red","green","blue")),
    height = "20%"
  )
  
  ui <- miniPage(
    gadgetTitleBar("A Plot example"),
    miniTabstripPanel(between = colorUI,
      miniTabPanel("Data", icon = icon("table"),
        miniContentPanel(           
        dataTableOutput("thedata")
                   )),
      miniTabPanel("Plot", icon = icon("area-chart"),
        miniContentPanel(
          plotOutput("theplot")
        ))
    )
  )
  
  server <- function(input, output, session){
    
    p <- reactive({
      ggplot(data, aes(x = {{var1}}, y = {{var2}})) +
        geom_point(col = input$col)
    })
    output$thedata <- renderDataTable({
      select(data, {{var1}}, {{var2}})
    })
    output$theplot <- renderPlot({
      p()
    })
    observeEvent(input$done, {
      plot <- p()
      stopApp(plot)
    })
  }
  runGadget(ui, server)
}