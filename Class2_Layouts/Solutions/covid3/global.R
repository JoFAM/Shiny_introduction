# A global file is a nice way of creating objects that are needed
# for both the server and the ui side. So the code needed by both
# can be added here.

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
