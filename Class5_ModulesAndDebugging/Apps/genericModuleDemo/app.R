# USE the clickmodule
# Keep in mind the app is run from within the app directory!
source("clickModule.R")

#----------------------------------------------------
# This example shows one way of starting a dynamic amount of
# modules based on input. This is an old (and painful)

ui <- fluidPage(
    titlePanel("ROLL SOME DICE"),
    sidebarLayout(
        sidebarPanel(
            # Select a number of dice to show.
            numericInput("ndice","Select a number of dice",
                         min = 2, max = 5, step = 1,
                         value = 2)
        ),
        mainPanel(
            fluidRow(
                uiOutput("alldice")
            ),
            span(textOutput("winner"),
                 style = "font-size:30px")
        )
    )
)

server <- function(input, output){
    
    # The dices will contain a bunch of REACTIVE OBJECTS! that are
    # linked to a module
    dices <- reactiveValues()
    
    # The diceid is a reactive value containing the IDs
    diceids <- reactiveVal()
    
    # We observe changes in ndice to create the outputs
    observeEvent(input$ndice,{
        # I create ID's based on the number of devices needed
        diceid <- paste0("thedice",seq.int(input$ndice))
        # These are stored in the reactive value
        diceids(diceid)
        
        # This creates all the dices UI's. 
        # mapply is a nice function to do this. It passes the arguments
        # pairwise to the function in the first argument. So I can
        # pass both the id and the label for each dice.
        output$alldice <- renderUI({
            tagList(
                mapply(clickUI,
                       diceid,
                       diceid,
                       SIMPLIFY = FALSE)
            )
        })
        
        # Here I call the module (since shiny 1.5 it's moduleServer,
        # but callModule still works if you want.) Note that I store
        # the result inside my reactive value list dices!
        for(i in diceid){
            dices[[i]] <- moduleServer(i,clickServer)
        }
        
    })
    
    output$winner <- renderText({
        
        # Here's the trick to get the values out.
        # I loop over all the dice id's, and use these values
        # to extract the reactive values from the reactive list.
        # Note that the values are in itself also reactive values,
        # so I need to extract the actual value using parentheses.
        dicevals <- unlist(lapply(diceids(),
                                  function(x) dices[[x]]() ))
        
        if(length(dicevals) < input$ndice | any(is.na(dicevals))){
            out <- "Roll ALL the dices!"
            print
        } else {
            
            win <- which(dicevals == max(dicevals))
            
            if(length(win) == 1){
                out <- paste("The winner is dice", win)
            } else {
                out <- paste("The winners are the dices ",
                      paste(win[-1], collapse = ", "),
                      "and", win[1])
            }
        }
        out
    })
}

shinyApp(ui, server)
