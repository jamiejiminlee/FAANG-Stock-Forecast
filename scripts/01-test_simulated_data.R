#### Preamble ####
# Purpose: Tests simulated_data.csv
# Author: Jamie Lee
# Date: 30 November 2024
# Contact: jamiejimin.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - 'testthat' package must be loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? N/A

# Libraries
library(testthat)
library(dplyr)

# Load the simulated data
simulated_data <- read.csv("data/00-simulated_data/simulated_data.csv")

# Test 1: Check if the dataset is not empty
test_that("Dataset is not empty", {
  expect_true(nrow(simulated_data) > 0, "The dataset is empty.")
})

# Test 2: Check if necessary columns are present
test_that("Necessary columns are present", {
  expect_true(all(c("symbol", "date", "adjusted", "daily_return") %in% colnames(simulated_data)),
              "One or more required columns are missing.")
})

# Test 3: Check for missing values in critical columns
test_that("No missing values in critical columns", {
  expect_true(all(!is.na(simulated_data$adjusted)), "There are missing values in 'adjusted' column.")
  expect_true(all(!is.na(simulated_data$daily_return)), "There are missing values in 'daily_return' column.")
})

# Test 4: Ensure that daily_return is valid (no NA or Inf values)
test_that("Daily return has no NA or Inf values", {
  invalid_daily_return <- simulated_data %>%
    filter(is.na(daily_return) | is.infinite(daily_return))
  
  expect_true(nrow(invalid_daily_return) == 0, "There are invalid values (NA or Inf) in the 'daily_return' column.")
})

# Test 5: Ensure adjusted price is positive
test_that("Adjusted price is positive", {
  expect_true(all(simulated_data$adjusted > 0), "There are non-positive values in 'adjusted' column.")
})

# Test 6: Ensure `symbol` column has the expected unique values
test_that("Correct unique symbols", {
  expected_symbols <- c("META", "AMZN", "AAPL", "NFLX", "GOOGL")
  actual_symbols <- unique(simulated_data$symbol)
  expect_true(all(actual_symbols %in% expected_symbols), "The 'symbol' column contains unexpected values.")
})


