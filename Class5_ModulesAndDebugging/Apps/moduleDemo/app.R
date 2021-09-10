# USE the clickmodule
# Keep in mind the app is run from within the app directory!
source("clickModule.R")


ui <- fluidPage(
    titlePanel("ROLL SOME DICE"),
    sidebarLayout(
        sidebarPanel(
            # We use the UIs
            clickUI("diceroll1", "Roll dice 1"),
            clickUI("diceroll2", "Roll dice 2")
        ),
        mainPanel(
            span(textOutput("winner"),
                 style = "font-size:30px")
        )
    )
)

server <- function(input, output){
    
    dice1 <- clickServer("diceroll1")
    dice2 <- clickServer("diceroll2")
    
    output$winner <- renderText({
        dice1 <- dice1()
        dice2 <- dice2()
        win <- if(dice1 > dice2) "Dice 1" else 
            if(dice2 > dice1) "Dice 2" else "Everyone"
        paste("The winner is:", win)
    })
}

shinyApp(ui, server)
