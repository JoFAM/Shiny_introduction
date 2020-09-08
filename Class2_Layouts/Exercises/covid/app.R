
library(shiny)
library(ggplot2)

# Check if file is copied
if(!file.exists("Covid_20200907.csv"))
    stop("First copy the file Covid_20200907.csv into the app directory!")

covid <- read.csv("Covid_20200907.csv")
regions <- unique(covid$REGION)

# To get a Date on the X axis :
covid$DATE <- as.Date(covid$DATE)

# The UI
ui <- fluidPage(

    # Application title
    titlePanel("COVID data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("region",
                        "Choose a region",
                        choices = regions,
                        selected = regions[1]),
            selectInput("gender",
                        "Choose a gender",
                        choices = c("All","Female","Male"),
                        selected = "All"),
            sliderInput("daterange",
                        "Select a data range",
                        min = as.Date("2020-03-15"),
                        max = as.Date("2020-09-07"),
                        value = as.Date(c("2020-04-01","2020-09-01")))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    thedata <- reactive({
        # Select the region data
        id <- covid$REGION == input$region 
        covid[id, ]
    })
    
    output$distPlot <- renderPlot({
        thevar <- sym(input$gender)
        ggplot(thedata(), aes(x = DATE, y = !!thevar, fill = AGEGROUP)) +
            geom_col(width = 1) +
            scale_x_date(date_labels = "%b %d") + 
            coord_cartesian(xlim = input$daterange)
            
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
# DONE!
