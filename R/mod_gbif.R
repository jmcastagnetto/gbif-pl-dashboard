# viz module

gbifUI <- function(id) {
  # Visualization tab
  tabItem(
    tabName = "dashboard",
    fluidRow( # top row
      box( # top left box
        width = 7,
        title = "Select organism by scientific or common name:",
        status = "primary",
        solidHeader = TRUE,
        tags$div(
          style = "background: #3C8DBC; padding-left: 5px; padding-right: 5px",
          selectizeInput(
            inputId = NS(id, "search_by_name"),
            label = "",
            choices = NULL,
            options = list(
              create = FALSE,
              maxItems = "1",
              closeAfterSelect = TRUE,
              placeholder = "Search for an organism"
            )
          )
        ),
        tags$hr(),
        sliderInput(
          inputId = NS(id, "range_years"),
          label = "Filter observations using a year range",
          min = overall_min_yr,
          max = overall_max_yr,
          step = 1,
          sep = "",
          value = c(overall_min_yr, overall_max_yr),
          ticks = FALSE
        )
      ), # end of top left box
      box( # top right box (barplot)
        width = 5,
        title = textOutput(NS(id,"bar_plot_title")),
        plotlyOutput(NS(id, "bar_plot"), height = 200)
      ), # end of top right box
    ), # end of top row
    fluidRow( # bottom row (map)
      leafletOutput(NS(id, "org_map"), height = 450)
    )
  )
}

gbifServer <- function(id) {
  moduleServer(id,
    function(input, output, session) {
      # populate the Selectize widget
      updateSelectizeInput(
        session,
        "search_by_name",
        choices = name_choices,
        selected = sample_organism,
        server = TRUE
      )

      org_name <- reactive({input$search_by_name})
      sci_name <- reactive({str_split_fixed(org_name(), " / ", n = 2)[1]})
      org_df <- reactive({
        pl_df %>%
          filter(scientificName == sci_name())
      })
      from_yr <- reactive({
        input$range_years[1]
      })
      to_yr <- reactive({
        input$range_years[2]
      })

      plot_df <- reactive({
        org_df() %>%
          filter(between(year, from_yr(), to_yr()))
      })

      # map
      output$org_map <- renderLeaflet({
        if (req(input$search_by_name) != sample_organism) {
          plot_org_map(plot_df())
        } else {
          plot_org_map(
            sample_df %>%
              filter(between(year, from_yr(), to_yr()))
          )
        }
      })

      # barplot title
      output$bar_plot_title <- renderText({org_name()})
      # barplot
      output$bar_plot <- renderPlotly({
        if (req(input$search_by_name) != sample_organism) {
          barplot_by_sciname(plot_df())
        } else {
          barplot_by_sciname(
            sample_df %>%
              filter(between(year, from_yr(), to_yr()))
          )
        }
      })

    }
  )
}