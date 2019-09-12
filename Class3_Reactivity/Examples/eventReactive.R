# This script is an example script. 
# It builds a temporary shiny app and runs it.
# Source the script to see the app.

ui <- fluidPage(
  span(p("This application shows you how eventReactive works. Select two
         numbers and click on Calculate when you're done. Only then the
         sum will be updated."),
       style = "font-size:20px"),
  br(),
  hr(),
  actionButton("Go", "Calculate!"),
  sliderInput("n","select",min=1,max=10, value = 5),
  sliderInput("n2","select",min=1,max=10, value = 5),
  span(textOutput("out"), 
       style = "font-size:120px;color:red;font-style:bold")
)

# I use a span() here, which is an inline HTML container. This allows me
# to add a few CSS style commands that manipulate the textOutput.
# No other use than to flash some big red text :-)

server <- function(input,output){
  
  res <- eventReactive(input$Go,{
    input$n + input$n2
  }, ignoreNULL = FALSE)
  
  output$out <- renderText({
    paste("The sum is ", res())
  })
}
runApp(list(ui=ui, server=server))
