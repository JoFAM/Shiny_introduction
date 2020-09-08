# Solution for the exercise on linear regression.
library(shiny)
library(ggplot2)

# the variable names
thevars <- names(iris)[-5]

#------------------
# UI
# Create the layout to add to the fluidPage

outputrow <- fluidRow(
  column(8,
         plotOutput("theplot")
         ), # END column1
  column(4,
         verbatimTextOutput("thesummary")
         ) # END column2
) 

inputrow <- fluidRow(
  column(4, align = "center",
         selectInput("var1",
                        label = "Select a variable",
                        choices = thevars)
         ), #END column 1
  column(4, align = "center",
         selectInput("var2",
                     label = "Select a second variable",
                     choices = thevars,
                     selected = thevars[2])
         ) # END column 2
)

# Combine into the UI
ui <- fluidPage(
  titlePanel("Exercise on linear regression"),
  outputrow,
  inputrow
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
