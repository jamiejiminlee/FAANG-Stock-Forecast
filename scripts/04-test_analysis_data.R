#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

# Libraries
library(testthat)
library(dplyr)
library(arrow)

# Load the cleaned data
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Test 1: Check if the dataset is not empty
test_that("Dataset is not empty", {
  expect_true(nrow(analysis_data) > 0, "The dataset is empty.")
})

# Test 2: Check if the necessary columns are present in the dataset
test_that("Necessary columns are present", {
  expect_true(all(c("symbol", "date", "adjusted", "Lag_1", "Rolling_Mean_7", "sma_20", "sma_50", "volatility", "daily_return") %in% colnames(analysis_data)),
              "One or more required columns are missing.")
})

# Test 3: Check for missing values in critical columns
test_that("No missing values in critical columns", {
  expect_true(all(!is.na(analysis_data$adjusted)), "There are missing values in 'adjusted' column.")
  expect_true(all(!is.na(analysis_data$date)), "There are missing values in 'date' column.")
})

# Test 4: Ensure `Lag_1` does not have missing values except for the first row of each symbol
test_that("Lag_1 has no missing values except for first row", {
  missing_lag_1 <- analysis_data %>%
    group_by(symbol) %>%
    filter(row_number() != 1 & is.na(Lag_1))
  
  expect_true(nrow(missing_lag_1) == 0, "Lag_1 has missing values beyond the first row.")
})

# Test 5: Check for proper calculation of the rolling mean (it should have no missing values after the 7th row)
test_that("Rolling Mean is calculated properly", {
  rolling_mean_7_missing <- analysis_data %>%
    filter(is.na(Rolling_Mean_7) & date > min(date) + 6)
  
  expect_true(nrow(rolling_mean_7_missing) == 0, "Rolling Mean has missing values after the 7th row.")
})

# Test 6: Ensure `symbol` is properly encoded as a factor
test_that("symbol is encoded correctly", {
  expect_true(is.numeric(analysis_data$symbol_encoded), "'symbol_encoded' is not numeric.")
  expect_true(length(unique(analysis_data$symbol_encoded)) == length(unique(analysis_data$symbol)), "'symbol_encoded' does not match the number of unique symbols.")
})

# Test 7: Check for no missing values in `volatility`
test_that("Volatility has no missing values", {
  expect_true(all(!is.na(analysis_data$volatility)), "There are missing values in 'volatility' column.")
})

# Test 8: Ensure that daily return is not infinite or missing
test_that("Daily return has no infinite or missing values", {
  invalid_daily_return <- analysis_data %>%
    filter(is.na(daily_return) | is.infinite(daily_return))
  
  expect_true(nrow(invalid_daily_return) == 0, "There are invalid values (NA or Inf) in the 'daily_return' column.")
})


# Test 9: Ensure no duplicate rows exist
test_that("No duplicate rows", {
  duplicates <- analysis_data %>%
    filter(duplicated(.))
  
  expect_true(nrow(duplicates) == 0, "There are duplicate rows in the dataset.")
})

