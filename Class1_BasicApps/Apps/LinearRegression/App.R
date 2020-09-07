# Solution for the exercise on linear regression.
library(shiny)
library(ggplot2)

# the variable names
thevars <- names(iris)[-5]

#------------------
# UI
# Create the layout to add to the fluidPage

layout <- sidebarLayout(
  sidebarPanel = sidebarPanel(
    selectInput("var1",
                label = "Select a variable",
                choices = thevars),
    selectInput("var2",
                label = "Select a second variable",
                choices = thevars,
                selected = thevars[2])
  ), # END sidebarPanel
  mainPanel = mainPanel(
    plotOutput("theplot"),
    verbatimTextOutput("thesummary")
  ) # END mainPanel
)

# Combine into the UI
ui <- fluidPage(
  titlePanel("Exercise on linear regression"),
  layout
)

#------------------
# SERVER

server <- function(input, output){
  # input: var1, var2
  # output: theplot, thesummary
  
  # the plot
  output$theplot <- renderPlot({
    # Capture the symbols
    thevar1 <- sym(input$var1)
    thevar2 <- sym(input$var2)
    # Don't forget to unquote things here!
    ggplot(iris, aes(!!thevar1, !!thevar2)) +
      geom_point() +
      geom_smooth(method = "lm")
  })
  
  # the summary
  output$thesummary <- renderPrint({
    
    # This is one way to do it. It shows how you can 
    # create a formula based on a character value
    form <- paste(input$var2, input$var1, sep = " ~ ")
    form <- as.formula(form)

    mod <- lm(form, data = iris)
    summary(mod)
  })
  
}


shinyApp(ui = ui, server = server)
