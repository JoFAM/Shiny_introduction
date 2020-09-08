#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("MeanDistribution"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput("nobs",
                         "Number of observation",
                         min = 5, max = 50, step = 5,
                         value = 20),
            numericInput("nsamp",
                         "Number of samples",
                         min = 10, max = 1000, step = 10,
                         value = 500),
            selectInput("dist",
                        "Select a distribution",
                        choices = c("Normal","Exponential","Poisson"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    means <- reactive({
        
        distf <- switch(input$dist,
                        Normal = rnorm,
                        Exponential = rexp,
                        Poisson = function(x) rpois(x,4) )
        
        mysample <- replicate(input$nsamp, distf(input$nobs))
        colMeans(mysample)
    })
    
    output$distPlot <- renderPlot({
        hist(means())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
