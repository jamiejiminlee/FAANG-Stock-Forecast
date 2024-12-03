# Post-Election FAANG Stock Price Predictions: Insights from an XGBoost Model

## Overview

This repo documents the steps and processes used in creating the paper "Predicting Post-Election FAANG Stock Prices: Accurate November Trends and Flat December Projections".

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Yahoo Finance API.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models for both candidates. 
-   `other` contains survey file, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to test, simulate, download and clean data.

## Statement on LLM Usage

Aspects of the code were written with the assistance of ChatGPT. The data cleaning, testing and modelling scripts, as well as discussions, results, introduction, model sections were written with the help of ChatGPT and the entire chat history is available in inputs/llms/usage.txt.