
library(shiny)
library(ggplot2)
thevars <- names(iris)[1:4] # contains the names of iris

# Define UI for application that draws a histogram
fluidPage(
    # Application title
    titlePanel("Iris Regression"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("xvar", label = "Choose X",
                        choices = thevars),
            selectInput("yvar", label = "Choose Y",
                        choices = thevars,
                        selected = thevars[2])
        ),

        # Show my regression
        mainPanel(
            plotOutput("regPlot")
        )
    )
)
