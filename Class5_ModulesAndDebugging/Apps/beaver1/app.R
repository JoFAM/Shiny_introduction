# Example with plotly
#

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
           plotOutput("timeplot"),
           fluidRow(
               column(4, offset = 4, uiOutput("slider"))
           )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$slider <- renderUI({
        minmax <- range(beaver1$tindex)
        sliderInput("range", "Select the X range", 
                    min = minmax[1],
                    max = minmax[2],
                    value = minmax)
    })

    output$timeplot <- renderPlot({
        # generate bins based on input$bins from ui.R
        req(input$range)
        colid <- beaver1$activ + 1
        cols <- c(input$colinactive, input$colactive)

        ggplot(beaver1, aes(x=tindex, y=temp)) + 
            geom_line(col = cols[colid], lwd = 2) +
            coord_cartesian(xlim = input$range) #Avoids warnings, contrary to lims() etc.

    })
}

# Run the application 
shinyApp(ui = ui, server = server)
