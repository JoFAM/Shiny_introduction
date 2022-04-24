#
# Choose Plot
library(dplyr)
library(ggplot2)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("type",
                        "Plot type",
                        choices = c("hist","box")),
            selectInput("var",
                        "Select a var",
                        choices = c('Sepal.Width',"Petal.Width"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    histplot <- reactive({
        var <- sym(input$var)
        ggplot(iris, aes(y = !!var)) +
            geom_histogram(bins = 10)
    })
    
    boxplot <- reactive({
         var <- sym(input$var)
        ggplot(iris, aes(x = Species, y = !!var)) +
            geom_boxplot()
    })

    output$distPlot <- renderPlot({
        
        pltout <- switch(input$type,
                         hist = histplot,
                         box = boxplot)
        pltout()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
