ui <- dashboardPage(
  skin = "green",
  title = "Biodiversity Observations in Poland",
  header = dashboardHeader(
    title = "Biodiversity Observations in Poland",
    titleWidth = 450
  ),
  sidebar = dashboardSidebar(
    sidebarMenu(
      collapsible = FALSE,
      menuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = icon("map")
      ),
      menuItem(
        "About",
        tabName = "about",
        icon = icon("info")
      ),
      menuItem(
        "Sources",
        tabName = "source",
        icon = icon("database")
      )
    )
  ),
  body = dashboardBody(
    tabItems(
      gbifUI("dashboard"),
      # About tab
      tabItem(
        tabName = "about",
        includeMarkdown("about.md")
      ),

      # Data source tab
      tabItem(
        tabName = "source",
        includeMarkdown("sources.md")
      )
    )
  ),
  footer = dashboardFooter(
    right = tags$i("Jesus M. Castagnetto (@jmcastagnetto) - 2022")
  )
)
