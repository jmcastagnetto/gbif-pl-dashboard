library(tidyverse)
library(leaflet)

pl_df <- readRDS(here::here("data/pl_data.rds"))

sample_organism <- "Ciconia ciconia (Linnaeus, 1758) / White Stork"
sample_df <- pl_df %>%
  filter(org_name == sample_organism)

source(here::here("R/plot_org_map.R"))

map_obj <- plot_org_map()

test_that("object is of class leaflet/html_widget", {
  expect_true(isa(map_obj, c("leaflet", "htmlwidget")))
})

test_that("map has one or more markers",{
  expect_true(length(map_obj$x$calls[[5]]$args[[1]]) >= 1)
})

test_that("map has one of more labels", {
  expect_true(length(map_obj$x$calls[[5]]$args[[11]]) >= 1)
})

test_that("map has one of more popups", {
  expect_true(length(map_obj$x$calls[[5]]$args[[7]]) >= 1)
})
