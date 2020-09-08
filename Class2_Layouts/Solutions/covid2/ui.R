# The UI code is run first, so you need to place all this code in the ui
# file in order to have a functioning application.

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)

# Check if file is copied
if(!file.exists("Covid_20200907.csv"))
  stop("First copy the file Covid_20200907.csv into the app directory!")

covid <- read.csv("Covid_20200907.csv")
regions <- unique(covid$REGION)

# To get a Date on the X axis :
covid$DATE <- as.Date(covid$DATE)

#------------------------------------
# Here starts the actual UI building
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
# I use shinyUI here, so RStudio recognizes this as an app file.
# But it's technically not necessary to do so.
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
