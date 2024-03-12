#### Preamble ####
# Purpose: Simulates a dataset where the chance that a person supports Trump depends on their gender, race, and gun ownership
# Author: Renfrew Ao-Ieong
# Date: 11 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(321)

num_obs <- 1000

us_political_preferences <- tibble(
  gender = sample(0:1, size = num_obs, replace = TRUE),
  race = sample(0:1, size = num_obs, replace = TRUE),
  gun_ownership = sample(0:1, size = num_obs, replace = TRUE),
  support_prob = ((gender + race + gun_ownership) / 3),
) |>
  mutate(
    supports_trump = if_else(runif(n = num_obs) < support_prob, "yes", "no"),
    race = if_else(race == 0, "Not White", "White"),
    gender = if_else(gender == 0, "Female", "Male"),
    gun_ownership = if_else(gun_ownership == 0, "Doesn't own a gun", "Owns a gun"),
  ) |>
  select(-support_prob, supports_trump, race, gender, gun_ownership)

us_political_preferences
