# Make the tabs
plottab <- tabPanel(
  "the Plots",
  column(6, plotOutput("distPlot")),
  column(6, plotOutput("heatmap"))
)
summarytab <- tabPanel(
  "the Summary",
  tableOutput("thesummary")
)

# The UI
# I use shinyUI here, because I have some more code to run.
shinyUI(fluidPage(
  
  # Application title
  titlePanel("COVID data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("region",
                  "Choose a region",
                  choices = regions,
                  selected = regions[1]),
      selectInput("gender",
                  "Choose a gender",
                  choices = c("All","Female","Male"),
                  selected = "All"),
      sliderInput("daterange",
                  "Select a data range",
                  min = min(covid$DATE),
                  max = as.Date("2020-09-07"),
                  value = as.Date(c("2020-04-01","2020-09-01")))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        plottab,
        summarytab
      )
      
    )
  )
))
