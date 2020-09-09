# The user interface of the exercise
#-----------------------------------

# Create the tabs.

datatab <- tabPanel(
  "Uploaded Data",
  dataTableOutput("thetable")
)

# Create the sidebar and the main panel
side <- sidebarPanel(
  fileInput("thefile",
            "Select a csv file",
            accept = "text/csv")
)

main <- mainPanel(
  tabsetPanel(
    datatab
  )
)

# THIS COMBINES EVERYTHING
shinyUI(
  fluidPage(
    sidebarLayout(
      sidebarPanel = side,
      mainPanel = main
    )
  )
)
