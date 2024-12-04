#### Preamble ####
# Purpose: Constructs november and december models for predicting stock prices using xgboost
# Author: Jamie Lee
# Date: 2 December 2024
# Contact: jamiejimin.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: analysis_data.parquet
# Any other information needed? N/A

library(xgboost)
library(dplyr)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# November Model Training

# Train on data up to October 31, 2024
nov_train <- analysis_data %>%
  filter(as.Date(date) <= as.Date("2024-10-31"))

# Prepare November training features (X_train) and labels (y_train)
X_train_nov <- nov_train %>%
  select(Lag_1, Rolling_Mean_7, sma_20, sma_50, volatility, daily_return, symbol_encoded) %>%
  as.matrix()
y_train_nov <- as.numeric(nov_train$adjusted)

# Train the November XGBoost model
dtrain_nov <- xgb.DMatrix(data = X_train_nov, label = y_train_nov)
nov_model <- xgboost(
  data = dtrain_nov,
  max.depth = 6,
  eta = 0.1,
  nrounds = 100,
  objective = "reg:squarederror",
  verbose = 0
)

# Save November model
saveRDS(nov_model, "models/nov_model.rds")

# December Model Training

# Train on data up to November 30, 2024
dec_train <- analysis_data %>%
  filter(as.Date(date) <= as.Date("2024-11-30"))

# Prepare December training features (X_train) and labels (y_train)
X_train_dec <- dec_train %>%
  select(Lag_1, Rolling_Mean_7, sma_20, sma_50, volatility, daily_return, symbol_encoded) %>%
  as.matrix()
y_train_dec <- as.numeric(dec_train$adjusted)

# Train the December XGBoost model
dtrain_dec <- xgb.DMatrix(data = X_train_dec, label = y_train_dec)
dec_model <- xgboost(
  data = dtrain_dec,
  max.depth = 6,
  eta = 0.1,
  nrounds = 100,
  objective = "reg:squarederror",
  verbose = 0
)

# Save December model
saveRDS(dec_model, "models/dec_model.rds")



