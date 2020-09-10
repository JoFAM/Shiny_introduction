# The user interface of the exercise
#-----------------------------------
library(shiny)
# Create the tabs.
#-------------------

datatab <- tabPanel(
  "Uploaded Data",
  dataTableOutput("thetable")
)

histtab <- tabPanel(
  "histograms",
  column(6, plotOutput("histX")),
  column(6, plotOutput("histY"))
)

modeltab <- tabPanel(
  "Model",
  verbatimTextOutput("themodel")
)

#----------------
# Create the sidebar and the main panel
#----------------
side <- sidebarPanel(
  fileInput("thefile",
            "Select a csv file",
            accept = "text/csv"),
  # Creates the selectInputs for the variables
  uiOutput("varselect")
)

main <- mainPanel(
  tabsetPanel(
    datatab,
    histtab,
    modeltab
  )
)

#--------------------------
# THIS COMBINES EVERYTHING
#---------------------------
shinyUI(
  fluidPage(
    sidebarLayout(
      sidebarPanel = side,
      mainPanel = main
    )
  )
)
