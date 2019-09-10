
library(shiny)
library(ggplot2)
thevars <- names(iris)[1:4] # contains the names of iris

inputPanel <- 
    tabPanel("The Input",
    selectInput("xvar", label = "Choose X",
                choices = thevars, width = "20%"),
    selectInput("yvar", label = "Choose Y",
                choices = thevars,
                selected = thevars[2], width = "20%"))

navbarPage(
    title = "Showing the navbar page",
    inputPanel,
    navbarMenu("All Outputs",
               tabPanel("The Plot", plotOutput("regPlot")),
               tabPanel("The Summary", verbatimTextOutput("thesummary"))
               )
    ,
    collapsible = TRUE
)



# outputPanel <- navlistPanel(
#     tabPanel("The Plot", plotOutput("regPlot")),
#     tabPanel("The Summary", verbatimTextOutput("thesummary")),
#     selected = "The Summary"
# )




# Define UI for application that draws a histogram
# fluidPage(
#     # Application title
#     titlePanel("Iris Regression"),
#     h2("The output of the regression"),
#     outputPanel,
#     h2("The inputs"),
#     inputPanel
# )
