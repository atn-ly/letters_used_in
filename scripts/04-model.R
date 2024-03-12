#### Preamble ####
# Purpose: Models political preference based on their gender and race.
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
ces2020_cleaned <- read_parquet("data/analysis_data/ces2020_cleaned.parquet")

### Model data ####
set.seed(853)

# Randomly sample 1000 observations
ces2020_reduced <-
  ces2020_cleaned |> 
  slice_sample(n = 1000)

political_preferences <-
  stan_glm(
    voted_for ~ gender + race,
    data = ces2020_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )

#### Save model ####
saveRDS(
  political_preferences,
  file = "models/political_preferences.rds"
)
