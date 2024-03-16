
#### Preamble ####
# Purpose: Tests for ces2020_analysis_data.parquet file
# Author: Renfrew Ao-Ieong, Rahma Binth Mohammad, Tam Ly
# Date: 15 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca, rahma.binthmohammad@mail.utoronto.ca, annatn.ly@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run the "02-data.cleaning.R" script to generate ces2020_analysis_data.parquet and "04-model.R to generate political_preferences.rds
# Note: To check dataset without checking model, comment out lines 20-21 and 61-82


#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Read data ####
ces2020_analysis_data <- read_parquet("data/analysis_data/ces2020_analysis_data.parquet")

#### Read model ####
political_preferences <-
  readRDS(file = here::here("models/political_preferences.rds"))

#### Test data ####
# Check dataset contains 43240 observations (for reproducibility)
nrow(ces2020_analysis_data) == 43240
# Check voted_for is a factor and includes Biden and Trump only
all(sapply(ces2020_analysis_data$voted_for, is.factor))
length(levels(ces2020_analysis_data$voted_for)) == 2
"Trump" %in% levels(ces2020_analysis_data$voted_for) && "Biden" %in% levels(ces2020_analysis_data$voted_for)

# Check gender is a factor only including 1 and 2 (Male, Female respectively)
all(sapply(ces2020_analysis_data$gender, is.factor))
length(levels(ces2020_analysis_data$gender)) == 2
"Male" %in% levels(ces2020_analysis_data$gender) && "Female" %in% levels(ces2020_analysis_data$gender)

# Check race is an factor [1-8] and all races in dataset are included
all(sapply(ces2020_analysis_data$race, is.factor))
length(levels(ces2020_analysis_data$race)) == 8

"White" %in% levels(ces2020_analysis_data$race) && 
  "Black" %in% levels(ces2020_analysis_data$race) &&
  "Hispanic" %in% levels(ces2020_analysis_data$race) &&
  "Asian" %in% levels(ces2020_analysis_data$race) &&
  "Native American" %in% levels(ces2020_analysis_data$race) &&
  "Middle Eastern" %in% levels(ces2020_analysis_data$race) &&
  "Two or more races" %in% levels(ces2020_analysis_data$race) &&
  "Other" %in% levels(ces2020_analysis_data$race)

# Check gun_ownership is an factor [1-4] and all categories in dataset are included
all(sapply(ces2020_analysis_data$gun_ownership, is.factor))
length(levels(ces2020_analysis_data$gun_ownership)) == 4
"Personal" %in% levels(ces2020_analysis_data$gun_ownership) && 
  "Someone in the household" %in% levels(ces2020_analysis_data$gun_ownership) &&
  "No one in the household" %in% levels(ces2020_analysis_data$gun_ownership) &&
  "Not sure" %in% levels(ces2020_analysis_data$gun_ownership)


### Test model output ###
# Check coefficients values are less than 20
# If ends up being this high, may need to check model
all(
  political_preferences$coefficients[1] < 20,
  political_preferences$coefficients[2] < 20,
  political_preferences$coefficients[3] < 20,
  political_preferences$coefficients[4] < 20,
  political_preferences$coefficients[5] < 20,
  political_preferences$coefficients[6] < 20,
  political_preferences$coefficients[7] < 20,
  political_preferences$coefficients[8] < 20
)
# Check coefficients values are greater than -20
# If ends up being this low, may need to check model
all(
  political_preferences$coefficients[1] > -20,
  political_preferences$coefficients[2] > -20,
  political_preferences$coefficients[3] > -20,
  political_preferences$coefficients[4] > -20,
  political_preferences$coefficients[5] > -20,
  political_preferences$coefficients[6] > -20,
  political_preferences$coefficients[7] > -20,
  political_preferences$coefficients[8] > -20
)


