
library(shiny)
source("diceModule.R")
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("ROLL DEM DICE"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            diceUI("dice1","Roll dice 1"),
            diceUI("dice2", "Roll dice 2")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            # Insert text output twice
           textOutput("out")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    rdice1 <- diceServer("dice1")
    rdice2 <- diceServer("dice2")

        output$out <- renderText({
        d1 <- rdice1() 
        d2 <- rdice2()
        if(d1 > d2){
            "Dice 1 wins"
        } else if( d2 > d1){
            "Dice 2 wins"
        } else {
            "Everybody wins"
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
