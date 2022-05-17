# BEAVERS APP.
library(shiny)
library(ggplot2)
source("plotModule.R")

# Prepare the data
data(beavers)

setindex <- function(time,day){
    time + max(time)* (day - min(day))
}

beaver1$tindex <- with(beaver1, setindex(time,day))
beaver2$tindex <- with(beaver2, setindex(time,day))

# THE ACTUAL APP

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
                         slideplotUI("beaver1")), # NEEDS SOMETHING
                tabPanel("Beaver 2",
                         slideplotUI("beaver2")) # NEED SOMETHING
            )
        )
    )
)

server <- function(input, output){
    
    thecols <- reactive({
        c(input$colinactive, input$colactive)
    })
    
    slideplotServer("beaver1", data = beaver1,
                    reactivecols = thecols)
    slideplotServer("beaver2", data = beaver2,
                    reactivecols = thecols)
}

shinyApp(ui, server)
