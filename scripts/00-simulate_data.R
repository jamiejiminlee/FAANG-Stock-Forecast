#### Preamble ####
# Purpose: Simulates a dataset of FAANG stock prices
# Author: Jamie Lee
# Date: 30 November 2024
# Contact: jamiejimin.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? N/A


# Libraries
library(tidyverse)

# Set random seed for reproducibility
set.seed(42)

# Parameters for simulation
symbols <- c("META", "AMZN", "AAPL", "NFLX", "GOOGL")  # FAANG symbols
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

# Fix: Ensure 'symbol' is a factor with expected values
simulated_data$symbol <- factor(simulated_data$symbol, levels = c("META", "AMZN", "AAPL", "NFLX", "GOOGL"))

# Fix: Ensure 'date' is a Date object
simulated_data$date <- as.Date(simulated_data$date)

# View the simulated data
head(simulated_data)

#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")

