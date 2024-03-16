#### Preamble ####
# Purpose: Simulates a dataset where the chance that a person supports Trump depends on their gender, race, and gun ownership
# Author: Renfrew Ao-Ieong, Rahma Binth Mohammad, Tam Ly
# Date: 11 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca, rahma.binthmohammad@mail.utoronto.ca, annatn.ly@mail.utoronto.ca
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

#### Test simulated data ####
# Check number of observations
nrow(us_political_preferences) == 1000
# Check correct type gender
all(sapply(us_political_preferences$gender, is.character))
# Check Only two values in us_political_preferences$gender
length(unique(us_political_preferences$gender)) == 2
# Check correct values in us_political_preferences$gender
all(c("Male", "Female") %in% us_political_preferences$gender)

# Check correct type race
all(sapply(us_political_preferences$race, is.character))
# Check Only 2 values in us_political_preferences$race
length(unique(us_political_preferences$gender)) == 2
# Check correct values in us_political_preferences$race
all(c("White", "Not White") %in% us_political_preferences$race)

# Check correct type gun_ownership
all(sapply(us_political_preferences$gun_ownership, is.character))
# Check Only 2 values in us_political_preferences$gun_ownership
length(unique(us_political_preferences$gun_ownership)) == 2
# Check correct values in us_political_preferences$gun_ownership
all(c("Owns a gun", "Doesn't own a gun") %in% us_political_preferences$gun_ownership)

# Check correct type supports_trump
all(sapply(us_political_preferences$supports_trump, is.character))
# Check Only 2 values in us_political_preferences$supports_trump
length(unique(us_political_preferences$supports_trump)) == 2
# Check correct values in us_political_preferences$supports_trump
all(c("yes", "no") %in% us_political_preferences$supports_trump)
