#### Preamble ####
# Purpose: Models political preference based on their gender, race, and gun ownership.
# Author: Renfrew Ao-Ieong, Rahma Binth Mohammad, Tam Ly
# Date: 10 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca, rahma.binthmohammad@mail.utoronto.ca, annatn.ly@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run the "02-data.cleaning.R" script.


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
ces2020_analysis_data <- read_parquet("data/analysis_data/ces2020_analysis_data.parquet")

### Model data ####
set.seed(321)

# Randomly sample 5000 observations in the interest of run-time
ces2020_reduced <- 
  ces2020_analysis_data |> 
  slice_sample(n = 5000)

political_preferences <-
  stan_glm(
    voted_for ~ gender + race + gun_ownership,
    data = ces2020_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 321
  )

#### Save model ####
saveRDS(
  political_preferences,
  file = "models/political_preferences.rds"
)
