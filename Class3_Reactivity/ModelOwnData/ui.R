# Exercise app Class 3

library(shiny)

# Create the side panel
sidepanel <- sidebarPanel(
    fileInput("file","Select a CSV file with data",
              accept = "text/csv"),
    uiOutput("varselect")
)

# Create the TABS

datatab <- tabPanel("Data",
                    dataTableOutput("datatable"))

histx <- tabPanel("Summary X variable",
                  plotOutput("histx"),
                  tableOutput("tablex"))

histy <- tabPanel("Summary Y variable",
                  plotOutput("histy"),
                  tableOutput("tabley"))
modpanel <- tabPanel("Model",
                     plotOutput("modplot"),
                     tableOutput("modtable"),
                     downloadButton("downplot","Download plot"))

# Define UI for application that draws a histogram
fluidPage(
    # Application title
    titlePanel("Make a simple linear model"),
    
    sidebarLayout(
        sidebarPanel = sidepanel,

        # Add the different panels here
        mainPanel(
            tabsetPanel(
                datatab,
                histx,
                histy,
                modpanel
            )
        )
    )
)
