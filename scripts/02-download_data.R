#### Preamble ####
# Purpose: Downloads and saves the data from Yahoo Finance API
# Author: Jamie Lee
# Date: 30 November 2024
# Contact: jamiejimin.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyquant R package
# Any other information needed? N/A


# Load libraries
library(tidyquant)
library(readr)

# Define FAANG tickers
faang_tickers <- c("META", "AMZN", "AAPL", "NFLX", "GOOGL")

# Download stock price data (Jan 2020 - Nov 2024)
raw_data <- tq_get(
  faang_tickers,
  from = "2020-01-01",
  to = "2024-11-30",
  get = "stock.prices"
)

# Save raw data
write_csv(raw_data, "data/01-raw_data/raw_data.csv")
         
