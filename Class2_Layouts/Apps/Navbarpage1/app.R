# This example shows the use of tabPanels in a navbarPage
#

library(shiny)
library(ggplot2)
library(broom)  # For cleaner output in the form of tibbles when using summary()
thevars <- names(iris)[1:4]

## CREATE THE PANELS SEPARATELY:

inputPanel <- tabPanel(
    "The inputs",
    column(6,
           selectInput("var", "Pick a variable",
                       choices = thevars)
           ),
    column(6,
           sliderInput("num", "number of bins",
                       min = 5, max = 15, value = 10)
           )
) # END inputPanel

plotPanel <- tabPanel(
    "The Plot",
    p("This tab shows the histogram."),
    plotOutput("histplot")
) # END plotPanel

summaryPanel <- tabPanel(
    "The summary",
    p("This tab shows the table output"),
    tableOutput("summaries")
) # END summaryPanel


# DEFINE THE UI
ui <- navbarPage(
    title = ("Layout examples for a navbarPage"),
    inputPanel,
    plotPanel,
    summaryPanel
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
