library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Central Limit Theorem"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("n",
                        "Number of observations:",
                        min = 5,
                        max = 50,
                        value = 30),
            sliderInput("p",
                        "Number of samples",
                        min = 20, max = 1000,
                        value = 500),
            selectInput("dist",
                        "Select a distribution",
                        choices = c("Normal","Exponential",
                                    "Poisson"))
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("thehist")
        )
    )
)
