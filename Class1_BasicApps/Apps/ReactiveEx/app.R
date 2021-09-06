# ILLUSTRATION REACTIVE VALUES
library(shiny)
# Define UI for a simple scatterplot
ui <- fluidPage(
    # Application title
    titlePanel("Example for reactive values"),
    # Sidebar with select inputs for distribution 
    sidebarLayout(
        sidebarPanel(
            selectInput("b1","distribution X", 
                        choices = c("norm","exp")),
            selectInput("b2","distribution Y", 
                        choices = c("norm","exp")),
        ), # END sidebarPanel
        # Show a plot of the generated distributions
        mainPanel(
           plotOutput("exPlot")
        ) # END mainPanel
    ) # END sidebarLayout
) # END fluidPage

# Server function
# You can uncomment the print() lines to see the order in which
# the code is executed by Shiny
server <- function(input, output) {
    
    x <- reactive({
#        print("I am creating X")
        f1 <- switch(input$b1, norm = rnorm, exp = rexp)
        f1(5)
    })
    
    y <- reactive({
#        print("I am creating Y")
        f1 <- switch(input$b2, norm = rnorm, exp = rexp)
        f1(5)
    })
    
    output$exPlot <- renderPlot({
#        print("I am creating the plot")
        plot(x(),y(), pch=16, col = "black", cex = 2)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
