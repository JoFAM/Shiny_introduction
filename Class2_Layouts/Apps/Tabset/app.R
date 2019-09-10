# This example shows the use of tabPanels in a tabset
#

library(shiny)
library(ggplot2)
library(broom)  # For cleaner output in the form of tibbles when using summary()
thevars <- names(iris)[1:4]

# Define UI 
ui <- fluidPage(
    titlePanel("Layout examples for a tab set"),
    column(3,
           h3("Inputs - column width 3"),
           selectInput("var", "Pick a variable",
                       choices = thevars),
           sliderInput("num", "number of bins",
                       min = 5, max = 15, value = 10)
    ),
    column(9,
        h3("Column with Tabs"),
        hr(), # horizontal rule
        p("This example shows how to use tabsetPanel."),
        tabsetPanel(
            tabPanel("The Plot",
                     plotOutput("histplot"),
                     p("This tab shows the histogram.")),
            tabPanel("The summary",
                     tableOutput("summaries"),
                     p("This tab shows the table output"))
        ),
        hr(),
        strong("This text jumps up and down when you switch tabs. This shows
               that the fluid elements like tabs etc. don't have a fixed
               height. It adjusts to its content.")
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
    
    output$summaries <- renderTable({   # Transforms a data frame or tibble to table
        broom::tidy(summary(thedata()))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
