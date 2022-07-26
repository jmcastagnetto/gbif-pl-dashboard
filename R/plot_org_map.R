# leaflet map of the organism observations
plot_org_map <- function(plot_df = sample_df) {
  plot_df <- plot_df %>%
    arrange(eventDate)

  leaflet(
    data = plot_df,
    options = leafletOptions(
      minZoom = 6 # about country level
    )
  ) %>%
    addProviderTiles("CartoDB.Positron",
                     group = "CartoDB.Positron") %>%
    addProviderTiles("OpenStreetMap",
                     group = "OpenStreetMap") %>%
    addLayersControl( # tiles layers
      baseGroups = c("CartoDB.Positron",
                     "OpenStreetMap"),
      position = "topleft"
    ) %>%
    addEasyButton(
      easyButton(
        icon = "fa-globe",
        title = "Zoom to country level", # country level
        onClick = JS("function(btn, map){ map.setZoom(6); }")
      )
    ) %>%
    addMarkers(
      lng = ~ decimalLongitude,
      lat = ~ decimalLatitude,
      popup = ~ popup_lbl,
      label = ~ str_lbl,
      clusterOptions = markerClusterOptions()
    )
}
