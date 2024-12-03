#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


# Libraries
library(dplyr)
library(lubridate)

# Set random seed for reproducibility
set.seed(42)

# Parameters for simulation
symbols <- c("FB", "AMZN", "AAPL", "NFLX", "GOOGL")  # FAANG symbols
start_date <- as.Date("2024-12-01")
end_date <- as.Date("2024-12-31")
dates <- seq.Date(start_date, end_date, by = "day")  # Dates for December 2024

# Simulate stock price data for each symbol
simulated_data <- expand.grid(date = dates, symbol = symbols) %>%
  arrange(symbol, date) %>%
  group_by(symbol) %>%
  mutate(
    # Simulate adjusted close price with a random walk process
    adjusted = cumprod(1 + rnorm(n(), mean = 0, sd = 0.02)) * 100,  # Starting at 100, random walk with 2% daily volatility
    # Simulate daily return
    daily_return = c(NA, diff(adjusted) / adjusted[-length(adjusted)])
  ) %>%
  ungroup()

# View the simulated data
head(simulated_data)

#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")

