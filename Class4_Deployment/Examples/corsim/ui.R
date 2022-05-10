library(shiny)
library(shinydashboard)

distributions <- c("Normal","Uniform","Exponential")


  dashboardPage(
    header = dashboardHeader(title = "Simulation of correlation"),
    sidebar = dashboardSidebar(
      selectInput("distx","distribution for X",
                  choices = distributions),
      selectInput("disty","distribution for Y",
                  choices = distributions),
      numericInput("nval","Number of observations",
                   min = 5, max = 1000,
                   value = 50),
      sliderInput("cor","Correlation",
                  min = -1, max = 1, step = 0.01,
                  value = 0)
    ),
    body = dashboardBody(
      plotOutput("corplot")
    )
  )

