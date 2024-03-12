#### Preamble ####
# Purpose: Downloads and saves data from CES 2020 (Cooperative Election Study Common Content, 2020)
# Author: Renfrew Ao-Ieong, Rahma Binth Mohammad, Tam Ly
# Date: 11 March 2024
# Contact: renfrew.aoieong@mail.utoronto.ca, rahma.binthmohammad@mail.utoronto.ca, annatn.ly@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, dataverse, arrow


#### Workspace setup ####
library(tidyverse)
library(dataverse)
library(arrow)

#### Download data ####
ces2020 <-
  get_dataframe_by_name(
    filename = "CES20_Common_OUTPUT_vv.csv",
    dataset = "10.7910/DVN/E9N6PH",
    server = "dataverse.harvard.edu",
    .f = read_csv
  ) |>
  select(votereg, CC20_410, gender, race, gunown)

#### Save data ####
write_parquet(ces2020, "data/raw_data/ces2020_raw.parquet")
