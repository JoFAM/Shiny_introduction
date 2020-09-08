# This example shows the basic control of layout with fluidRow, column, ...
# It also shows use of html tags

library(shiny)
library(ggplot2)

thevars <- names(iris)[1:4]

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Layout examples in a fluidPage"),
    fluidRow(
        column(3,                           
               h3("Column width 3"), #Header
               selectInput("var", "Pick a variable",
                           choices = thevars),
               sliderInput("num", "number of bins",
                           min = 5, max = 15, value = 10)
        ), # END column 3
        column(9,
               h3("Column width 9"),
               p("This example shows how you define the column width. It also
                  includes a number of examples of html tag functions, so you
                  get an idea of how things can be added."),
               plotOutput("histplot", width = "50%"),
               tableOutput("summaries"),
               p("Notice how even with a small width for the plot, the 
                  elements still get placed under each other. This is due to the
                  specific class of these widgets.")
        ) # END column 9
    ) # END fluidRow
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    thedata <- reactive({  # Gets a variable out of iris
        iris[[input$var]]
    })

    output$histplot <- renderPlot({
        
        x <- thedata() # Copy the reactive value so we don't have to 
                       # look it up multiple times.
        bins <- seq(min(x), max(x), length.out = input$num + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$histplot2 <- renderPlot({
        hist(iris$Sepal.Length)
    })
    
    # Transforms a data frame or tibble to table
    output$summaries <- renderTable({   
        as.data.frame(t(as.matrix(summary(thedata()))))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
