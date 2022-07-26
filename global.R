library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(leaflet)
library(glue)
library(scales)
library(plotly)

# Load and prepare the data

pl_df <- readRDS("data/pl_data.rds")
names_df <- readRDS("data/species_names.rds")

overall_min_yr <- pl_df %>%
  pull(year) %>%
  min(na.rm = TRUE)

overall_max_yr <- pl_df %>%
  pull(year) %>%
  max(na.rm = TRUE)

sample_organism <- "Ciconia ciconia (Linnaeus, 1758) / White Stork"
sample_df <- pl_df %>%
  filter(org_name == sample_organism)

name_choices <- names_df %>%
  arrange(scientificName) %>%
  pull(org_name)
