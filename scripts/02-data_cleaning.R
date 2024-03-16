#### Preamble ####
# Purpose: Cleans the data from ces2020_raw.parquet
# Author: Renfrew Ao-Ieong, Rahma Binth Mohammad, Tam Ly
# Date: 11 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca, rahma.binthmohammad@mail.utoronto.ca, annatn.ly@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, arrow, the file: /data/analysis_data/ces2020_raw.parquet either from the repository or from running /scripts/01-download_data.R

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Clean data ####
# votereg: Are you registered to vote?
# cc20_410: For whom did you vote for President of the United States?
# gender: Are you…?
# race: What racial or ethnic group best describes you?
# gunown: Do you or does anyone in your household own a gun?

ces2020 <-
  read_parquet(
    "data/raw_data/ces2020_raw.parquet",
    col_types =
      cols(
        "votereg" = col_integer(),
        "CC20_410" = col_integer(),
        "gender" = col_integer(),
        "race" = col_integer(),
        "gunown" = col_integer()
      )
  )

ces2020 <-
  ces2020 |>
  filter(!is.na(gunown), votereg == 1,
         CC20_410 %in% c(1, 2)) |>
  mutate(
    voted_for = if_else(CC20_410 == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    gender = if_else(gender == 1, "Male", "Female"),
    gender = as_factor(gender),
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "Hispanic",
      race == 4 ~ "Asian",
      race == 5 ~ "Native American",
      race == 6 ~ "Middle Eastern",
      race == 7 ~ "Two or more races",
      race == 8 ~ "Other"
    ),
    race = factor(
      race,
      levels = c(
        "White",
        "Black",
        "Hispanic",
        "Asian",
        "Native American",
        "Middle Eastern",
        "Two or more races",
        "Other"
      )
    ),
    gun_ownership = case_when(
      gunown == 1 ~ "Personal",
      gunown == 2 ~ "Someone in the household",
      gunown == 3 ~ "No one in the household",
      gunown == 8 ~ "Not sure",
      TRUE ~ "No Answer"  # NA values, set to No Answer
    ),
    gun_ownership = factor(
      gun_ownership,
      levels = c(
        "Personal",
        "Someone in the household",
        "No one in the household",
        "Not sure",
        "No Answer"
      )
    ),
  ) |>
  select(voted_for, gender, race, gun_ownership)

ces2020

#### Save data ####
write_parquet(ces2020, "data/analysis_data/ces2020_analysis_data.parquet")
