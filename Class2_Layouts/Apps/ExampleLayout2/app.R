# This example shows the basic control of layout with fluidRow, column, ...
# It also shows use of html tags

library(shiny)
library(ggplot2)
library(broom)  # For cleaner output in the form of tibbles when using summary()
thevars <- names(iris)[1:4]

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Layout examples in a fluidPage"),
    fluidRow(
        h3("Row with output"),
        hr(), # horizontal rule
        p("This example shows how to use fluidRow to place things on
          different rows. The controls are now placed under the output."),
        column(6,plotOutput("histplot")),
        column(6,
               h4("Summary of the variable"),
               tableOutput("summaries")),
        p("Here I used two columns to put the histplot and the
          summaries next to eachother. Notice how this text is not placed
          on a new line. It still fits next to the first column, so in this
          case the fluidRow function places it next to the plot instead of
          underneath. To place this text under the two outputs, it should be
          in its own fluidRow(). You can try that out yourself.")
    ), # END fluidRow
    fluidRow(
        h3("Row with input, split in two columns"),
        hr(),
        column(4, 
               tags$em("Column width 4"),
               selectInput("var", "Pick a variable",
                           choices = thevars)
               ), #END column 4
        column(4, offset = 4, align = "right",
               tags$em("Column width 4 with offset"),
               sliderInput("num", "number of bins",
                           min = 5, max = 15, value = 10))
    )
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
        as.data.frame(t(as.matrix((summary(thedata())))))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
