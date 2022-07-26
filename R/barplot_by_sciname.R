# barplot using the scientific name
barplot_by_sciname <- function(plot_df = sample_df) {
  kingdom_color <- list(
    "Animalia" = "darkblue",
    "Plantae" = "lightgreen",
    "Fungi" = "darkred"
  )
  org_kingdom <- unique(plot_df$kingdom)
  plot_df <- plot_df %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(Total = sum(individualCount, na.rm = TRUE)) %>%
    ungroup() %>%
    rename(Year = year) %>%
    mutate(Year = factor(Year))

  ggplotly(
    ggplot(plot_df,
           aes(x = Year, y = Total)) +
      geom_col(fill = kingdom_color[org_kingdom]) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        y = "Individuals observed",
        x = "",
      ) +
      theme_classic() +
      theme(
        axis.text.x = element_text(size = 8, angle = 90, vjust = 0.5)
      )
  ) %>%
    config(
      displayModeBar = FALSE
    )
}

