#### Preamble ####
# Purpose: Cleans and prepares the raw FAANG stock data obtained from Yahoo Finance for predictive modeling
# Author: Jamie Lee
# Date: 30 November 2024
# Contact: jamiejimin.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: raw_data.csv
# Any other information needed? N/A

# Libraries
library(dplyr)
library(TTR)
library(arrow)

# Save raw data
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

# Generate placeholder dates for December
december_dates <- expand.grid(
  symbol = unique(raw_data$symbol),
  date = seq.Date(as.Date("2024-12-01"), as.Date("2024-12-31"), by = "day")
)

# Bind placeholder dates with raw_data
raw_data_extended <- raw_data %>%
  bind_rows(december_dates) %>%
  arrange(symbol, date)

# Interpolate and fill missing values in `adjusted`
raw_data_extended <- raw_data_extended %>%
  group_by(symbol) %>%
  mutate(
    adjusted = na.locf(adjusted, na.rm = FALSE),  # Forward fill
    adjusted = na.locf(adjusted, na.rm = FALSE, fromLast = TRUE)  # Backward fill
  ) %>%
  ungroup()

# Feature Engineering
analysis_data <- raw_data_extended %>%
  group_by(symbol) %>%
  mutate(
    Lag_1 = lag(adjusted, 1),
    Rolling_Mean_7 = rollmean(adjusted, 7, fill = NA, align = "right"),
    sma_20 = SMA(adjusted, n = 20),
    sma_50 = SMA(adjusted, n = 50),
    volatility = runSD(adjusted, n = 20),
    daily_return = (adjusted / lag(adjusted)) - 1
  ) %>%
  ungroup() %>%
  mutate(
    symbol_encoded = as.numeric(as.factor(symbol)),
    across(Lag_1:daily_return, ~ ifelse(is.na(.), 0, .))  # Handle remaining missing values
  )

# Save cleaned data
write_parquet(analysis_data, "data/02-analysis_data/analysis_data.parquet")

