# Example of a Module
#
source("rangeplotModule.R")

# Prepare the data
data(beavers)


setindex <- function(time,day){
    time + max(time)* (day - min(day))
}

beaver1$tindex <- with(beaver1, setindex(time,day))
beaver2$tindex <- with(beaver2, setindex(time,day))

# Libraries
library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Beaver body temperature"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("colactive",
                        "Color for active period:",
                        choices = c("red","green","blue")),
            selectInput("colinactive",
                        "Color for inactive period:",
                        choices = c("orange","black","purple"))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Beaver 1",
                         rangeplotUI("beaver1")),
                tabPanel("Beaver 2",
                         rangeplotUI("beaver2"))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    cols <- reactive({
        c(input$colinactive, input$colactive)
    })
    
    callModule(rangeplot,"beaver1", beaver1, cols)
    callModule(rangeplot,"beaver2", beaver2, cols)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
