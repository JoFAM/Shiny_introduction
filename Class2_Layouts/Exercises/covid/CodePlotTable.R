# Extra code for COVID
library(ggplot2)
library(dplyr)
library(tidyr)

covid <- read.csv("Exercises/covid/Covid_20200907.csv")
covid$DATE <- as.Date(covid$DATE)
# To create a heatmap

ggplot(covid, aes(x=DATE, y = AGEGROUP, fill = All)) +
  geom_tile() +
  scale_x_date(date_labels = "%b %d") +
  scale_fill_gradient(low = "white", high = "darkred") +
  theme_minimal()

# To create a summary

covid %>% 
  select(AGEGROUP, DATE, REGION, All) %>%
  filter(between(DATE, as.Date("2020-05-01"), as.Date("2020-07-01"))) %>%
  pivot_wider(names_from = "REGION",
              values_from = "All") %>%
  group_by(AGEGROUP) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE))
