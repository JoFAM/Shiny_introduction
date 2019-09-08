#
# This is a demo application to illustrate the basic parts
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("A demo app showing basic layout"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("num_var",
                        "Variable",
                        choices = c("mpg","wt","qsec")),
            selectInput("color_var",
                        "Groups",
                        choices = c("cyl","gear"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("boxPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$boxPlot <- renderPlot({
        
        pdata <- data.frame(
            x = mtcars[[input$num_var]],
            grp = as.character(mtcars[[input$color_var]])
        )
        
        ggplot(pdata, 
               aes(y = x, x = grp, fill = grp)) +
            geom_boxplot() +
            labs(y = input$num_var, x = input$color_var) +
            theme(text = element_text(size = 20))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
