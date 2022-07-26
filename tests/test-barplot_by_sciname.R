library(tidyverse)
library(glue)
library(scales)
library(plotly)

pl_df <- readRDS(here::here("data/pl_data.rds"))

sample_organism <- "Ciconia ciconia (Linnaeus, 1758) / White Stork"
sample_df <- pl_df %>%
  filter(org_name == sample_organism)
overall_min_yr <- pl_df %>%
  pull(year) %>%
  min(na.rm = TRUE)

overall_max_yr <- pl_df %>%
  pull(year) %>%
  max(na.rm = TRUE)

source(here::here("R/barplot_by_sciname.R"))

bar_obj <- barplot_by_sciname()

test_that("object is of class plotly/html_widget", {
  expect_true(isa(bar_obj, c("plotly", "htmlwidget")))
})

test_that("plot of of type bar", {
  expect_equal(bar_obj$x$data[[1]]$type, "bar")
})

test_that("y axis values are >= 1", {
  expect_true(length(bar_obj$x$data[[1]]$y) >= 1)
})