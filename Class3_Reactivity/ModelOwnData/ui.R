# Exercise app Class 3

library(shiny)

# Create the side panel
sidepanel <- sidebarPanel(
    fileInput("file","Select a CSV file with data",
              accept = "text/csv")
)

# Create the TABS

datatab <- tabPanel("Data",
                    dataTableOutput("datatable"))

# Define UI for application that draws a histogram
fluidPage(
    # Application title
    titlePanel("Make a simple linear model"),
    
    sidebarLayout(
        sidebarPanel = sidepanel,

        # Add the different panels here
        mainPanel(
            tabsetPanel(
                datatab
            )
        )
    )
)
