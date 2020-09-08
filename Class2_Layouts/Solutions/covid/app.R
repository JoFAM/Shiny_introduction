library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)

# Check if file is copied
if(!file.exists("Covid_20200907.csv"))
    stop("First copy the file Covid_20200907.csv into the app directory!")

covid <- read.csv("Covid_20200907.csv")
regions <- unique(covid$REGION)

# To get a Date on the X axis :
covid$DATE <- as.Date(covid$DATE)

# Make the tabs
plottab <- tabPanel(
    "the Plots",
    column(6, plotOutput("distPlot")),
    column(6, plotOutput("heatmap"))
)
summarytab <- tabPanel(
    "the Summary",
    tableOutput("thesummary")
)

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
                        min = min(covid$DATE),
                        max = as.Date("2020-09-07"),
                        value = as.Date(c("2020-04-01","2020-09-01")))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                plottab,
                summarytab
            )
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # FOR THE PLOTS
    thedata <- reactive({
        # Select the region data
        id <- covid$REGION == input$region 
        covid[id, ]
    })
    
    # I need this more often, but don't want to run it many times.
    # If you find yourself copy-pasting code, you need a reactive value!
    thevar <- reactive({sym(input$gender)})
    
    # CREATE THE SUMMARY
    output$thesummary <- renderTable({
        # This will be a vector with 2 dates, coming from the range
        datelims <- input$daterange
        # reactive values are called as a function! thevar() need parentheses
        covid %>% 
            select(AGEGROUP, DATE, REGION, !!thevar()) %>%
            filter(between(DATE, datelims[1], datelims[2])) %>%
            pivot_wider(names_from = "REGION",
                        # values_from needs a character value, so directly from input
                        values_from = input$gender) %>%
            group_by(AGEGROUP) %>%
            summarize(across(where(is.numeric), mean, na.rm = TRUE))
    })
    
    output$distPlot <- renderPlot({
        # reactive values are called as a function! thevar() need parentheses
        ggplot(thedata(), aes(x = DATE, y = !!thevar(), fill = AGEGROUP)) +
            geom_col(width = 1) +
            scale_x_date(date_labels = "%b %d") + 
            coord_cartesian(xlim = input$daterange)
    })
    
    output$heatmap <- renderPlot({
        # Use the same data thedata(), so we don't need to run it again.
        # reactive values are called as a function! thevar() need parentheses
        ggplot(thedata(), aes(x=DATE, y = AGEGROUP, fill = !!thevar())) +
            geom_tile() +
            scale_x_date(date_labels = "%b %d") +
            scale_fill_gradient(low = "white", high = "darkred") +
            theme_minimal() +
            # Add the coord_cartesian so we can use the same X axis as the other plot.
            coord_cartesian(xlim = input$daterange)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
# DONE!
