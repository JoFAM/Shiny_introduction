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
            plotOutput("box_plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$box_plot <- renderPlot({
        
        # sym() converts a character to a symbol. This symbol is
        # the name of the variable selected
        
        grp <- sym(input$color_var)
        y <- sym(input$num_var)
        
        # !! is the unquote operator. This makes sure that ggplot doesn't
        # look for a variable grp in mtcars but for the variable that is
        # defined as a symbol by input$color_var
        
        ggplot(mtcars, 
               aes(y = !!y, x = as.factor(!!grp), 
                   fill = as.factor(!!grp) )) +
            geom_boxplot() +
            labs(y = input$num_var, x = input$color_var) +
            theme(text = element_text(size = 20))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
